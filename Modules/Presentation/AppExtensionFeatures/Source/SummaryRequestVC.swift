//
//  SummaryRequestVC.swift
//  AppExtensionFeatures
//
//  Created by choijunios on 8/21/24.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
import Entity
import UseCase
import Repository
import DataSource
import RxCocoa
import RxSwift
import DSKit
import CommonFeature
import CommonUI
import Util

enum FetchingResourceType: String, CaseIterable {
    case url
    case text
    
    var identifier: String {
        switch self {
        case .url:
            UTType.url.identifier
        case .text:
            UTType.text.identifier
        }
    }
}

enum FetchResourceError: Error {
    case `default`
}

open class SummaryRequestVC: UIViewController {
    
    // Repository
    @Injected private var summaryRequestRepo: SummaryRequestRepository
    @Injected private var videoCodeRepo: VideoCodeRepository
    @Injected private var authUseCase: AuthUseCase
    
    // View
    let titleLabel: CapLabel = {
        let label = CapLabel()
        label.typographyStyle = .largeBold
        label.attrTextColor = DSColors.gray90.color
        label.text = "숏폼의 저장방식을 선택해주세요"
        return label
    }()
    let autoArrangeButton: CapBottomButton = {
        let button = CapBottomButton(labelText: "AI로 분류하기")
        button.alpha = 0
        button.setState(true)
        return button
    }()
    let selfArrangeButton: CapBottomButtonUIButtonVer = {
        let button = CapBottomButtonUIButtonVer(labelText: "카테고리 선택하기")
        button.alpha = 0
        button.setState(true)
        return button
    }()
    let closeButton: CapBottomButton = {
        let button = CapBottomButton(labelText: "닫기")
        button.alpha = 0
        button.setState(true)
        return button
    }()
    
    let loadingIndicatorView: CAPLoadingIndicatorView = .init()
    
    // Observable
    let tokenRequestFinishedSuccessFully: PublishRelay<Void> = .init()
    let mainCategoryPublisher: PublishRelay<MainCategory> = .init()
    let disposeBag = DisposeBag()

    public override func viewDidLoad() {
        super.viewDidLoad()
        setMenuView()
        setAppearance()
        setLayout()
        setObservable()
        
        // 토큰요청부터 플로우 시작
        startFlow()
    }
    
    func setMenuView() {
        var items = MainCategory.allCases.filter { $0 != .all }.map { cat in
            let action = UIAction(
                title: cat.korWordText,
                image: cat.image,
                handler: { [mainCategoryPublisher] _ in
                    mainCategoryPublisher.accept(cat)
            })
            return action
        }
        let cancel = UIAction(title: "닫기", attributes: .destructive, handler: { _ in print("닫기") })
        items.append(cancel)
        
        let menu = UIMenu(title: "숏폼 카테고리", children: items)
        selfArrangeButton.menu = menu
        selfArrangeButton.showsMenuAsPrimaryAction = true
    }
    
    func setAppearance() {
        view.backgroundColor = DSColors.gray0.color
        view.clipsToBounds = true
    }
    
