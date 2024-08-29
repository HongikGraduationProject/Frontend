//
//  HuntingShortFormVC.swift
//  MainAppFeatures
//
//  Created by choijunios on 8/10/24.
//

import UIKit
import Util
import RxCocoa
import RxSwift
import Entity
import DSKit
import CommonUI
import PresentationUtil

public protocol HuntingShortFormViewModelable: BaseVMable {
    func openYoutubeApp()
    func openInstagramApp()
}

public class HuntingShortFormVC: BaseVC {
    
    var viewModel: HuntingShortFormViewModelable?
    
    // Init
    
    // View
    let titleLabel: UILabel = {
        let label = UILabel()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.25
        paragraphStyle.paragraphSpacing = 20
        paragraphStyle.alignment = .center

        let attributes: [NSAttributedString.Key: Any] = [
            .font: DSKitFontFamily.GmarketSansTTF.bold.font(size: 24),
            .kern: -0.025 * 24,
            .paragraphStyle: paragraphStyle
        ]

        label.attributedText = NSAttributedString(string: "아직 저장된 숏폼이 없어요!", attributes: attributes)
        
        return label
    }()
    let subTitleLabel: CapLabel = {
        let label = CapLabel()
        label.typographyStyle = .baseRegular
        label.attrTextColor = DSKitAsset.Colors.gray50.color
        label.textAlignment = .center
        label.text = "새로운 숏폼을 저장해 볼까요?"
        return label
    }()
    
    let youtubeButton: CAPImageButton = {
        let bgView = UIView()
        bgView.backgroundColor = DSKitAsset.Colors.red0.color
        let imageButton = CAPImageButton(
            backgroundView: bgView,
            labelText: "유튜브 탐방하기"
        )
        imageButton.imageView.image = DSKitAsset.Images.youtubeBadge.image
        return imageButton
    }()
    let instagramButton: CAPImageButton = {
        let bgView = UIView()
        bgView.backgroundColor = .systemPink
        let imageButton = CAPImageButton(
            backgroundView: bgView,
            labelText: "인스타그램 탐방하기"
        )
        imageButton.imageView.image = DSKitAsset.Images.instagramBadge.image
        return imageButton
    }()
    
    // Observable
    private let disposeBag = DisposeBag()
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) { fatalError() }
    
    public override func viewDidLoad() {
        setAppearance()
        setLayout()
    }
    
    private func setAppearance() {
        view.backgroundColor = UsualSettings.defaultBackgroundColor
    }
    
    private func setLayout() {
        let titleLabelStack = VStack([titleLabel, subTitleLabel], spacing: 8, alignment: .center)
        let imageView = DSKitAsset.Images.onBoardingMain.image.toView()
        let imageAndTitleStack = VStack([imageView, titleLabelStack], spacing: 31, alignment: .center)
        
        let buttonStack = VStack([instagramButton, youtubeButton], spacing: 10, alignment: .fill)
        
        let mainStack = VStack([imageAndTitleStack, buttonStack], spacing: 88, alignment: .fill)
        
        [
            mainStack
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 202),
            
            mainStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            mainStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            mainStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func setObservable() {
        
    }
    
    public func bind(viewModel: HuntingShortFormViewModelable) {
        
        self.viewModel = viewModel
        
        // Input
        youtubeButton
            .rx.tap
            .subscribe(onNext: { [viewModel] _ in
                viewModel.openYoutubeApp()
            })
            .disposed(by: disposeBag)
        
        instagramButton
            .rx.tap
            .subscribe(onNext: { [viewModel] _ in
                viewModel.openInstagramApp()
            })
            .disposed(by: disposeBag)
        
        // Output
        viewModel
            .alert?
            .drive(onNext: { [weak self] alertVO in
                self?.showAlert(alertVO: alertVO)
            })
            .disposed(by: disposeBag)
    }
}

