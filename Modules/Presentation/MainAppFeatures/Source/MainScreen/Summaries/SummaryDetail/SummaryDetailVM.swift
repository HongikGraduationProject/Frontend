//
//  SummaryDetailVM.swift
//  MainAppFeatures
//
//  Created by choijunios on 8/29/24.
//

import UIKit
import RxCocoa
import RxSwift
import Entity
import DSKit
import UseCase

public class SummaryDetailVM {
    
    // Init
    let videoId: Int
    let repo: SummaryDetailRepository
    
    // Input
    let viewDidLoad: PublishRelay<Void> = .init()
    
    // Output
    var summaryDetail: Driver<SummaryDetail>?
    
    public init(videoId: Int, repo: SummaryDetailRepository) {
        self.videoId = videoId
        self.repo = repo
        
        summaryDetail = viewDidLoad
            .flatMap { [repo] _ in
                repo.fetchSummaryDetail(videoId: videoId)
            }
            .asDriver(onErrorDriveWith: .never())
    }
}
