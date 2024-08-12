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
        ],
        
        // 앱추적 허용 메세지
        "NSUserTrackingUsageDescription": "사용자 맞춤 서비스 제공을 위해 권한을 허용해 주세요. 권한을 허용하지 않을 경우, 앱 사용에 제약이 있을 수 있습니다."
    ])
}


