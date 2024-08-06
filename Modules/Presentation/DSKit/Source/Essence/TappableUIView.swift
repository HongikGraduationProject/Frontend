//
//  TappableUIView.swift
//  DSKit
//
//  Created by choijunios on 8/6/24.
//

import UIKit
import RxSwift
import RxCocoa

open class TappableUIView: UIView {
    
    public init() {
        super.init(frame: .zero)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTouchAction))
        self.addGestureRecognizer(tapGesture)
    }
    public required init?(coder: NSCoder) { fatalError() }
    
    @objc
    func onTouchAction(_ tapGesture: UITapGestureRecognizer) { }
}

public extension Reactive where Base: TappableUIView {
    var tap: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.onTouchAction)).map { _ in }
        return ControlEvent(events: source)
    }
}
