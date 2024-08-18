//
//  CoreDataService.swift
//  DataSource
//
//  Created by choijunios on 8/18/24.
//

import Foundation
import CoreData
import Util

public protocol CoreDataService {
    
    var container: NSPersistentContainer { get }
}

public class DefaultCoreDataService: CoreDataService {
    
    public var container: NSPersistentContainer
    
    public init() {
        
        let bundle = DataSourceResources.bundle
        let modelFileName = "Summary"
        let modelURL = bundle.url(forResource: modelFileName, withExtension: ".momd")!
        let model = NSManagedObjectModel(contentsOf: modelURL)!
        let container = NSPersistentContainer(name: "CAPSummaryStorage", managedObjectModel: model)
        let appGroupIdentifier = DataSourceConfig.appGroupIdentifier
        let storeURL = URL.storeURL(for: appGroupIdentifier, databaseName: "ShortCapDB")
        container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: storeURL)]
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                assertionFailure("CoreDataStorage Unresolved error \(error), \(error.userInfo)")
            }
            printIfDebug("✅ NSPersistentContainer loaded")
        }
        self.container = container
    }
}

fileprivate extension URL {
    /// Returns a URL for the given app group and database pointing to the sqlite database.
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }

        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}
