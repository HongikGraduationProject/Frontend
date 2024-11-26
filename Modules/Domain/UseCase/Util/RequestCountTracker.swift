//
//  RequestCountTracker.swift
//  Shortcap
//
//  Created by choijunios on 11/13/24.
//

import Foundation

import RxSwift

public protocol RequestCountTracker {
    
    func requestRequestCount(videoCode: String) -> Single<Int>
    
    func countUpRequestCount(videoCode: String)
    
    func removeRequestCount(videoCode: String)
    
    
    func requestFailureCount(videoCode: String) -> Single<Int>
    
    func countUpFailureCount(videoCode: String)
    
    func removeFailureCount(videoCode: String)
}

public class DefaultRequestCountTracker: RequestCountTracker {
    
    private let requestCountManagementQueue: DispatchQueue = .init(
        label: "com.RequestCountTracker.request",
        attributes: .concurrent
    )
    private let requestFailureCountManagementQueue: DispatchQueue = .init(
        label: "com.RequestCountTracker.failure",
        attributes: .concurrent
    )
    
    private var requestCountState: [String: Int] = [:]
    private var requestFailureState: [String: Int] = [:]
    
    public init() { }
    
    public func requestRequestCount(videoCode: String) -> Single<Int> {
        
        Single.create { [weak self] single in
            
            self?.requestCountManagementQueue.async { [weak self] in
                guard let self else { return }
                
                if let value = requestCountState[videoCode] {
                    
                    single(.success(value))
                    
                } else {
                    
                    requestCountState[videoCode] = 0
                    
                    single(.success(0))
                }
            }
            
            return Disposables.create { }
        }
    }
    
    public func countUpRequestCount(videoCode: String) {
        
        requestCountManagementQueue.async(flags: .barrier) { [weak self] in
            
            guard let self else { return }
            
            requestCountState[videoCode]? += 1
        }
    }
    
    public func removeRequestCount(videoCode: String) {
        
        requestCountManagementQueue.async(flags: .barrier) { [weak self] in
            
            guard let self else { return }
            
            requestCountState.removeValue(forKey: videoCode)
        }
    }
    
    
    public func requestFailureCount(videoCode: String) -> RxSwift.Single<Int> {
        
        Single.create { [weak self] single in
            
            self?.requestFailureCountManagementQueue.async { [weak self] in
                guard let self else { return }
                
                if let value = requestFailureState[videoCode] {
                    
                    single(.success(value))
                    
                } else {
                    
                    requestFailureState[videoCode] = 0
                    
                    single(.success(0))
                }
            }
            
            return Disposables.create { }
        }
    }
    
    public func countUpFailureCount(videoCode: String) {
        
        requestFailureCountManagementQueue.async(flags: .barrier) { [weak self] in
            
            guard let self else { return }
            
            requestFailureState[videoCode]? += 1
        }
    }
    
    public func removeFailureCount(videoCode: String) {
        
        requestFailureCountManagementQueue.async(flags: .barrier) { [weak self] in
            
            guard let self else { return }
            
            requestFailureState.removeValue(forKey: videoCode)
        }
    }
}
