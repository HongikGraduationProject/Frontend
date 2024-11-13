//
//  RequestCountTracker.swift
//  Shortcap
//
//  Created by choijunios on 11/13/24.
//

import Foundation

import Entity
import UseCase


import RxSwift

public class DefaultRequestCountTracker: RequestCountTracker {
    
    private let managementQueue: DispatchQueue = .init(
        label: "com.RequestCountTracker",
        attributes: .concurrent
    )
    
    private var requestCountState: [String: Int] = [:]
    
    public init() { }
    
    public func requestRequestCount(videoCode: String) -> Single<Int> {
        
        Single.create { [weak self] single in
            
            self?.managementQueue.async { [weak self] in
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
        
        managementQueue.async(flags: .barrier) { [weak self] in
            
            guard let self else { return }
            
            requestCountState[videoCode]? += 1
        }
    }
}
