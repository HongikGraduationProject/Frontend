// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,] 
        productTypes: [:]
    )
#endif

let package = Package(
    name: "Shortcap",
    dependencies: [
        // RxSwift
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.7.1"),
        // Swinject
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.9.1"),
        // Moya
        .package(url: "https://github.com/Moya/Moya.git", from: "15.0.3"),
        // KingFisher
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.12.0"),
        // Naver map
        .package(url: "https://github.com/J0onYEong/NaverMapSDKForSPM.git", from: "1.0.0"),
    ]
)
