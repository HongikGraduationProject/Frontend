//
//  ClickToStartVM.swift
//  MainAppFeatures
//
//  Created by choijunios on 8/12/24.
//

import UIKit
import BaseFeature
import RxCocoa
import RxSwift
import Entity
import DSKit
import UseCase
import Util
import AppTrackingTransparency
import AdSupport

public protocol ClickToStartViewModelable {
    
    var nextButtonClicked: PublishRelay<Void> { get }
    var viewWillAppear: PublishRelay<Void> { get }
}

public class ClickToStartVM: ClickToStartViewModelable {
    
    public weak var coordinator: ClickToStartCO?
    
    public var nextButtonClicked: PublishRelay<Void> = .init()
    public var viewWillAppear: RxRelay.PublishRelay<Void> = .init()
    
    let disposeBag: DisposeBag = .init()
    
    public init() {
        
        nextButtonClicked
            .subscribe(onNext: { [weak self] _ in
                
                self?.coordinator?.showCategoryScreen()
            })
            .disposed(by: disposeBag)
        
        viewWillAppear
            .subscribe(onNext: { [weak self] _ in
                
                self?.requestPermission()
            })
            .disposed(by: disposeBag)
    }
}

extension ClickToStartVM {
    
    /// 앱추적 허용 요청
    func requestPermission() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    // Tracking authorization dialog was shown
                    // and we are authorized
                    printIfDebug("앱추적권한: Authorized")
                    
                    // 추적을 허용한 사용자 식별자
//                    printIfDebugIfDebug(ASIdentifierManager.shared().advertisingIdentifier)
                case .denied:
                    // Tracking authorization dialog was
                    // shown and permission is denied
                    printIfDebug("앱추적권한: Denied")
                case .notDetermined:
                    // Tracking authorization dialog has not been shown
                    printIfDebug("앱추적권한: Not Determined")
                case .restricted:
                    printIfDebug("앱추적권한: Restricted")
                @unknown default:
                    printIfDebug("앱추적권한: Unknown")
                }
            }
        }
    }
}

