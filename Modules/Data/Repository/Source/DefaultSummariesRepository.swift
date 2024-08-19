//
//  DefaultSummariesRepository.swift
//  Repository
//
//  Created by choijunios on 8/13/24.
//

import Foundation
import UseCase
import Entity
import DataSource
import RxSwift
import Util

public class DefaultSummariesRepository: SummaryRepository {
    
    public struct Dependency {
        let coreDataService: CoreDataService
        let summaryService: SummaryService
        public init(coreDataService: CoreDataService, summaryService: SummaryService) {
            self.coreDataService = coreDataService
            self.summaryService = summaryService
        }
    }
    
    // Caching
    private let cacheStorage: ThreadSafeDictionary<Int, SummaryDetail> = .init()
    
    // Init
    private let coreDataService: CoreDataService
    private let summaryService: SummaryService
    
    public init(
        dependency: Dependency
    ) {
        self.coreDataService = dependency.coreDataService
        self.summaryService = dependency.summaryService
    }
    
    public func fetchAllSummaryItems() -> RxSwift.Single<[Entity.SummaryItem]> {
        summaryService
            .request(api: .listAll, with: .withToken)
            .map(CAPResponse<VideoSummaryList>.self)
            .map { response in
                response.data!.videoSummaryList
            }
    }
    
    public func checkSummaryState(videoCode: String) -> RxSwift.Single<SummaryStatus> {
        summaryService
            .request(api: .checkSummaryStatus(videoCode: videoCode), with: .withToken)
            .map(CAPResponse<SummaryStatus>.self)
            .map { response in
                response.data!
            }
    }
    
    public func fetchSummaryDetail(videoId: Int) -> RxSwift.Single<Entity.SummaryDetail> {
        // 캐싱된 정보가 있는지 확인합니다.
        let checkCaching = cacheStorage
            .read(videoId)
        
        let cacheFound = checkCaching.compactMap { $0 }.asObservable()
        let cacheNotFound = checkCaching.filter { $0 == nil }.asObservable()
        
        let fetchFromServer = cacheNotFound
            .flatMap { [summaryService] _ in
                summaryService
                    .request(api: .fetchSummaryDetail(videoId: videoId), with: .withToken)
                    .map(CAPResponse<SummaryDetail>.self)
                    .map { response in
                        response.data!
                    }
            }
            .map { [weak self] fetchedDetail in
                
                // 받아온 정보를 캐싱합니다.
                self?.cacheStorage.write(videoId, value: fetchedDetail)
                
                // 받아온 정보를 코어데이터에 저장합니다.
                self?.saveSummaryDetail(videoId: videoId, fetchedDetail)
                
                return fetchedDetail
            }
        
        return Observable
            .merge(cacheFound, fetchFromServer)
            .asSingle()
    }
    
    private func saveSummaryDetail(videoId: Int, _ detail: SummaryDetail) {
        coreDataService.container.performBackgroundTask({ [detail] context in
            let entity = SummaryDetailObject(context: context)
            entity.videoId = Int32(videoId)
            entity.title = detail.title
            entity.content = detail.description
            entity.keywords = detail.keywords.joined(separator: ",")
            entity.url = detail.url.absoluteString
            entity.summary = detail.summary
            entity.address = detail.address
            entity.createdAt = detail.createdAt
            entity.platform = detail.platform.rawValue
            entity.mainCategory = detail.mainCategory.rawValue
            entity.mainCategoryIndex = Int32(detail.mainCategoryIndex)
            entity.subCategory = detail.subCategory
            entity.subCategoryId = Int32(detail.subCategoryId)
            entity.latitude = detail.latitude
            entity.longitude = detail.longitude
            entity.videoCode = detail.videoCode
            
            do {
                try context.save()
            } catch {
                printIfDebug("‼️ 비디오 요약정보 코어데이터 저장실패: \(detail)")
            }
        })
    }
}

fileprivate struct VideoSummaryList: Decodable {
    let videoSummaryList: [SummaryItem]
}
