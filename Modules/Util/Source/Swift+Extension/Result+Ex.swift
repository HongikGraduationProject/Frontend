//
//  Result+Ex.swift
//  Shortcap
//
//  Created by choijunios on 11/26/24.
//

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
