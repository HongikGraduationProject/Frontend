//
//  ClickToStartVC.swift
//  App
//
//  Created by choijunios on 8/6/24.
//

import UIKit
import RxCocoa
import RxSwift
import Entity
import DSKit
import CommonUI

public class ClickToStartVC: UIViewController {
    
    var viewModel: ClickToStartViewModelable?
    
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

        label.attributedText = NSAttributedString(string: "반갑습니다!", attributes: attributes)
        
        return label
    }()
    let subTitleLabel: CapLabel = {
        let label = CapLabel()
        label.typographyStyle = .baseRegular
        label.attrTextColor = DSKitAsset.Colors.gray50.color
        label.textAlignment = .center
        label.text = "Shortcap과 함께, 더 똑똑한 숏폼의 세계로!"
        return label
    }()
    let nextButton: CapBottomButton = {
        let button = CapBottomButton(labelText: "여기를 눌러 시작하기")
        button.setState(true)
        return button
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
        setObservable()
    }
    
    private func setAppearance() {
        view.backgroundColor = .white
    }
    
    private func setLayout() {
        let titleLabelStack = VStack([titleLabel, subTitleLabel], spacing: 12, alignment: .center)
        let imageView = DSKitAsset.Images.onBoardingMain.image.toView()
        let imageAndTitleStack = VStack([imageView, titleLabelStack], spacing: 65, alignment: .center)
        
        [
            imageAndTitleStack,
            nextButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 202),
            
            imageAndTitleStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageAndTitleStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            nextButton.topAnchor.constraint(equalTo: imageAndTitleStack.bottomAnchor, constant: 84),
            nextButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
        ])
    }
    
    private func setObservable() {
        
    }
    
    public func bind(viewModel: ClickToStartViewModelable) {
        
        self.viewModel = viewModel
        
        nextButton
            .rx.tap
            .bind(to: viewModel.nextButtonClicked)
            .disposed(by: disposeBag)
        
        rx.viewWillAppear
            .map { _ in  }
            .bind(to: viewModel.viewWillAppear)
            .disposed(by: disposeBag)
    }
}


#Preview("Preview", traits: .defaultLayout) {
    
    ClickToStartVC()
}
    
