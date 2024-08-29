//
//  BasePresentation.swift
//  BaseFeature
//
//  Created by choijunios on 8/10/24.
//

import UIKit
import RxCocoa
import Entity

/// Shortcap 기본 ViewModel인터페이 입니다.
public protocol BaseVMable {
    var alert: Driver<CapAlertVO>? { get }
}

/// Shortcap 기본 ViewController객체입니다.
open class BaseVC: UIViewController {
    public func showAlert(alertVO: CapAlertVO) {
        let alert = UIAlertController(title: alertVO.title, message: alertVO.message, preferredStyle: .alert)
        alertVO.info.forEach { (title, action) in
            let alertAction = UIAlertAction(title: title, style: .default) { _ in
                action?()
            }
            alert.addAction(alertAction)
        }
        present(alert, animated: true, completion: nil)
    }
}
