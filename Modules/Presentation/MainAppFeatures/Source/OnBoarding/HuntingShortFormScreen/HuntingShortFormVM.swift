//
//  HuntingShortFormVM.swift
//  MainAppFeatures
//
//  Created by choijunios on 8/10/24.
//

import UIKit
import RxSwift
import RxCocoa
import Entity
import UseCase

public class HuntingShortFormVM: HuntingShortFormViewModelable {
    
    // Init
    weak var coordinator: HuntingShortFormCO?
    let videoCodeRepository: VideoCodeRepository
    
    // Output
    public var alert: Driver<CapAlertVO>?
    
    // ViewModel native
    private let deepLinkError: PublishRelay<String> = .init()
    
    var checkingVideoCodeDisposable: Disposable?
    
    init(coordinator: HuntingShortFormCO?, videoCodeRepository: VideoCodeRepository) {
        self.coordinator = coordinator
        self.videoCodeRepository = videoCodeRepository
        
        // Output
        alert = deepLinkError
            .map { message in
                CapAlertVO(title: "숏폼 찾으로 가기 오류", message: message)
            }
            .asDriver(onErrorJustReturn: .default)
        
        
        // MARK: 앱이 다시 엑티비 되는 경우, 로컬에 저장된 요약목록을 확인합니다.
        checkingVideoCodeDisposable = NotificationCenter.default.rx
            .notification(UIApplication.willEnterForegroundNotification)
            .subscribe(onNext: { [weak self] notification in
                guard let self else { return }
                if videoCodeRepository.getVideoCodes().count > 0 {
                    coordinator?.showMainTapBarFlow()
                    
                    // 요약내역이 있을 경우 구독을 종료하고 메인화면으로 이동한다.
                    checkingVideoCodeDisposable?.dispose()
                }
            })
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
