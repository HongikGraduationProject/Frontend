//
//  DefaultSummaryRepository.swift
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

public class DefaultSummaryRepository: SummaryRepository {
    
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
        
        // 캐시를 WarnUp합니다.
        warmUpCache()
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
    
    /// 로컬데이터를 Cache매모리로 옮깁니다.
    private func warmUpCache() {
        
        coreDataService.container.performBackgroundTask { [weak self] content in
            let fetchRequest = SummaryDetailObject.fetchRequest()
            do {
                let summaryDetails = try content.fetch(fetchRequest)
                summaryDetails.forEach { object in
                    let result = object.toEntity()
                    let videoId = result.0
                    let entity = result.1
                    self?.cacheStorage.write(videoId, value: entity)
                }
            }
            catch {
                
                // 캐싱작업 오류발생
                printIfDebug("‼️ 캐시를 웜업하는 과정에서 오류가 발생했습니다.")
            }
        }
    }
    
    /// 요약상세정보를 코어데이터에 저장합니다.
    private func saveSummaryDetail(videoId: Int, _ detail: SummaryDetail) {
        coreDataService.container.performBackgroundTask({ [detail] context in
            let coreDataDTO = SummaryDetailObject(context: context)
            detail.mapToCoreDataEntity(videoId: videoId, coreDataDTO)
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

// MARK: Summary Detail transformation
fileprivate extension SummaryDetailObject {
    
    func toEntity() -> (Int, SummaryDetail) {
        let detail = SummaryDetail(
            title: self.title ?? "",
            description: self.content ?? "",
            keywords: self.keywords?.split(separator: ",").map { String($0) } ?? [],
            url: URL(string: self.url ?? "")!,
            summary: self.summary ?? "",
            address: self.address ?? "",
            createdAt: self.createdAt ?? "",
            platform: ShortFormPlatform(rawValue: self.platform ?? "") ?? .youtube,
            mainCategory: MainCategory(rawValue: self.mainCategory ?? "") ?? .art,
            mainCategoryIndex: Int(self.mainCategoryIndex),
            subCategory: self.subCategory ?? "",
            subCategoryId: Int(self.subCategoryId),
            latitude: self.latitude == 0 ? nil : self.latitude,
            longitude: self.longitude == 0 ? nil : self.longitude,
            videoCode:self.videoCode ?? ""
        )
        
        return (Int(self.videoId), detail)
    }
}

fileprivate extension SummaryDetail {
    
    func mapToCoreDataEntity(videoId: Int, _ coreDataDTO: SummaryDetailObject) {
        coreDataDTO.videoId = Int32(videoId)
        coreDataDTO.title = self.title
        coreDataDTO.content = self.description
        coreDataDTO.keywords = self.keywords.joined(separator: ",")
        coreDataDTO.url = self.url.absoluteString
        coreDataDTO.summary = self.summary
        coreDataDTO.address = self.address
        coreDataDTO.createdAt = self.createdAt
        coreDataDTO.platform = self.platform.rawValue
        coreDataDTO.mainCategory = self.mainCategory.rawValue
        coreDataDTO.mainCategoryIndex = Int32(self.mainCategoryIndex)
        coreDataDTO.subCategory = self.subCategory
        coreDataDTO.subCategoryId = Int32(self.subCategoryId)
        if let latitude = self.latitude, let longitude = self.longitude {
            coreDataDTO.latitude = latitude
            coreDataDTO.longitude = longitude
        }
        coreDataDTO.videoCode = self.videoCode
    }
}
