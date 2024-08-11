//
//  CapBottomButton.swift
//  DSKit
//
//  Created by choijunios on 8/6/24.
//

import UIKit
import RxSwift

/// 설명: 바텀 넓은 영역을 차지하는 버튼으 버튼중간에 라벨이 표시됩니다.
/// IntrinsicContentSize정보
///     - width: flexible
///     - height: 50
public class CapBottomButton: TappableUIView {
    
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
        super.init()
        
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

#Preview("CapBottomButton", traits: .defaultLayout) {
    
    CapBottomButton(labelText: "여기룰 눌러 시작하기")
}
    

