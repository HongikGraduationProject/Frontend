//
//  CAPResponse.swift
//  DataSource
//
//  Created by choijunios on 8/9/24.
//

import Foundation

struct CAPResponse<T: Decodable>: Decodable {
    let result: String
    let message: String?
    let data: T?
}
