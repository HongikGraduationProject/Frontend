//
//  SummaryUseCase.swift
//  UseCase
//
//  Created by choijunios on 8/19/24.
//

import Foundation

import RepositoryInterface
import Entity
import Util

import RxSwift

public protocol SummaryUseCase: UseCaseBase {
    
    /// 전체 비디오 상세정보를 제공받을 수 있는 콜드 스트림입니다.
    var summariesStream: BehaviorSubject<[SummaryItem]> { get }
    
    
    /// 요약이 완료됬었던 비디오 리스트를 요청합니다.
    func requestFetchSummarriedItems() -> Single<Result<Void, SummariesError>>
    
    
    /// 새로운 요약사항이 있는지 확인할 것을 요청합니다.
    func requestCheckNewSummary()
}

public class DefaultSummaryUseCase: SummaryUseCase {
    
    @Injected var summaryRequestRepository: SummaryRequestRepository
    @Injected var summarizedItemRepository: SummarizedItemRepository
    @Injected var summaryDetailRepository: SummaryDetailRepository
    @Injected var videoCodeRepository: VideoCodeRepository
    @Injected var requestCounter: RequestCountTracker
    
    /// 최신 요약상세정보를 재공하는 콜드스트림입니다.
    public let summariesStream: BehaviorSubject<[SummaryItem]> = .init(value: [])
    
    
    private var summariesList: [SummaryItem] = []
    private let summariesListManagementQueue: DispatchQueue = .init(
        label: "com.SummaryUseCase",
        attributes: .concurrent
    )
    
    
    private let disposeBag = DisposeBag()
    
    public init() { }
    
    public func requestFetchSummarriedItems() -> Single<Result<Void, SummariesError>> {
        
        let task = summarizedItemRepository
            .requestAllSummaryItems()
            .map { [weak self] items in
                
                guard let self else { return }
                
                printIfDebug("✅ 요약완료된 숏폼개수: \(items.count)")
                
                summariesList = items
                
                publishSummaryList()
                
                return ()
            }
        
        return convert(task: task)
    }
    
    public func requestCheckNewSummary() {
        
        let videoCodes = videoCodeRepository.getVideoCodes()
        
        for videoCode in videoCodes {
            
            trackSummaryStatus(videoCode: videoCode)
        }
    }
    
    private func trackSummaryStatus(videoCode: String, delaySeconds: Double = 0.0) {
        
        let requestCount = requestCounter
            .requestRequestCount(videoCode: videoCode)
            .asObservable()
        
        let status = summaryRequestRepository
            .checkSummaryState(videoCode: videoCode)
            .asObservable()
        
        Observable
            .zip(status, requestCount)
            .delay(.milliseconds(Int(delaySeconds * 1000.0)), scheduler: ConcurrentDispatchQueueScheduler(qos: .default))
            .subscribe(onNext: { [weak self] (result, rc) in
                
                guard let self else { return }
                
                switch result.status {
                case .complete:
                    
                    // 비디오 코드 삭제요청
                    videoCodeRepository.removeVideoCode(videoCode)
                    
                    
                    // 요약이 완료된 숏폼으로 부터 디테일정보 추출후 전송
                    requestSubDetailOfVideo(videoId: result.videoSummaryId)
                    
                case .processing:
                    
                    if rc >= 20 {
                        
                        // 20회이상인 경우 더이상 요청하지 않고 비디오코드를 삭제한다.
                        videoCodeRepository.removeVideoCode(videoCode)
                        
                    } else {
                        
                        // 지연 재귀요청
                        trackSummaryStatus(videoCode: videoCode, delaySeconds: 1.0)
                    }
                }
                
            })
            .disposed(by: disposeBag)
    }
    
    private func requestSubDetailOfVideo(videoId: Int) {
        
        summaryDetailRepository
            .fetchSummaryDetail(videoId: videoId)
            .subscribe(onSuccess: { [weak self] detail in
                
                let item = SummaryItem(
                    title: detail.title,
                    mainCategory: detail.mainCategory,
                    createdAt: detail.createdAt,
                    videoSummaryId: videoId
                )
                
                self?.summariesListManagementQueue.async(flags: .barrier) { [weak self] in
                    guard let self else { return }
                    
                    summariesList.insert(item, at: 0)
                    
                    publishSummaryList()
                }
                
            })
            .disposed(by: disposeBag)
    }
    
    private func publishSummaryList() {
        summariesStream.onNext(summariesList)
    }
}
