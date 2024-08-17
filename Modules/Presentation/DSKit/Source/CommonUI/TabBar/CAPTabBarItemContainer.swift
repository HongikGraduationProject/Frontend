//
//  CAPTabBarItemContainer.swift
//  DSKit
//
//  Created by choijunios on 8/17/24.
//

import UIKit
import RxSwift
import RxCocoa

public class CAPTabBarItemContainer: UIView {
    
    // View
    private let contentStack: HStack
    
    // Layer
    private var shapeLayer: CAShapeLayer!
    
    public init(items: [UIView]) {
        self.contentStack = HStack(items, spacing: 0, distribution: .fillEqually)
        super.init(frame: .zero)
        setAppearance()
        // 최하단 레이어를 먼저 삽입
        setupLayer()
        setLayout()
    }
    public required init?(coder: NSCoder) { nil }
    
    private func setAppearance() { }
    
    private func setLayout() {
        
        self.layoutMargins  = .init(
            top: 12,
            left: 10.5,
            bottom: 20,
            right: 10.5
        )
        
        [
            contentStack
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            contentStack.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor),
            contentStack.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor),
            contentStack.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor),
        ])
    }
    
    private func setupLayer() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = DSColors.gray0.color.cgColor
        
        // 그림자 설정
        shapeLayer.shadowColor = UIColor.black.cgColor
        shapeLayer.shadowOpacity = 0.15
        shapeLayer.shadowOffset = CGSize(width: 0, height: -3)
        shapeLayer.shadowRadius = 12
        
        self.layer.addSublayer(shapeLayer)
        self.shapeLayer = shapeLayer
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        guard let shapeLayer = shapeLayer else { return }
        
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: 30, height: 30)
        )
        shapeLayer.shadowPath = path.cgPath
        shapeLayer.path = path.cgPath
    }
}

// MARK: Test
fileprivate class TestItem: UIView {
    
    override var intrinsicContentSize: CGSize {
        .init(width: super.intrinsicContentSize.width, height: 82)
    }
    init(color: UIColor) {
        super.init(frame: .zero)
        self.backgroundColor = color
    }
    required init?(coder: NSCoder) {
        return nil
    }
}

@available(iOS 17.0, *)
#Preview("Preview", traits: .defaultLayout) {
    
    let view = CAPTabBarItemContainer(items: [
        TestItem(color: .red),
        TestItem(color: .blue),
        TestItem(color: .black),
        TestItem(color: .orange),
    ])
    return view
}
