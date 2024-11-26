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
    
    private let keyForBaseURL = "kBaseURL"
    
    private var baseURL: String? {
        UserDefaults.standard.string(forKey: keyForBaseURL)
    }
    
    public init() { }
    
    public func requestBaseURL() -> String? {
        
        keyForBaseURL
    }
    
    public func requestChangeBaseURL(baseURL: String) throws {
        
        let regexString = "^(https?://)((25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?).){3}(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)$"
        
        let regex = try Regex(regexString)
        
        guard let _ = try regex.wholeMatch(in: baseURL) else { return }
        
        UserDefaults.standard.set(baseURL, forKey: keyForBaseURL)
    }
}
