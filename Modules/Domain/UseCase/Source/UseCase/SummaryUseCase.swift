//
//  SummaryUseCase.swift
//  UseCase
//
//  Created by choijunios on 8/19/24.
//

import Foundation
import Entity
import RxSwift
import Util

public protocol SummaryUseCase: UseCaseBase {
    
    /// 전체 비디오 상세정보를 제공받을 수 있는 콜드 스트림입니다.
    var summariesStream: BehaviorSubject<[SummaryItem]> { get }
    
    /// 요약이 완료됬었던 비디오리스트를 서버로 부터 가져옵니다.
    func fetchAllSummaryItems() -> Single<Result<[SummaryItem], SummariesError>>
    
    /// 로컬로부터 비디오 코드를 가져오고 해당 코드로부터 상세정보를 가져옵니다, 가져온 정보는 핫스트림으로 방출됩니다.
    func updateSummaryStream()
}

public class DefaultSummaryUseCase: SummaryUseCase {
    
    public struct Dependency {
        let summaryRepository: SummaryRepository
        let videoCodeRepository: VideoCodeRepository
        public init(summaryRepository: SummaryRepository, videoCodeRepository: VideoCodeRepository) {
            self.summaryRepository = summaryRepository
            self.videoCodeRepository = videoCodeRepository
        }
    }
    
    // Stream
    /// 최신 요약상세정보를 재공하는 콜드스트림입니다.
    public let summariesStream: RxSwift.BehaviorSubject<[Entity.SummaryItem]>
    
    /// 지금가지 수집한 요약정보를 구독즉시 방출하는 콜드 스트림입니다.
    private let summariesColdStream: RxSwift.BehaviorSubject<[Entity.SummaryItem]>
    
    /// 실시간 요약상태를 반영하는 핫스트림입니다.
    private let summariesHotStream: RxSwift.PublishSubject<SummaryItem>
    
    // Repository
    private let summaryRepository: SummaryRepository
    private let videoCodeRepository: VideoCodeRepository
    
    private let disposeBag = DisposeBag()
    
    public init(dependency: Dependency) {
        self.summaryRepository = dependency.summaryRepository
        self.videoCodeRepository = dependency.videoCodeRepository
        
        summariesStream = .init(value: [])
        summariesColdStream = .init(value: [])
        summariesHotStream = .init()
        
        let hotFlow = summariesHotStream
            .buffer(
                timeSpan: .milliseconds(2000),
                count: 3,
                scheduler: ConcurrentDispatchQueueScheduler(qos: .default)
            )
        
        Observable
            .zip(summariesColdStream, hotFlow)
            .map { (cold, hot) in
                cold + hot
            }
            .subscribe(onNext: { [weak self] latest in
                self?.summariesStream.onNext(latest)
                self?.summariesColdStream.onNext(latest)
            })
            .disposed(by: disposeBag)
    }
    
    public func fetchAllSummaryItems() -> Single<Result<[SummaryItem], SummariesError>> {
        convert(task: summaryRepository
            .fetchAllSummaryItems())
    }
    
    private let statusCheckStreamDict: ThreadSafeDictionary<String, Disposable> = .init()
    
    public func updateSummaryStream() {
        let videoCodes = videoCodeRepository.getVideoCodes()
        
        for videoCode in videoCodes {
            // 요약완료 여부 확인
            
            // 최초요청
            let initialStatusCheckSubject = BehaviorSubject<String>(value: videoCode)
            
            // processing중일 경우 사용하는 Subject
            let delayedStatusSubject = PublishSubject<String>()
                
            // 두번째 호출부터는 1초의 지연이 발생합니다.
            let delayedStream = delayedStatusSubject.delay(.milliseconds(1000), scheduler: ConcurrentDispatchQueueScheduler(qos: .default))
            
            // 최초 요청과 이후 요청을 merge
            let statusCheckResult = Observable
                .merge(initialStatusCheckSubject, delayedStream)
                .flatMap { [summaryRepository] videoCode in
                    summaryRepository
                        .checkSummaryState(videoCode: videoCode)
                }
                .share()
                
            let disposable = statusCheckResult
                .subscribe(onNext: { [videoCode, weak self] status in
                    switch status.status {
                    case .complete:
                        guard let self else { return }
                        
                        // 비디오 코드 삭제요청
                        // 완료응답을 받은 이후임으로, 설령삭제되지 못한다해도 문제되지 않는다.
                        // 에러상황에 대해 별도의 처리를 하지 않기 때문이다. 추후에 에러로깅에 문작될 수는 있다.
                        videoCodeRepository.removeVideoCode(videoCode)
                        
                        // 반복 스트림 종료
                        statusCheckStreamDict.remove(videoCode)
                        
                        let getDetailResult = summaryRepository.fetchSummaryDetail(videoId: status.videoSummaryId)
                        getDetailResult
                            .subscribe(onSuccess: { [weak self] detail in
                                
                                let item = SummaryItem(
                                    title: detail.title,
                                    mainCategory: detail.mainCategory,
                                    createdAt: detail.createdAt,
                                    videoSummaryId: status.videoSummaryId
                                )
                                
                                // 핫스트림에 요약이 완료된 정보를 반영
                                self?.summariesHotStream.onNext(item)
                            })
                            .disposed(by: disposeBag)
                        
                    case .processing:
                        delayedStatusSubject.onNext(videoCode)
                    }
                })
            
            statusCheckStreamDict.write(videoCode, value: disposable)
        }
    }
}
