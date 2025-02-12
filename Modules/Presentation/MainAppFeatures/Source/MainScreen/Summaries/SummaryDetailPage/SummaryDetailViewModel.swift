//
//  SummaryDetailVM.swift
//  MainAppFeatures
//
//  Created by choijunios on 8/29/24.
//

import UIKit

import Entity
import DSKit
import RepositoryInterface
import Util

import RxCocoa
import RxSwift

public class SummaryDetailViewModel {
    
    @Injected var summaryDetailRepository: SummaryDetailRepository
    
    // Init
    let videoId: Int
    
    // Input
    let viewDidLoad: PublishRelay<Void> = .init()
    let playSourceVideoButtonClicked: PublishRelay<Void> = .init()
    
    // Output
    var summaryDetail: Driver<SummaryDetail>?
    
    private let disposeBag: DisposeBag = .init()
    
    public init(videoId: Int) {
        self.videoId = videoId
        
        let detail = viewDidLoad
            .flatMap { [summaryDetailRepository] _ in
                summaryDetailRepository.fetchSummaryDetail(videoId: videoId)
            }
        
        summaryDetail = detail
            .asDriver(onErrorDriveWith: .never())
        
        
        playSourceVideoButtonClicked
            .withLatestFrom(detail)
            .subscribe(onNext: { [weak self] detail in
                
                guard let self else { return }
                
                if let code = detail.rawVideoCode {
                    
                    openYouTubeLink(with: code)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func openYouTubeLink(with videoID: String) {
        // 유튜브 앱 URL 스킴
        let appURL = URL(string: "youtube://\(videoID)")!
        // 웹 URL (사파리에서 열릴 URL)
        let webURL = URL(string: "https://www.youtube.com/shorts/watch?v=\(videoID)")!
        
        if UIApplication.shared.canOpenURL(appURL) {
            // 유튜브 앱이 설치되어 있을 때 유튜브 앱에서 열기
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        } else {
            // 유튜브 앱이 설치되어 있지 않을 때 사파리에서 열기
            UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
        }
    }
}
