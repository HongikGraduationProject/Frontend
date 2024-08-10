//
//  HuntingShortFormVM.swift
//  MainAppFeatures
//
//  Created by choijunios on 8/10/24.
//

import UIKit
import RxCocoa
import Entity

public class HuntingShortFormVM: HuntingShortFormViewModelable {
    
    // Output
    public var alert: Driver<CapAlertVO>?
    
    // ViewModel native
    private let deepLinkError: PublishRelay<String> = .init()
    
    public init() {
        
        // Output
        alert = deepLinkError
            .map { message in
                CapAlertVO(title: "숏폼 찾으로 가기 오류", message: message)
            }
            .asDriver(onErrorJustReturn: .default)
    }
    
    private let youtubeDeepLink: String = "youtube://www.youtube.com/shorts"
    private let instagramDeepLink: String = "instagram://"
    
    public func openYoutubeApp() {
        openDeepLink(url: .init(string: youtubeDeepLink)!)
    }
    
    public func openInstagramApp() {
        openDeepLink(url: .init(string: instagramDeepLink)!)
    }
    
    private func openDeepLink(url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            deepLinkError.accept("클릭한 앱을 열 수 없습니다.")
        }
    }
}
