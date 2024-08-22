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

public class MainCategoryTabButton: VStack {
    
    enum State {
        case idle
        case accent
    }
    
    // Init
    let itemWidth: CGFloat
    let mainCategory: MainCategory
    
    // View
    lazy var touchArea: TappableUIView = {
        let view = TappableUIView()
        view.backgroundColor = DSColors.gray0.color
        return view
    }()
    
    let label: CapLabel = {
        let label = CapLabel()
        return label
    }()
    
    private let selectedBar: UIView = {
        let bar = UIView()
        bar.backgroundColor = DSColors.primary80.color
        return bar
    }()
    
    private let touchEffectView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = DSColors.gray30.color.withAlphaComponent(0.3)
        view.alpha = 0
        return view
    }()
    
    public override var intrinsicContentSize: CGSize {
        .init(
            width: itemWidth,
            height: super.intrinsicContentSize.height
        )
    }
    
    let disposeBag = DisposeBag()
    
    public init(mainCategory: MainCategory, itemWidth: CGFloat) {
        self.itemWidth = itemWidth
        self.mainCategory = mainCategory
        super.init([], spacing: 0, alignment: .fill)
        
        setAppearance()
        setLayout()
        setObservable()
        
        // 기본상태: idle
        toIdle()
    }
    public required init(coder: NSCoder) { fatalError() }
    
    private func setAppearance() {
        self.backgroundColor = DSColors.gray10.color
        label.text = mainCategory.twoLetterKorWordText
    }
    
    private func setLayout() {
        
        setTouchAreaLayout()
        
        [
            touchArea,
            selectedBar
        ].forEach {
            self.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            selectedBar.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    private func setTouchAreaLayout() {
        [
            label,
            touchEffectView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            touchArea.addSubview($0)
        }
        label.layer.zPosition = 0
        touchEffectView.layer.zPosition = 1
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: touchArea.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: touchArea.centerYAnchor, constant: -2),
            
            touchEffectView.topAnchor.constraint(equalTo: touchArea.topAnchor),
            touchEffectView.leftAnchor.constraint(equalTo: touchArea.leftAnchor),
            touchEffectView.rightAnchor.constraint(equalTo: touchArea.rightAnchor),
            touchEffectView.bottomAnchor.constraint(equalTo: touchArea.bottomAnchor),
        ])
    }
    
    private func setObservable() {
        touchArea.rx.tap
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
        selectedBar.alpha = 0
    }
    
    func toAccent() {
        label.typographyStyle = .baseSemiBold
        label.attrTextColor = DSColors.primary80.color
        selectedBar.alpha = 1
    }
}

@available(iOS 17.0, *)
#Preview("Preview", traits: .defaultLayout) {
    
    let b1 = MainCategoryTabButton(mainCategory: .all, itemWidth: 54)
    let b2 = MainCategoryTabButton(mainCategory: .all, itemWidth: 54)
    
    return HStack([
        b1, b2
    ], alignment: .fill)
}
