//
//  ThreadSafeDictionary.swift
//  Util
//
//  Created by choijunios on 8/20/24.
//

import Foundation
import RxSwift

/// Thread safe를 지원하는 딕셔너리 입니다.
open class ThreadSafeDictionary<Key: Hashable, Value> {
    private var dict: [Key: Value] = [:]
    private let queue = DispatchQueue.global(qos: .userInteractive)
    
    public init() { }
    
    public func read(_ key: Key) -> Single<Value?> {
        Single<Value?>.create { [queue] single in
            queue.sync { [weak self, single] in
                single(.success(self?.dict[key]))
            }
            return Disposables.create { }
        }
    }
    
    public func write(_ key: Key, value: Value) {
        queue.sync { [weak self] in
            self?.dict[key] = value
        }
    }
    
    public func remove(_ key: Key) {
        queue.sync { [weak self] in
            _ = self?.dict.removeValue(forKey: key)
        }
    }
}
