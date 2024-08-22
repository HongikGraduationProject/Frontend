//
//  File.swift
//  MainAppFeatures
//
//  Created by choijunios on 8/22/24.
//

import Foundation
import BaseFeature
import RxCocoa
import RxSwift
import Entity
import UseCase
import DSKit

public protocol AllSummaryListVMable {
    
    // Output
    var summaryItems: Driver<[SummaryItem]>? { get }
    
    func createCellVM(videoId: Int) -> SummaryCellVMable
}

public class AllSummaryListVM: AllSummaryListVMable {
    
    public var startSummaryItemStream: RxRelay.PublishRelay<Void> = .init()
    public var summaryItems: RxCocoa.Driver<[Entity.SummaryItem]>?
    
    let summaryUseCase: SummaryUseCase
    let summaryDetailRepository: SummaryDetailRepository
    
    public init(summaryUseCase: SummaryUseCase, summaryDetailRepository: SummaryDetailRepository) {
        self.summaryUseCase = summaryUseCase
        self.summaryDetailRepository = summaryDetailRepository
        
        // MARK: 스트림 연결
        summaryItems = summaryUseCase
            .summariesStream
            .asDriver(onErrorJustReturn: [])
    }
    
    public func createCellVM(videoId: Int) -> SummaryCellVMable {
        SummaryCellVM(
            videoId: videoId,
            summaryDetailRepository: summaryDetailRepository
        )
    }
}
