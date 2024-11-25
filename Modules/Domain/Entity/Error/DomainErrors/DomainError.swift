//
//  DomainError.swift
//  Entity
//
//  Created by choijunios on 8/11/24.
//

import Foundation

public protocol DomainError: RawRepresentable, Error where RawValue == String {
    
    var message: String { get }
    
    static var networkNotConnected: Self { get }
    static var undefinedError: Self { get }
}
