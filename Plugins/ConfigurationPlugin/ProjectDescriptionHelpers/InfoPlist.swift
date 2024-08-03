//
//  ShorcapInfoPlist.swift
//  ConfigurationPlugin
//
//  Created by 최준영 on 8/03/24.
//

import ProjectDescription

public enum ShorcapInfoPlist {
    
    public static let app: InfoPlist = .extendingDefault(with: [
        "NSAppTransportSecurity" : [
            "NSAllowsArbitraryLoads" : true
        ],
        "UILaunchStoryboardName": "LaunchScreen.storyboard",
        "UIApplicationSceneManifest": [
            "UIApplicationSupportsMultipleScenes": false,
            "UISceneConfigurations": [
                "UIWindowSceneSessionRoleApplication": [
                    [
                        "UISceneConfigurationName": "Default Configuration",
                        "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                    ]
                ]
            ]
        ]
    ])
}


