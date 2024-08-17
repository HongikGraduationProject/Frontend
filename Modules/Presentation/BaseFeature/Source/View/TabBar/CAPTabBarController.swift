//
//  CAPTabBarController.swift
//  BaseFeature
//
//  Created by choijunios on 8/15/24.
//

import UIKit
import UIKit
import RxCocoa
import RxSwift
import Entity
import DSKit

public class CAPTabBarController: BaseVC {
    
    // Init
    
    // View
    private(set) var childControllers: [CAPMainPage: UINavigationController] = [:]
    
    private var tabBarItemContainer: UIView!
    
    private(set) var displayingVC: UIViewController?
    
    // Observable
    private let disposeBag = DisposeBag()
    
    public init(info: [PageTabItemInfo]) {
        super.init(nibName: nil, bundle: nil)
        
        setPageControllers(info)
        setPageTabItem()
    }
    
    public required init?(coder: NSCoder) { fatalError() }
    
    public override func viewDidLoad() {
        setAppearance()
        setLayout()
        setObservable()
    }
    
    private func setAppearance() {
        view.backgroundColor = DSColors.gray0.color
    }
    
    private func setLayout() {
        view.addSubview(tabBarItemContainer)
        tabBarItemContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tabBarItemContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            tabBarItemContainer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10.5),
            tabBarItemContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10.5),
        ])
    }
    
    private func setObservable() {
        
    }
}


// MARK: TabBar Flow
public struct PageTabItemInfo {
    let page: CAPMainPage
    let navigationController: UINavigationController
    
    public init(page: CAPMainPage, navigationController: UINavigationController) {
        self.page = page
        self.navigationController = navigationController
    }
}

public extension CAPTabBarController {
    
    /// #1. 현재 컨트롤러에 페이지 컨트롤러들을 세팅합니다.
    private func setPageControllers(_ using: [PageTabItemInfo]) {
        using.forEach { info in
            let controller = info.navigationController
            addChild(controller)
            controller.didMove(toParent: self)
            childControllers[info.page] = controller
        }
    }
    
    /// #2. 페이지별 탭바 아이템뷰를 설정합니다.
    private func setPageTabItem() {
        
        let pages = childControllers.keys.sorted { $0.pageOrderNumber() < $1.pageOrderNumber() }
        
        let itemViews = pages.map { page in
            CAPTabBarItemView(
                index: page.pageOrderNumber(),
                labelText: page.tabItemText(),
                imageSet: .init(
                    idleImage: page.tabItemIcon(.idle),
                    accentImage: page.tabItemIcon(.accent)
                )
            )
        }
        
        tabBarItemContainer = HStack(itemViews, alignment: .fill, distribution: .fillEqually)
    }
    
    /// 해당 함수는 뷰모델에 의해서만 호출됩니다. 특정 페이지를 display합니다.
    private func setPage(index: Int) {
        
        displayingVC?.view.removeFromSuperview()
        
        let page = CAPMainPage(index: index)!
        let willDisplayVC = childControllers[page]!
        let willDisplayView = willDisplayVC.view!
        
        view.addSubview(willDisplayView)
        willDisplayView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            willDisplayView.topAnchor.constraint(equalTo: view.topAnchor),
            willDisplayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            willDisplayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            willDisplayView.bottomAnchor.constraint(equalTo: tabBarItemContainer.topAnchor)
        ])
        
        displayingVC = willDisplayVC
    }
}
