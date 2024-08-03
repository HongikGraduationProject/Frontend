//
//  Config.swift
//  Packages
//
//  Created by 최준영 on 8/03/24.
//

import Foundation
import ProjectDescription

let config = Config(
    plugins: [
        .local(path: .relativeToRoot("Plugins/ConfigurationPlugin")),
    ]
)