    func setLayout() {
        let buttonStack = VStack([
            selfArrangeButton,
            autoArrangeButton
        ], spacing: 4, alignment: .fill)
        
        [
            titleLabel,
            buttonStack,
            closeButton,
            loadingIndicatorView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            buttonStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            buttonStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            buttonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            closeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            closeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            loadingIndicatorView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingIndicatorView.leftAnchor.constraint(equalTo: view.leftAnchor),
            loadingIndicatorView.rightAnchor.constraint(equalTo: view.rightAnchor),
            loadingIndicatorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func setObservable() {
        
        // MARK: URL 가져오기
        let fetchUrlResult = tokenRequestFinishedSuccessFully.flatMap { [weak self] _ -> Single<Result<String, FetchResourceError>> in
            guard let self else { return .never() }
            return fetchUrl()
        }
        let fetchUrlSuccess = fetchUrlResult.compactMap { $0.value }
        let fetchUrlFailure = fetchUrlResult.compactMap { $0.error }
        
        fetchUrlFailure
            .subscribe(onNext: { [weak self] _ in
                printIfDebug("‼️ URL획득에 실패했습니다.")
                self?.onFailure()
            })
            .disposed(by: disposeBag)
        
        // MARK: 카테고리 서택 or 자동선택
        let categorySelectionMethod = Observable
            .merge(
                mainCategoryPublisher.map({ cat -> MainCategory? in cat }),
                autoArrangeButton.rx.tap.map({ _ -> MainCategory? in nil })
            )
            
        // MARK: 요약 시작요청
        let summaryInitiationResult = Observable
            .zip(
                fetchUrlSuccess.map({ [weak self] url in
                        self?.showCategoriButtons()
                        return url
                    }),
                categorySelectionMethod
            )
            .observe(on: MainScheduler.instance)
            .flatMap { [weak self] (url, category) -> Single<String> in
                
                guard let self else { return .never() }
                
                self.autoArrangeButton.setState(false)
                self.selfArrangeButton.setState(false)
                
                self.loadingIndicatorView.turnOn(duration: 0.35)
                
                UIView.animate(withDuration: 0.35) {
                    self.autoArrangeButton.alpha = 0
                    self.selfArrangeButton.alpha = 0
                }
                
                return summaryRequestRepo
                    .initiateSummary(
                        url: url,
                        category: category
                    )
            }
        
        summaryInitiationResult
            .flatMap({ [videoCodeRepo] videoCode in
                videoCodeRepo
                    .saveVideoCode(videoCode)
            })
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                // 비디오 코드 저장 성공
                loadingIndicatorView.turnOff(duration: 0.35)
                onSuccess()
                
            }, onError: { [weak self] _ in
                guard let self else { return }
                // 비디오 코드 저장 실패
                loadingIndicatorView.turnOff(duration: 0.35)
                onFailure()
            })
            .disposed(by: disposeBag)
        
        closeButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.done()
        })
        .disposed(by: disposeBag)
    }
    
    func onSuccess() {
        titleLabel.text = "숏폼이 성공적으로 저장됬습니다."
        UIView.animate(withDuration: 0.35) {
            self.closeButton.alpha = 1
        }
    }
    
    func onFailure() {
        titleLabel.text = "숏폼저장에 실패했습니다."
        titleLabel.attrTextColor = DSColors.red0.color
        UIView.animate(withDuration: 0.35) {
            self.closeButton.alpha = 1
        }
    }
    
    func showCategoriButtons() {
        UIView.animate(withDuration: 0.35) {
            self.autoArrangeButton.alpha = 1
            self.selfArrangeButton.alpha = 1
        }
    }
    
    func startFlow() {
        
        // MARK: 토큰 가져오기
        if authUseCase.checkIsExistingMemeber() {
            tokenRequestFinishedSuccessFully.accept(())
        } else {
            
            let tokenGenResult = authUseCase.generateToken()
            let tokenGenSuccess = tokenGenResult.compactMap { $0.value }
            let tokenGenFailure = tokenGenResult.compactMap { $0.error }
            
            tokenGenSuccess
                .asObservable()
                .map({ _ in
                    printIfDebug("✅ 토큰 생성에 성공했습니다.")
                })
                .bind(to: tokenRequestFinishedSuccessFully)
                .disposed(by: disposeBag)
                
            tokenGenFailure
                .subscribe { [weak self] error in
                    guard let self else { return }
                    
                    printIfDebug("‼️ 토큰 생성에 실패했습니다.")
                    
                    onFailure()
                }
                .disposed(by: disposeBag)
        }
    }

    func done() {
        self.extensionContext!.completeRequest(returningItems: nil)
    }
    
    func fetchUrl() -> Single<Result<String, FetchResourceError>> {
        
        guard let item = (self.extensionContext?.inputItems as? [NSExtensionItem])?.first,
              let provider = item.attachments?.first else {
            return .just(.failure(.default))
        }
        
        return Single<Result<String, FetchResourceError>>.create { single in
        
            var isMatched = false
            
            for item in FetchingResourceType.allCases {
                let identifier = item.identifier
                if provider.hasItemConformingToTypeIdentifier(identifier) {
                    
                    isMatched = true
                        
                    provider.loadItem(forTypeIdentifier: identifier) { (resource, error) in
                        
                        if error != nil {
                            single(.success(.failure(.default)))
                            return
                        }
                        
                        if let url = resource as? URL {
                            single(.success(.success(url.absoluteString)))
                            return
                        }
                        
                        if let text = resource as? String {
                            single(.success(.success(text)))
                            return
                        }
                        
                        single(.success(.failure(.default)))
                    }
                }
            }
            
            if !isMatched {
                // 요구하는 리소스가 없는 경우
                single(.success(.failure(.default)))
            }
            
            return Disposables.create()
        }
    }
}

class CapBottomButtonUIButtonVer: UIButton {
    
    // Views
    let label: CapLabel = {
        let label = CapLabel()
        label.numberOfLines = 2
        label.typographyStyle = .baseSemiBold
        label.attrTextColor = .white
        return label
    }()
    
    public var idleBackgroundColor: UIColor = DSKitAsset.Colors.primary90.color
    public var idleTextColor: UIColor = .white
    
    public var accentBackgroundColor: UIColor = DSKitAsset.Colors.gray10.color
    public var accentTextColor: UIColor = DSKitAsset.Colors.gray40.color
    
    public override var intrinsicContentSize: CGSize {
        .init(
            width: super.intrinsicContentSize.width,
            height: 50
        )
    }
    
    private let disposeBag = DisposeBag()
    
    public init(labelText: String) {
        super.init(frame: .zero)
        
        // 라벨 설정
        label.text = labelText
        
        setAppearance()
        setLayout()
        setObservable()
        
        // 초기상태는 클릭불가 상태를 기본으로 합니다.
        setState(false)
    }
    public required init?(coder: NSCoder) { fatalError() }
    
    private func setAppearance() {
        self.backgroundColor = DSKitAsset.Colors.primary90.color
        self.layer.cornerRadius = 12
    }
    
    private func setLayout() {
        [
            label
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    private func setObservable() {
        self.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                setAppearanceToAccent()
                UIView.animate(withDuration: 0.5) { [weak self] in
                    self?.setAppearanceToIdle()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setAppearanceToIdle() {
        label.attrTextColor = idleTextColor
        self.backgroundColor = idleBackgroundColor
    }
    
    private func setAppearanceToAccent() {
        label.attrTextColor = accentTextColor
        self.backgroundColor = accentBackgroundColor
    }
    
    private func setAppearanceToDisabled() {
        self.backgroundColor = DSKitAsset.Colors.gray10.color
        label.attrTextColor = DSKitAsset.Colors.gray40.color
    }
    
    @MainActor
    public func setState(_ isEnabled: Bool) {
        
        self.isUserInteractionEnabled = isEnabled
        
        if isEnabled {
            setAppearanceToIdle()
        } else {
            setAppearanceToDisabled()
        }
    }
}
