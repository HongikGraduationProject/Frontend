//
//  SummaryDetailVC.swift
//  MainAppFeatures
//
//  Created by choijunios on 8/22/24.
//

import UIKit
import BaseFeature
import RxCocoa
import RxSwift
import Entity
import DSKit
import UseCase
import CommonUI

public class SummaryDetailVC: BaseVC {
    
    // Init
    
    // Not init
    var viewModel: SummaryDetailVM?
    
    // View
    let navigationBar: CAPSummaryDetailNavigationBar = {
        let bar = CAPSummaryDetailNavigationBar(titleText: "상세보기")
        return bar
    }()
    
    let titleLabel: CapLabel = {
        let label = CapLabel()
        label.typographyStyle = .extraLargeMedium
        return label
    }()
    
    let originalVideoWebView: UIView = {
        let view = UIView()
        view.backgroundColor = DSColors.gray10.color
        return view
    }()
    
    // MARK: 키워드
    let keywordLabel: CapLabel = {
        let label = CapLabel()
        label.typographyStyle = .extraLargeMedium
        label.text = "키워드 분석"
        return label
    }()
    let keywordCollectionView: SummaryKeywordCollectionView = {
        let view = SummaryKeywordCollectionView()
        return view
    }()
    
    // MARK: 스크립트
    let scriptLabel: CapLabel = {
        let label = CapLabel()
        label.typographyStyle = .extraLargeMedium
        label.text = "스크립트 자동 요약"
        return label
    }()
    let scriptContentLabel: CapLabel = {
        let label = CapLabel()
        label.typographyStyle = .baseRegular
        label.attrTextColor = DSColors.gray50.color
        label.numberOfLines = 0
        return label
    }()
    
    
    
    // Observable
    private let disposeBag = DisposeBag()
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) { fatalError() }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setAppearance()
        setLayout()
        setObservable()
    }
    
    private func setAppearance() {
        view.backgroundColor = DSColors.gray0.color
    }
    
    private func setLayout() {
        
        let viewList = [
            Spacer(height: 20),
            titleLabel,
            Spacer(height: 22),
            originalVideoWebView,
            Spacer(height: 35),
            HStack([keywordLabel, Spacer()], alignment: .fill),
            Spacer(height: 16),
            keywordCollectionView,
            Spacer(height: 23),
            Spacer(height: 1, color: .gray),
            Spacer(height: 28),
            HStack([scriptLabel, Spacer()], alignment: .fill),
            Spacer(height: 28),
            scriptContentLabel,
        ]
        let contentView = VStack(viewList, alignment: .fill)
        
        let scrollView = UIScrollView()
        scrollView.contentInset.left = 20
        scrollView.contentInset.right = 20
        scrollView.delaysContentTouches = false
        let contentGuide = scrollView.contentLayoutGuide
        let frameGuide = scrollView.frameLayoutGuide
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            originalVideoWebView.heightAnchor.constraint(equalToConstant: 210),
            
            keywordCollectionView.heightAnchor.constraint(equalToConstant: 66),
            
            contentView.topAnchor.constraint(equalTo: contentGuide.topAnchor),
            contentView.leftAnchor.constraint(equalTo: contentGuide.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: contentGuide.rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentGuide.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: frameGuide.widthAnchor, constant: -40),
        ])
        
        
        [
            navigationBar,
            scrollView,
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            navigationBar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            
            scrollView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setObservable() {
        
        // 임시 설정
        navigationBar.backButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    public func bind(viewModel: SummaryDetailVM) {
        
        self.viewModel = viewModel
        
        rx.viewDidLoad.bind(to: viewModel.viewDidLoad).disposed(by: disposeBag)
        
        viewModel
            .summaryDetail?
            .drive(onNext: { [weak self] detail in
                guard let self else { return }
                titleLabel.text = detail.title
                keywordCollectionView.setKeywords(keywords: detail.keywords)
                scriptContentLabel.text = detail.summary
            })
            .disposed(by: disposeBag)
    }
}

