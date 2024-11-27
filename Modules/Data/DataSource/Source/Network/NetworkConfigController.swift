//
//  NetworkConfigController.swift
//  Shortcap
//
//  Created by choijunios on 11/26/24.
//

import Foundation

public protocol NetworkConfigController {
    
    func requestBaseURL() -> String?
    
    func requestChangeBaseURL(baseURL: String) throws
}

public class DefaultNetworkConfigController: NetworkConfigController {
    
    public init() { }
    
    public func requestBaseURL() -> String? {
        
        UserDefaultsDataSource.shared.fetchData(key: .baseURL)
    }
    
    public func requestChangeBaseURL(baseURL: String) throws {
        
        let regexString = "^(https?://)((25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?).){3}(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)(:\\d{1,5})?(/[^\\s?#]*)?(\\?[^\\s#]*)?(#[^\\s]*)?$"
        
        let regex = try Regex(regexString)
        
        guard let _ = try regex.wholeMatch(in: baseURL) else { return }
        
        UserDefaultsDataSource.shared.saveData(key: .baseURL, value: baseURL)
    }
}
