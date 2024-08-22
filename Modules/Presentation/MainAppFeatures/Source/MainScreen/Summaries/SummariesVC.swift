//
//  SummariesVC.swift
//  MainAppFeatures
//
//  Created by choijunios on 8/18/24.
//

import UIKit
import BaseFeature
import RxCocoa
import RxSwift
import Entity
import DSKit

fileprivate enum SummariesVCConfig {
    static let tabItemWidth: CGFloat = 54
}

public class SummariesVC: BaseVC {
    
    // Init
    
    // Not init
    var viewModel: SummariesVMable?
    
    // View
    let shortcapLogoView: UIView = {
        let imageView = UIImageView(
            image: DSKitAsset.Images.shortcapTitle.image
        )
        imageView.contentMode = .center
        
        let view = UIView()
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        view.backgroundColor = DSColors.gray0.color
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.05
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 5
        return view
    }()
    
    // MARK: 상단 메인카테고리 탭바
    lazy var mainCategoryTabContainer: HStack = {
        let itemViews = MainCategory.allCases.map { cat in
            let itemVew = MainCategoryTabButton(
                mainCategory: cat,
                itemWidth: SummariesVCConfig.tabItemWidth
            )
            mainCategoryTabItems[cat] = itemVew
            return itemVew
        }
        let stack = HStack(itemViews, spacing: 0, alignment: .fill)
        return stack
    }()
    var mainCategoryTabItems: [MainCategory: MainCategoryTabButton] = [:]
    let mainCategoryTabScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delaysContentTouches = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    let mainCategoryIndicator: UIView = .init()
    
    // MARK: 요약 전체 조회 화면
    let allSummaryListView = AllSummaryListView()
    
    
    // Observable
    private let disposeBag = DisposeBag()
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) { fatalError() }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setAppearance()
        setLayout()
        setObservable()
    }
    
    public func bind(viewModel: SummariesVMable) {
        self.viewModel = viewModel
        
        // MARK: 전체화면 조회 바인딩
        let allSummaryListVM = viewModel.createAllListVM()
        allSummaryListView.bind(viewModel: allSummaryListVM)
    }
    
    /// 탭바의 순서를 변경합니다.
    func reConfigureTabOrder(preferredCategory: [MainCategory]) {
        
        let sortedCategories = preferredCategory.sorted(by: { cat1, cat2 in cat1.pageOrderNumber < cat2.pageOrderNumber })
        
        for category in sortedCategories {
            let itemView = mainCategoryTabItems[category]!
            mainCategoryTabContainer.removeArrangedSubview(itemView)
            // 전체보다 뒤에 삽입한다.
            mainCategoryTabContainer.insertArrangedSubview(itemView, at: 1)
        }
    }
    
    private func setAppearance() {
        view.backgroundColor = DSColors.gray0.color
    }
    
    private func setLayout() {
        
        // MARK: 상단 메인카테고리 탭
        setMainCategoryTabScrollView()

        // MARK: view
        [
            shortcapLogoView,
            mainCategoryTabScrollView,
            allSummaryListView,
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
       
        NSLayoutConstraint.activate([
            shortcapLogoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 3),
            shortcapLogoView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            shortcapLogoView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            shortcapLogoView.heightAnchor.constraint(equalToConstant: 47.13),
            
            mainCategoryTabScrollView.topAnchor.constraint(equalTo: shortcapLogoView.bottomAnchor, constant: 12.87),
            mainCategoryTabScrollView.leftAnchor.constraint(equalTo: shortcapLogoView.safeAreaLayoutGuide.leftAnchor),
            mainCategoryTabScrollView.rightAnchor.constraint(equalTo: shortcapLogoView.safeAreaLayoutGuide.rightAnchor),
            
            mainCategoryTabScrollView.heightAnchor.constraint(equalToConstant: 29),
            mainCategoryTabContainer.heightAnchor.constraint(equalTo: mainCategoryTabScrollView.heightAnchor),
            
            allSummaryListView.topAnchor.constraint(equalTo: mainCategoryTabScrollView.bottomAnchor, constant: 12),
            allSummaryListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            allSummaryListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            allSummaryListView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setMainCategoryTabScrollView() {
        mainCategoryTabScrollView.contentInset.left = 20
        let contentGuide = mainCategoryTabScrollView.contentLayoutGuide
        let frameGuide = mainCategoryTabScrollView.contentLayoutGuide
        mainCategoryTabScrollView.addSubview(mainCategoryTabContainer)
        mainCategoryTabContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainCategoryTabContainer.topAnchor.constraint(equalTo: contentGuide.topAnchor),
            mainCategoryTabContainer.leftAnchor.constraint(equalTo: contentGuide.leftAnchor),
            mainCategoryTabContainer.rightAnchor.constraint(equalTo: contentGuide.rightAnchor),
            mainCategoryTabContainer.bottomAnchor.constraint(equalTo: contentGuide.bottomAnchor),
            
            mainCategoryTabContainer.heightAnchor.constraint(equalTo: frameGuide.heightAnchor),
        ])
    }
    
    private func setObservable() {
        
    }
}

@available(iOS 17.0, *)
#Preview("Preview", traits: .defaultLayout) {
    
    SummariesVC()
}
