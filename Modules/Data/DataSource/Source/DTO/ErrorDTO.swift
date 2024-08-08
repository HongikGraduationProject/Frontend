//
//  ErrorDTO.swift
//  DataSource
//
//  Created by choijunios on 8/9/24.
//

import Foundation

struct ErrorDTO: Decodable {
    let result: String
    let message: String?
}
