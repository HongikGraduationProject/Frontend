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

public class ClickToStartVC: UIViewController {
    
    // Init
    
    // View
    let titleLabel: CapLabel = {
        let label = CapLabel()
        label.typographyStyle = .extraLargeBold
        label.attrTextColor = .black
        label.textAlignment = .center
        label.text = "반갑습니다!"
        return label
    }()
    let subTitleLabel: CapLabel = {
        let label = CapLabel()
        label.typographyStyle = .baseRegular
        label.attrTextColor = .black
        label.textAlignment = .center
        label.text = "Shortcap과 함께, 더 똑똑한 숏폼의 세계로!"
        return label
    }()
    let nextButton: CapBottomButton = .init(labelText: "여기를 눌러 시작하기")
    
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
}


#Preview("Preview", traits: .defaultLayout) {
    
    ClickToStartVC()
}
    
