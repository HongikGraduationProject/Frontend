//
//  ShorcapInfoPlist.swift
//  ConfigurationPlugin
//
//  Created by 최준영 on 8/03/24.
//

import ProjectDescription

public enum ShorcapInfoPlist {
    
    public static let mainApp: InfoPlist = .extendingDefault(with: [
        
        "CFBundleShortVersionString": "1.0.0",
        
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
        
        // 네트워크 사용 메세지
        "NSLocalNetworkUsageDescription": "이 앱은 로컬 네트워크를 통해 서버에 연결하여 데이터를 주고받기 위해 로컬 네트워크 접근 권한이 필요합니다.",
        
        "NMFClientId": "$(NAVER_API_CLIENT_ID)",
        
        // iPad 런치시 풀스크린 요구
        "UIRequiresFullScreen": true,
    ])
    
    public static let actionExtension: InfoPlist = .extendingDefault(
        with: [
            "NSAppTransportSecurity" : [
                "NSAllowsArbitraryLoads" : true
            ],
            
            // Action노출명
            "CFBundleDisplayName": "Shorcap에 요약하고 저장하기",
            
            // Action extension 설정
            "NSExtension": [
                "NSExtensionAttributes": [
                    "NSExtensionActivationRule": [
                        "NSExtensionActivationSupportsWebURLWithMaxCount": 1
                    ],
                    "NSExtensionServiceAllowsFinderPreviewItem": true,
                    "NSExtensionServiceAllowsTouchBarItem": true,
                    "NSExtensionServiceFinderPreviewIconName": "NSActionTemplate",
                    "NSExtensionServiceTouchBarBezelColorName": "TouchBarBezel",
                    "NSExtensionServiceTouchBarIconName": "NSActionTemplate"
                ],
                "NSExtensionMainStoryboard": "MainInterface",
                "NSExtensionPointIdentifier": "com.apple.ui-services"
            ],
            
            // 앱추적 허용 메세지
            "NSUserTrackingUsageDescription": "사용자 맞춤 서비스 제공을 위해 권한을 허용해 주세요. 권한을 허용하지 않을 경우, 앱 사용에 제약이 있을 수 있습니다.",
            
            
            // 네트워크 사용 메세지
            "NSLocalNetworkUsageDescription": "이 앱은 로컬 네트워크를 통해 서버에 연결하여 데이터를 주고받기 위해 로컬 네트워크 접근 권한이 필요합니다."
        ]
    )
}


