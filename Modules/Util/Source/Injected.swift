//
//  Injected.swift
//  Shortcap
//
//  Created by choijunios on 11/13/24.
//

import Foundation

@propertyWrapper
public class Injected<T> {
    
    public let wrappedValue: T
    
    public init() {
        self.wrappedValue = DependencyInjector.shared.resolve()
    }
}
