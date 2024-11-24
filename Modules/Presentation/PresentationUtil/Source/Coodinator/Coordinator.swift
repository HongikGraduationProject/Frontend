//
//  Coordinator.swift
//  BaseFeature
//
//  Created by choijunios on 8/11/24.
//

/// - 기본
///     - Coodinator와 ViewController는 1대1로 매치된다.
///         - 하나의 객체가 하나의 ViewController를 닫고 여는 과정을 일관되게 하기 위해서 입니다.
///  - Parent Child Coordinator
///     - Coodinator는 스스로 종료(VC제거, 자신 메모리 해제)될 수 있다.
///     - 부모 Coordinator는 특정 자식 Coodinator가 인지할 수 있다
///     - Coodinator는 자식 Coodinator를 가질 수 있다.
///     - Coodinator는 모든 자식 Coodinator를 종료할 수 있다. (VC를 닫고 메모리 해제)
/// - 의존성
///     - 의존성 주입은 App에만 진행됨으로, 의존성 주입이 필요한 Coodinator는 App레이어에 위치한다.

import UIKit

public protocol Coordinator: AnyObject {
    
    var navigationController: UINavigationController { get }
    var children: [Coordinator] { get set }
    var parent: Coordinator? { get set }
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    
    /// 화면조율을 시작합니다.
    func start()
    
    /// 코디네이터를 종료합니다. 자신의 ViewController도 제거됩니다.
    /// 자식을 가질 경우 모든 자식도 함께 종료합니다.
    func finish(_ animated: Bool)
    
    /// 자식 Coordinator를 추가합니다.
    func addChild(_ child: Coordinator)
    
    /// 자식 Coordinator를 삭제합니다. 해당 함수는 자식이 부모의 함수를 호출합니다.
    func removeChild(_ child: Coordinator)
}

public extension Coordinator {
    
    func addChild(_ child: Coordinator) {
        child.parent = self
        children.append(child)
    }
    
    func removeChild(_ child: Coordinator) {
        children.removeAll { coordinator in
            coordinator === child
        }
    }
    
    func finish(_ animated: Bool) {
        
        let hasChild: Bool = !children.isEmpty
        
        if hasChild {
            
            // 가장마지막에 있는 코디네이터를 추출합니다.
            let topMostCoodinator = children.popLast()!
            
            // 나머지 코디네이터들을 애니메이션 없이 종료합니다.
            children.forEach { coodinator in
                coodinator.finish(false)
            }
            
            // 가장 마지막 코디네이터를 종료합니다.
            topMostCoodinator.finish(animated)
        }
        
        // - 현재 코디네이터의 VC와 자기자신을 제거
            
        // 현재 뷰컨트롤러를 제거합니다.
        // 자식이 없다면 애니메이션과 함께 현재 뷰컨트롤러를 종료합니다.
        navigationController.popViewController(animated: hasChild ? false : animated)
        
        // 자식 코디네이터를 부모 배열에서 제거합니다.
        parent?.removeChild(self)
        
        // 위임자에게 특정 코디네이터가 종료되었음을 알립니다.
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

public protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}
