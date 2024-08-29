//
//  Project.swift
//
//  Created by 최준영 on 8/03/24.
//

import ProjectDescription
import ConfigurationPlugin

let project = Project(
    name: "Shortcap",
    targets: [
        // MARK: App
        .target(
            name: "MainApp",
            destinations: .iOS,
            product: .app,
            productName: DeploymentSettings.productName,
            bundleId: DeploymentSettings.bundleIdentifierPrefix,
            deploymentTargets: DeploymentSettings.deploymentVersion,
            infoPlist: ShorcapInfoPlist.mainApp,
            sources: ["Modules/App/MainApp/Source/**"],
            resources: ["Modules/App/MainApp/Resource/**"],
            entitlements: .file(path: .relativeToRoot("Entitlements/MainApp.entitlements")),
            dependencies: [
                .target(name: "ActionExtension"),
                .target(name: "MainAppFeatures"),
                
                // ThirdParty : Service locator
                .external(name: "Swinject"),
            ]
        ),
        
        // MARK: ExampleApp
        .target(
            name: "ExampleApp",
            destinations: .iOS,
            product: .app,
            productName: DeploymentSettings.productName+"ExampleApp",
            bundleId: "\(DeploymentSettings.bundleIdentifierPrefix).exampleApp",
            deploymentTargets: DeploymentSettings.deploymentVersion,
            infoPlist: ShorcapInfoPlist.mainApp,
            sources: ["Modules/App/ExampleApp/Source/**"],
            resources: ["Modules/App/ExampleApp/Resource/**"],
            dependencies: [
                .target(name: "MainAppFeatures"),
            ]
        ),
        
        // MARK: ActionExtension
        .target(
            name: "ActionExtension",
            destinations: .iOS,
            product: .appExtension,
            productName: DeploymentSettings.productName+"ActionExt",
            bundleId: "\(DeploymentSettings.bundleIdentifierPrefix).actionExt",
            deploymentTargets: DeploymentSettings.deploymentVersion,
            infoPlist: ShorcapInfoPlist.actionExtension,
            sources: ["Modules/App/ActionExtension/Source/**"],
            resources: ["Modules/App/ActionExtension/Resource/**"],
            entitlements: .file(path: .relativeToRoot("Entitlements/AppExtension.entitlements")),
            dependencies: [
                .target(name: "AppExtensionFeatures"),
                
                // ThirdParty : Service locator
                .external(name: "Swinject"),
            ]
        ),
        
        
        // MARK: Presentation
        .target(
            name: "MainAppFeatures",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "\(DeploymentSettings.bundleIdentifierPrefix).mainAppFeatures",
            deploymentTargets: DeploymentSettings.deploymentVersion,
            sources: ["Modules/Presentation/MainAppFeatures/Source/**"],
            resources: ["Modules/Presentation/MainAppFeatures/Resource/**"],
            dependencies: [
                .target(name: "PresentationUtil"),
            ]
        ),
        .target(
            name: "AppExtensionFeatures",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "\(DeploymentSettings.bundleIdentifierPrefix).extensionAppFeatures",
            deploymentTargets: DeploymentSettings.deploymentVersion,
            sources: ["Modules/Presentation/AppExtensionFeatures/Source/**"],
            resources: ["Modules/Presentation/AppExtensionFeatures/Resource/**"],
            dependencies: [
                .target(name: "PresentationUtil"),
            ]
        ),
        .target(
            name: "PresentationUtil",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(DeploymentSettings.bundleIdentifierPrefix).presentationUtil",
            deploymentTargets: DeploymentSettings.deploymentVersion,
            sources: ["Modules/Presentation/PresentationUtil/Source/**"],
            resources: ["Modules/Presentation/PresentationUtil/Resource/**"],
            dependencies: [
                
                // Domain
                .target(name: "UseCase"),
                .target(name: "Entity"),
                
                // Data
                .target(name: "Repository"),
                
                // Presentation
                .target(name: "CommonUI"),
                
                
                // ThirdParty
                .external(name: "RxSwift"),
                .external(name: "RxCocoa"),
            ]
        ),
        
        
        // MARK: CommonUI
        .target(
            name: "CommonUI",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(DeploymentSettings.bundleIdentifierPrefix).commonUI",
            deploymentTargets: DeploymentSettings.deploymentVersion,
            sources: ["Modules/Presentation/CommonUI/Source/**"],
            dependencies: [
                .target(name: "DSKit"),
            ]
        ),
        
        
        // MARK: DSKit
        .target(
            name: "DSKit",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(DeploymentSettings.bundleIdentifierPrefix).dskit",
            deploymentTargets: DeploymentSettings.deploymentVersion,
            sources: ["Modules/Presentation/DSKit/Source/**"],
            resources: ["Modules/Presentation/DSKit/Resource/**"],
            dependencies: [
                // Util
                .target(name: "Entity"),
                .target(name: "Util"),
                
                // ThirdParty
                .external(name: "RxCocoa"),
            ]
        ),
        
        
        
        // MARK: Domain
        .target(
            name: "UseCase",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(DeploymentSettings.bundleIdentifierPrefix).usecase",
            deploymentTargets: DeploymentSettings.deploymentVersion,
            sources: ["Modules/Domain/UseCase/Source/**"],
            dependencies: [
                // Util
                .target(name: "Util"),
                
                // Domain
                .target(name: "Entity"),
            ]
        ),
        .target(
            name: "Entity",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(DeploymentSettings.bundleIdentifierPrefix).entity",
            deploymentTargets: DeploymentSettings.deploymentVersion,
            sources: ["Modules/Domain/Entity/Source/**"]
        ),
        
        
        
        // MARK: Data
        .target(
            name: "DataSource",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(DeploymentSettings.bundleIdentifierPrefix).dataSource",
            deploymentTargets: DeploymentSettings.deploymentVersion,
            sources: [
                "Modules/Data/DataSource/Source/**",
                .glob(.relativeToRoot("Secrets/DataSource/**"))
            ],
            resources: [
                "Modules/Data/DataSource/Resource/**"
            ],
            dependencies: [
                .target(name: "Entity"),
                .target(name: "Util"),
                
                // ThirdParty
                .external(name: "Moya"),
                .external(name: "RxMoya"),
            ]
        ),
        .target(
            name: "Repository",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(DeploymentSettings.bundleIdentifierPrefix).repository",
            deploymentTargets: DeploymentSettings.deploymentVersion,
            sources: ["Modules/Data/Repository/Source/**"],
            dependencies: [
                .target(name: "UseCase"),
                .target(name: "DataSource"),
            ]
        ),
        
        
        
        // MARK: Util
        /// Util은 모든 레이어에서 사용할 수 있는 언어수준의 유틸리티를 제공합니다. 다만, 플렛폼에 의존적인 패키지는 사용하지 않습니다.
        .target(
            name: "Util",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(DeploymentSettings.bundleIdentifierPrefix).util",
            deploymentTargets: DeploymentSettings.deploymentVersion,
            sources: ["Modules/Util/Source/**"],
            dependencies: [
                // ThirdParty
                .external(name: "RxSwift")
            ]
        ),
        
        
        
        // MARK: Tests
        .target(
            name: "TestTarget",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(DeploymentSettings.bundleIdentifierPrefix).tests",
            infoPlist: .default,
            sources: ["Modules/Tests/Source/**"],
            resources: [],
            dependencies: [
                
            ]
        ),
    ]
)
