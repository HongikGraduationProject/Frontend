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
    var cellIdentifiers: Driver<[String]> { get }
    
    func getItem(index: Int) -> SummaryDetail
}


class SummarySearchPageViewModel: SummarySearchPageViewModelable {
    
    @Injected private var summarySearchUseCase: SummarySearchUseCase
    
    let searchingText: PublishSubject<String> = .init()
    let exitButtonClicked: PublishSubject<Void> = .init()
    let cellIsClicked: PublishSubject<Void> = .init()
    
    var cellIdentifiers: Driver<[String]> = .empty()
    
    private var data: [SummaryDetail] = []
    
    init() {
           
        self.cellIdentifiers = searchingText
            .debounce(.milliseconds(350), scheduler: MainScheduler.instance)
            .flatMap { [summarySearchUseCase] word in
                
                summarySearchUseCase
                    .requestSearchItem(searchWord: word)
            }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .map { viewModel, details in
                
                viewModel.data = details
                
                return details.map({ $0.videoCode })
            }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func getItem(index: Int) -> SummaryDetail {
        
        data[index]
    }
}
