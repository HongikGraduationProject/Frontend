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

public protocol AllSummaryListVMable {
    
    // Output
    var summaryItems: Driver<[SummaryItem]>? { get }
}

public class AllSummaryListVM: AllSummaryListVMable {
    
    public var startSummaryItemStream: RxRelay.PublishRelay<Void> = .init()
    public var summaryItems: RxCocoa.Driver<[Entity.SummaryItem]>?
    
    let summaryUseCase: SummaryUseCase
    
    public init(summaryUseCase: SummaryUseCase) {
        self.summaryUseCase = summaryUseCase
        
        // MARK: 스트림 연결
        summaryItems = summaryUseCase
            .summariesStream
            .asDriver(onErrorJustReturn: [])
    }
}
