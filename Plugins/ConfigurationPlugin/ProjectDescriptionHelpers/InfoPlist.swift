//
//  ShorcapInfoPlist.swift
//  ConfigurationPlugin
//
//  Created by 최준영 on 8/03/24.
//

import ProjectDescription

public enum ShorcapInfoPlist {
    
    public static let mainApp: InfoPlist = .extendingDefault(with: [
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
        ],
        
        // 화면을 Portrait으로 고정
        "UISupportedInterfaceOrientations": [
            "UIInterfaceOrientationPortrait"
        ],
        
        // URLScheme
        "LSApplicationQueriesSchemes": [
            "youtube",
            "instagram"
        ]
    ])
}


