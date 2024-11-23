//
//  SummarySearchPageViewModel.swift
//  Shortcap
//
//  Created by choijunios on 11/24/24.
//

import Entity

import RxSwift
import RxCocoa

protocol SummarySearchPageViewModelable {
    
    // Input
    var searchingText: PublishSubject<String> { get }
    var exitButtonClicked: PublishSubject<Void> { get }
    var cellIsClicked: PublishSubject<Void> { get }
    
    // OutPut
    var summaryItems: Driver<[SummaryItem]> { get }
}


class SummarySearchPageViewModel: SummarySearchPageViewModelable {
    
    let searchingText: RxSwift.PublishSubject<String> = .init()
    let exitButtonClicked: RxSwift.PublishSubject<Void> = .init()
    let cellIsClicked: RxSwift.PublishSubject<Void> = .init()
    
    var summaryItems: RxCocoa.Driver<[Entity.SummaryItem]> = .empty()
    
    init() {
           
    }
}
