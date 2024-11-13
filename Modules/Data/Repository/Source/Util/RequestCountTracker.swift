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

class DefaultRequestCountTracker: RequestCountTracker {
    
    private let managementQueue: DispatchQueue = .init(
        label: "com.RequestCountTracker",
        attributes: .concurrent
    )
    
    private var requestCountState: [String: Int] = [:]
    
    func requestRequestCount(videoCode: String) -> Single<Int> {
        
        Single.create { [weak self] single in
            
            self?.managementQueue.async { [weak self] in
                guard let self else { return }
                
                if let value = requestCountState[videoCode] {
                    
                    single(.success(value))
                    
                } else {
                    
                    single(.success(0))
                }
            }
            
            return Disposables.create { }
        }
    }
    
    func countUpRequestCount(videoCode: String) {
        
        managementQueue.async(flags: .barrier) { [weak self] in
            
            guard let self else { return }
            
            if requestCountState.keys.contains(videoCode) {
                
                requestCountState[videoCode]! += 1
                
            } else {
                
                requestCountState[videoCode] = 1
                
            }
        }
    }
}
