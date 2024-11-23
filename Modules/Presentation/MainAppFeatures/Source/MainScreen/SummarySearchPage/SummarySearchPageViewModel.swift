//
//  SummarySearchPageViewModel.swift
//  Shortcap
//
//  Created by choijunios on 11/24/24.
//

import UseCase
import Entity
import Util

import RxSwift
import RxCocoa

protocol SummarySearchPageViewModelable {
    
    // Input
    var searchingText: PublishSubject<String> { get }
    var exitButtonClicked: PublishSubject<Void> { get }
    var cellIsClicked: PublishSubject<Void> { get }
    
    // OutPut
    var summaryDetails: Driver<[SummaryDetail]> { get }
}


class SummarySearchPageViewModel: SummarySearchPageViewModelable {
    
    @Injected private var summarySearchUseCase: SummarySearchUseCase
    
    let searchingText: PublishSubject<String> = .init()
    let exitButtonClicked: PublishSubject<Void> = .init()
    let cellIsClicked: PublishSubject<Void> = .init()
    
    var summaryDetails: Driver<[SummaryDetail]> = .empty()
    
    init() {
           
        self.summaryDetails = searchingText
            .debounce(.milliseconds(350), scheduler: MainScheduler.instance)
            .flatMap { [summarySearchUseCase] word in
                
                summarySearchUseCase
                    .requestSearchItem(searchWord: word)
            }
            .asDriver(onErrorDriveWith: .never())
    }
}
