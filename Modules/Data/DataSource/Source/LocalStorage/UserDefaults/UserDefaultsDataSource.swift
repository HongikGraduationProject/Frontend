//
//  UserDefaultsDataSource.swift
//  DataSource
//
//  Created by choijunios on 8/8/24.
//

import Foundation

/// UserDefaults에 저장가능한 키값을 나타냅니다.
public enum CapUserDefaultKey: String {
    
    // 메인 카테고리
    case selectedMainCategories = "selectedMainCategories"
    
    // 토큰
    case accessToken = "accessToken"
    
    // imei
    case imei = "imei"
}

/// UserDefaults를 사용하여 로컬에 데이터를 저장힙니다.
/// App Group은 동일한 UserDefaults를 사용하도록 설정됩니다.
public class UserDefaultsDataSource {
    
    let userDefaults: UserDefaults! = .init(suiteName: DataSourceConfig.appGroupIdentifier)
    
    private init() { }
    
    /// UserDefaultsDataSource의 싱글톤 객체입니다.
    public static let shared = UserDefaultsDataSource()
    
    /// UserDefaults로 부터 데이터를 가져옵니다.
    public func fetchData<T>(key: CapUserDefaultKey) -> T? {
        userDefaults.value(forKey: key.rawValue) as? T
    }
    
    /// UserDefaults에 데이터를 저장합니다.
    public func saveData<T>(key: CapUserDefaultKey, value: T) {
        userDefaults.setValue(value, forKey: key.rawValue)
    }
}
