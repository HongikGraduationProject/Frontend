//
//  MainCategoryTabButton.swift
//  DSKit
//
//  Created by choijunios on 8/21/24.
//

import UIKit
import Entity
import RxSwift
import RxCocoa

public class MainCategoryTabButton: TappableUIView {
    
    enum State {
        case idle
        case accent
    }
    
    // Init
    let itemWidth: CGFloat
    let mainCategory: MainCategory
    
    // View
    let label: CapLabel = {
        let label = CapLabel()
        return label
    }()
    
    private let touchEffectView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = DSColors.gray30.color.withAlphaComponent(0.3)
        view.alpha = 0
        return view
    }()
    
    public override var intrinsicContentSize: CGSize {
        .init(width: itemWidth, height: 28)
    }
    
    let disposeBag = DisposeBag()
    
    public init(mainCategory: MainCategory, itemWidth: CGFloat) {
        self.itemWidth = itemWidth
        self.mainCategory = mainCategory
        super.init()
        
        setAppearance()
        setLayout()
        setObservable()
        
        // 기본상태: idle
        toIdle()
    }
    public required init?(coder: NSCoder) { return nil }
    
    private func setAppearance() {
        self.backgroundColor = DSColors.gray0.color
        label.text = mainCategory.korWordText
    }
    
    private func setLayout() {
        [
            label,
            touchEffectView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        label.layer.zPosition = 0
        touchEffectView.layer.zPosition = 1
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -4),
            
            touchEffectView.topAnchor.constraint(equalTo: self.topAnchor),
            touchEffectView.leftAnchor.constraint(equalTo: self.leftAnchor),
            touchEffectView.rightAnchor.constraint(equalTo: self.rightAnchor),
            touchEffectView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    private func setObservable() {
        rx.tap
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                
                touchEffectView.alpha = 1
                UIView.animate(withDuration: 0.2) {
                    self.touchEffectView.alpha = 0
                    self.toAccent()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func toIdle() {
        label.typographyStyle = .baseRegular
        label.attrTextColor = DSColors.gray40.color
    }
    
    func toAccent() {
        label.typographyStyle = .baseSemiBold
        label.attrTextColor = DSColors.primary80.color
    }
}

@available(iOS 17.0, *)
#Preview("Preview", traits: .defaultLayout) {
    
    MainCategoryTabButton(mainCategory: .all, itemWidth: 54)
}
