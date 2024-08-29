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
import CommonUI

public class CAPTabBarController: BaseVC {
    public typealias Item = CAPMainPage
    public struct PageTabItemInfo {
        let page: Item
        let navigationController: UINavigationController
        
        public init(page: Item, navigationController: UINavigationController) {
            self.page = page
            self.navigationController = navigationController
        }
    }
    
    // Init
    let initialPage: Item
    
    // 탭바구성
    private(set) var childControllers: [Item: UINavigationController] = [:]
    private(set) var items: [Item: CAPTabBarItemView] = [:]
    
    
    // View
    private(set) var displayingVC: UIViewController?
    // - 탭바 아이템 컨테이너
    private var tabBarItemContainer: CAPTabBarItemContainer!
    
    
    // Observable
    private let disposeBag = DisposeBag()
    
    public init(
        initialPage: Item,
        info: [PageTabItemInfo]) 
    {
        self.initialPage = initialPage
        super.init(nibName: nil, bundle: nil)
        
        setPageControllers(info)
        setPageTabItem()
    }
    
    public required init?(coder: NSCoder) { fatalError() }
    
    public override func viewDidLoad() {
        setAppearance()
        setLayout()
        setObservable()
        
        // 최초화면 보여주기
        items[initialPage]?.setState(.accent)
        setPage(page: initialPage)
    }
    
    private func setAppearance() {
        view.backgroundColor = DSColors.gray0.color
    }
    
    private func setLayout() {
        view.addSubview(tabBarItemContainer)
        tabBarItemContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tabBarItemContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tabBarItemContainer.leftAnchor.constraint(equalTo: view.leftAnchor),
            tabBarItemContainer.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
    
    private func setObservable() {
        let selectionPublishers = items.map { (page: Item, itemView: CAPTabBarItemView) in
            itemView.rx.tap.map { _ in page }
        }
        
        Observable
            .merge(selectionPublishers)
            .subscribe(onNext: { [weak self] selectedPage in
                guard let self else { return }
                
                // 선택된 화면 표출
                setPage(page: selectedPage)
                
                // Item들 외향 변경
                items.forEach { (page: Item, itemView: CAPTabBarItemView) in
                    itemView.setState(selectedPage == page ? .accent : .idle)
                }
            })
            .disposed(by: disposeBag)
            
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
            let itemView = CAPTabBarItemView(
                index: page.pageOrderNumber(),
                labelText: page.tabItemText(),
                imageSet: .init(
                    idleImage: page.tabItemIcon(.idle),
                    accentImage: page.tabItemIcon(.accent)
                )
            )
            
            items[page] = itemView
            
            return itemView
        }
        
        tabBarItemContainer = CAPTabBarItemContainer(items: itemViews)
    }
    
    /// 해당 함수는 뷰모델에 의해서만 호출됩니다. 특정 페이지를 display합니다.
    private func setPage(page: Item) {
        
        displayingVC?.view.removeFromSuperview()
        
        let willDisplayVC = childControllers[page]!
        let willDisplayView = willDisplayVC.view!
        
        view.insertSubview(willDisplayView, belowSubview: tabBarItemContainer)
        willDisplayView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            willDisplayView.topAnchor.constraint(equalTo: view.topAnchor),
            willDisplayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            willDisplayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            willDisplayView.bottomAnchor.constraint(equalTo: tabBarItemContainer.topAnchor, constant: 30)
        ])
        
        displayingVC = willDisplayVC
    }
}
