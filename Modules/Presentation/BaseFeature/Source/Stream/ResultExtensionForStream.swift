//
//  ResultExtensionForStream.swift
//  BaseFeature
//
//  Created by choijunios on 8/11/24.
//

import Foundation

public extension Result {
    var value: Success? {
        guard case let .success(value) = self else {
            return nil
        }
        return value
    }

    var error: Failure? {
        guard case let .failure(error) = self else {
            return nil
        }
        return error
    }
}
