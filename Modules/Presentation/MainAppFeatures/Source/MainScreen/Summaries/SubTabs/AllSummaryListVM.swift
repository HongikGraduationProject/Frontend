//
//  AllSummaryListVM.swift
//  MainAppFeatures
//
//  Created by choijunios on 8/22/24.
//

import Foundation
import CommonFeature
import RxCocoa
import RxSwift
import Entity
import UseCase
import DSKit
import CommonUI

public protocol AllSummaryListVMable {
    
    // Output
    var summaryItems: Driver<[SummaryItem]>? { get }
    
    func createCellVM(videoId: Int) -> SummaryCellVMable
}

public class AllSummaryListVM: AllSummaryListVMable {
    
    public var startSummaryItemStream: RxRelay.PublishRelay<Void> = .init()
    public var summaryItems: RxCocoa.Driver<[Entity.SummaryItem]>?
    
    weak var coordinator: SummariesCO?
    let summaryUseCase: SummaryUseCase
    let summaryDetailRepository: SummaryDetailRepository
    
    public init(
        coordinator: SummariesCO?,
        summaryUseCase: SummaryUseCase,
        summaryDetailRepository: SummaryDetailRepository
    ) {
        self.coordinator = coordinator
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
            coordinator: coordinator,
            summaryDetailRepository: summaryDetailRepository
        )
    }
}
