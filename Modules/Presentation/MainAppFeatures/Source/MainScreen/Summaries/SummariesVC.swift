//
//  SummariesVC.swift
//  MainAppFeatures
//
//  Created by choijunios on 8/18/24.
//

import UIKit
import RxCocoa
import RxSwift
import Entity
import DSKit
import CommonUI
import PresentationUtil

fileprivate enum SummariesVCConfig {
    static let tabItemWidth: CGFloat = 54
}

class SummariesVC: BaseVC {
    
    // Init
    let viewModel: SummariesVM
    
    
    // Not init
    
    
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
        
    
    // MARK: TableView
    typealias Cell = SummaryCell
    var tableViewDataSource: UITableViewDiffableDataSource<Int, Int>!
    let summariesTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    
    // Observable
    private let disposeBag = DisposeBag()
    
    init(viewModel: SummariesVM) {
        
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        setTableView()
        
        bindViewModel()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    
    private func setTableView() {
        // MARK: DataSource
        tableViewDataSource = .init(tableView: summariesTableView, cellProvider: { [weak self] tableView, indexPath, itemIdentifier in
            
            guard let self else { return Cell() }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier) as! Cell
            
            let cellViewModel = viewModel.createCellVM(videoId: itemIdentifier)
            
            cell.selectionStyle = .none
            cell.bind(viewModel: cellViewModel)
            
            return cell
        })
        summariesTableView.dataSource = tableViewDataSource
        summariesTableView.delegate = self
        summariesTableView.register(Cell.self, forCellReuseIdentifier: Cell.identifier)
        summariesTableView.separatorStyle = .none
        summariesTableView.delaysContentTouches = false
        summariesTableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAppearance()
        setLayout()
        setObservable()
    }
    
    func bindViewModel() {
        
        viewModel
            .summaryItems
            .drive(onNext: { [weak self] summaries in
                
                guard let self else { return }
            
                var snapShot: NSDiffableDataSourceSnapshot<Int, Int> = .init()
                
                snapShot.appendSections([0])
                
                let itemIds = summaries.map { $0.videoSummaryId }
                snapShot.appendItems(itemIds, toSection: 0)
                
                tableViewDataSource.apply(snapShot, animatingDifferences: false)
            })
            .disposed(by: disposeBag)
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
            summariesTableView,
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
            
            summariesTableView.topAnchor.constraint(equalTo: mainCategoryTabScrollView.bottomAnchor, constant: 12),
            summariesTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            summariesTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            summariesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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

extension SummariesVC: UITableViewDelegate { }

