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
        label.typographyStyle = .baseBold
        label.attrTextColor = .white
        return label
    }()
    
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
    }
    public required init?(coder: NSCoder) { fatalError() }
    
    private func setAppearance() {
        self.backgroundColor = .blue
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
                alpha = 0.5
                UIView.animate(withDuration: 0.35) { [weak self] in
                    self?.alpha = 1.0
                }
            })
            .disposed(by: disposeBag)
    }
}

#Preview("CapBottomButton", traits: .defaultLayout) {
    
    CapBottomButton(labelText: "여기룰 눌러 시작하기")
}
    

