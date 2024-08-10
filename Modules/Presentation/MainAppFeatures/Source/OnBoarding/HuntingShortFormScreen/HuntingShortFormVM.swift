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
    private let youtubeWebLink: String = "https://www.youtube.com/shorts"
    
    private let instagramDeepLink: String = "instagram://"
    private let instagramWebLink: String = "https://www.instagram.com/reels"
    
    public func openYoutubeApp() {
        let deepLink: URL = .init(string: youtubeDeepLink)!
        let webLink: URL = .init(string: youtubeWebLink)!
        
        if openDeepLink(url: deepLink) {
            return
        }
        
        if openDeepLink(url: webLink) {
            return
        }
        deepLinkError.accept("유튜브를 열 수 없습니다.")
    }
    
    public func openInstagramApp() {
        let deepLink: URL = .init(string: instagramDeepLink)!
        let webLink: URL = .init(string: instagramWebLink)!
        
        if openDeepLink(url: deepLink) {
            return
        }
        
        if openDeepLink(url: webLink) {
            return
        }
        deepLinkError.accept("인스타그램을 열 수 없습니다.")
    }
    
    private func openDeepLink(url: URL) -> Bool {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            return true
        }
        return false
    }
}
