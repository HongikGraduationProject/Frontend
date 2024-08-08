//
//  DefaultUserConfigRepository.swift
//  Repository
//
//  Created by choijunios on 8/8/24.
//

import Foundation
import Entity
import UseCase
import DataSource

public class DefaultUserConfigRepository: UserConfigRepository {
    
    public func getSelectedMainCategories() -> [MainCategory]? {
        
        guard let stringData: String = UserDefaultsDataSource.shared.fetchData(key: .selectedMainCategories) else {
            return nil
        }
        
        return stringData.split(separator: ",").map {
            let catIndex = Int($0)!
            let category = MainCategory(rawValue: catIndex)!
            return category
        }
    }
    
    public func saveSelectedMainCategories(categories: [MainCategory]) {
        
        let indexStr: String = categories.map { String($0.rawValue) }.joined(separator: ",")
        
        UserDefaultsDataSource.shared.saveData(key: .selectedMainCategories, value: indexStr)
    }
}
