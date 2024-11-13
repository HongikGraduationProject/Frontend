//
//  RequestCountTracker.swift
//  Shortcap
//
//  Created by choijunios on 11/13/24.
//

import RxSwift

public protocol RequestCountTracker {
    
    func requestRequestCount(videoCode: String) -> Single<Int>
    
    func countUpRequestCount(videoCode: String)
}
