//
//  AuthService.swift
//  DataSource
//
//  Created by choijunios on 8/9/24.
//

import Foundation

/// AuthService입니다.
public typealias AuthService = BaseNetworkService<AuthAPI>

public class DefaultAuthService: AuthService { }
