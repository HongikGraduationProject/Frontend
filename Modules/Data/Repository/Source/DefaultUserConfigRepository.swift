//
//  DefaultUserConfigRepository.swift
//  Repository
//
//  Created by choijunios on 8/8/24.
//

import Foundation

import Entity
import RepositoryInterface
import DataSource

public class DefaultUserConfigRepository: UserConfigRepository {
    
    public init() { }
    
    public func getPreferedCategories() -> [MainCategory]? {
        
        guard let stringData: String = UserDefaultsDataSource.shared.fetchData(key: .selectedMainCategories) else {
            return nil
        }
        
        return stringData.split(separator: ",").map { rawValue in
            let category = MainCategory(rawValue: String(rawValue))!
            return category
        }
    }
    
    public func savePreferedCategories(categories: [MainCategory]) {
        
        let indexStr: String = categories.map { String($0.rawValue) }.joined(separator: ",")
        
        UserDefaultsDataSource.shared.saveData(key: .selectedMainCategories, value: indexStr)
    }
}
