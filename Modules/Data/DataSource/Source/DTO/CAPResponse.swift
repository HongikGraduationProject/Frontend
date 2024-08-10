//
//  CAPResponse.swift
//  DataSource
//
//  Created by choijunios on 8/9/24.
//

import Foundation

public struct CAPResponse<T: Decodable>: Decodable {
    public let result: String
    public let message: String?
    public let data: T?
}
