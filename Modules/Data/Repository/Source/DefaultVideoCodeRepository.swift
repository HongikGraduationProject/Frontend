//
//  DefaultVideoCodeRepository.swift
//  Repository
//
//  Created by choijunios on 8/20/24.
//

import Foundation
import Entity
import RxSwift
import UseCase
import DataSource
import Util

public class DefaultVideoCodeRepository: VideoCodeRepository {
    
    let coreDataService: CoreDataService
    
    public init(coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
    }
    
    public func getVideoCodes() -> [String] {
        let fetchRequest = SummaryInfoObject.fetchRequest()
        do {
            let fetchedObjects = try coreDataService.container.viewContext.fetch(fetchRequest)
            return fetchedObjects.map { object in object.videoCode! }
        } catch {
            printIfDebug("‼️ 비디오 코드를 가져오는 과정에서 문제발생")
            return []
        }
    }
    
    public func saveVideoCode(_ videoCode: String) -> RxSwift.Single<Void> {
        Single<Void>.create { [weak self] single in
            self?.coreDataService.container.performBackgroundTask { context in
                let object = SummaryInfoObject(context: context)
                object.videoCode = videoCode
                do {
                    try context.save()
                    printIfDebug("✅ 비디오코드 저장됨 \(videoCode)")
                    single(.success(()))
                } catch {
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    public func removeVideoCode(_ videoCode: String) {
        coreDataService.container.performBackgroundTask { context in
            let fetchRequest = SummaryInfoObject.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "videoCode == %@", videoCode)
            do {
                if let targetObject = try context.fetch(fetchRequest).first {
                    context.delete(targetObject)
                }
                try context.save()
            } catch {
                printIfDebug("‼️ 비디오 코드 지우기 실패 \(error.localizedDescription)")
            }
        }
    }
}

