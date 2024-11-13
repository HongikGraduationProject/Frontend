//
//  DependencyInjector.swift
//  App
//
//  Created by choijunios on 8/11/24.
//

import Foundation
import Swinject

/// DI 대상 등록
public protocol DependencyAssemblable {
    func assemble(_ assemblyList: [Assembly])
    func register<T>(_ serviceType: T.Type, _ object: T)
}

/// DI 등록한 서비스 사용
public protocol DependencyResolvable {
    func resolve<T>(_ serviceType: T.Type) -> T
    func resolve<T>(_ serviceType: T.Type, name: String) -> T
}

public typealias Injector = DependencyAssemblable & DependencyResolvable

/// 의존성 주입을 담당하는 인젝터
public final class DependencyInjector: Injector {
    
    public static let shared: DependencyInjector = .init(container: Container())
    
    private let container: Container
    
    public init(container: Container) {
        self.container = container
    }
    
    public func assemble(_ assemblyList: [Assembly]) {
        assemblyList.forEach {
            $0.assemble(container: container)
        }
    }
    
    public func register<T>(_ serviceType: T.Type, _ object: T) {
        container.register(serviceType) { _ in object }
    }
    
    func resolve<T>() -> T {
        container.resolve(T.self)!
    }
    
    public func resolve<T>(_ serviceType: T.Type) -> T {
        container.resolve(serviceType)!
    }
    
    public func resolve<T>(_ serviceType: T.Type, name: String) -> T {
        container.resolve(serviceType, name: name)!
    }
}
