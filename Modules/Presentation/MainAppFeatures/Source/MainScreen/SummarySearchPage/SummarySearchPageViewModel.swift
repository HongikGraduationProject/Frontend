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
    var clickedCellIndex: PublishSubject<Int> { get }
    
    // OutPut
    var cellIdentifiers: Driver<[String]> { get }
    
    func getItem(index: Int) -> SummaryDetail
}


class SummarySearchPageViewModel: SummarySearchPageViewModelable {
    
    @Injected private var summarySearchUseCase: SummarySearchUseCase
    
    // Navigation
    var presentDetailPage: ((Int) -> ())?
    var exitPage: (() -> ())?
    
    let searchingText: PublishSubject<String> = .init()
    let exitButtonClicked: PublishSubject<Void> = .init()
    let clickedCellIndex: PublishSubject<Int> = .init()
    
    var cellIdentifiers: Driver<[String]> = .empty()
    
    private var data: [SummaryDetail] = []
    
    private let cellIdentifierPublisher: PublishSubject<[String]> = .init()
    private let disposeBag: DisposeBag = .init()
    
    init() {
           
        searchingText
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe { (viewModel, word) in
                
                viewModel.requestSearchResult(word: word)
            }
            .disposed(by: disposeBag)
        
            
        self.cellIdentifiers = cellIdentifierPublisher
            .asDriver(onErrorDriveWith: .empty())
        
        exitButtonClicked
            .withUnretained(self)
            .subscribe(onNext: { vm, _ in
                
                vm.exitPage?()
            })
            .disposed(by: disposeBag)
        
        clickedCellIndex
            .withUnretained(self)
            .subscribe(onNext: { vm, index in
                
                if let videoId = vm.getItem(index: index).videoId {
                    
                    vm.presentDetailPage?(videoId)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func getItem(index: Int) -> SummaryDetail {
        
        data[index]
    }
    
    private var searchTask: Disposable?
    
    private func requestSearchResult(word: String) {
        
        if word.isEmpty {
            
            self.data = []
            self.cellIdentifierPublisher.onNext([])
            
            return
        }
        
        // 기존의 작업 종료
        searchTask?.dispose()
        
        self.searchTask = summarySearchUseCase
            .requestSearchItem(searchWord: word)
            .asObservable()
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { viewModel, details in
                
                viewModel.data = details
                
                let identifiers = details.map({ $0.videoCode })
                
                viewModel
                    .cellIdentifierPublisher
                    .onNext(identifiers)
            })
        
        searchTask?
            .disposed(by: disposeBag)
    }
}
