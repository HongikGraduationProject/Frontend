//
//  SummaryListPageViewController.swift
//  MainAppFeatures
//
//  Created by choijunios on 8/18/24.
//

import UIKit

import Entity
import DSKit
import CommonUI
import PresentationUtil


import RxCocoa
import RxSwift

class SummaryListPageViewController: BaseVC {
    
    // Init
    private let viewModel: SummaryListPageViewModel
    
    
    // Not init
    
    
    // View
    private let shortcapLogoView: UIView = {
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
    private let searchButton: SearchButton = .init()
    
    // MARK: 로딩 텍스트
    private let summaryLoadingView: SummaryLoadingView = {
        let view = SummaryLoadingView()
        view.alpha = 0
        return view
    }()
    
    // MARK: 상단 메인카테고리 탭바
    private let mainCategoryTabContainer: HStack = {
        let stack = HStack([], spacing: 0, alignment: .fill)
        return stack
    }()
    private var mainCategoryTabItems: [MainCategory: MainCategoryTabButton] = [:]
    
    private let mainCategoryTabScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delaysContentTouches = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    private let mainCategoryIndicator: UIView = .init()
        
    
    // MARK: TableView
    typealias Cell = SummaryCell
    private var tableViewDataSource: UITableViewDiffableDataSource<Int, Int>!
    private let summariesTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    
    // Observable
    private let disposeBag = DisposeBag()
    
    
    // Constraints
    private var topConstraintForTableView: NSLayoutConstraint?
    
    
    init(viewModel: SummaryListPageViewModel) {
        
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        setCategoryTabBar()
        setTableView()
        
        bindViewModel()
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setCategoryTabBar() {
        
        let itemViews = MainCategory.allCases.map { cat in
            let itemVew = MainCategoryTabButton(
                mainCategory: cat,
                itemWidth: 54
            )
            mainCategoryTabItems[cat] = itemVew
            return itemVew
        }
        
        for itemView in itemViews {
            mainCategoryTabContainer.addArrangedSubview(itemView)
        }
    }
    
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
        summariesTableView.rowHeight = 160
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAppearance()
        setLayout()
        setObservable()
    }
    
    func bindViewModel() {
        
        // Output
        viewModel
            .summaryItems
            .drive(onNext: { [weak self] summaries in
                
                guard let self else { return }
            
                var snapShot: NSDiffableDataSourceSnapshot<Int, Int> = .init()
                
                snapShot.appendSections([0])
                
                let itemIds = summaries.map { $0.videoSummaryId }
                snapShot.appendItems(itemIds, toSection: 0)
                
                tableViewDataSource.apply(snapShot, animatingDifferences: true)
            })
            .disposed(by: disposeBag)
        
        
        viewModel
            .alert
            .drive(onNext: { [weak self] alertVO in

                self?.showAlert(alertVO: alertVO)
            })
            .disposed(by: disposeBag)
        
        
        viewModel
            .presentSummaryLoading
            .drive(onNext: { [weak self] isPresented in
                
                guard let self else { return }
                
                if isPresented {
                    
                    startSummaryLoading()
                } else {
                    
                    stopSummaryLoading()
                }
                
            })
            .disposed(by: disposeBag)
        
        
        if let preferedCategories = viewModel.requestPreferedCategories() {
            
            reConfigureTabOrder(
                preferredCategory: preferedCategories
            )
        }
        
        
        // Input
        let initialEvent = Single.just((MainCategory.all))
        
        var categorySelectionEvent = mainCategoryTabItems
            .map { (key, button) in
                button.tap
                    .map { _ in key }
            }
        
        categorySelectionEvent.append(initialEvent.asObservable())
        
        Observable
            .merge(categorySelectionEvent)
            .bind(to: viewModel.currentSelectedCategoryForFilter)
            .disposed(by: disposeBag)
        
        searchButton.rx.tap
            .bind(to: viewModel.searchButtonClicked)
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
            searchButton,
            summaryLoadingView,
            summariesTableView,
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        self.topConstraintForTableView = summariesTableView.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 10)
        
        self.topConstraintForTableView?.isActive = true
       
        NSLayoutConstraint.activate([
            
            // MARK: Logo
            shortcapLogoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 3),
            shortcapLogoView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            shortcapLogoView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            shortcapLogoView.heightAnchor.constraint(equalToConstant: 47.13),
            
            
            // MARK: 카테고리 선택
            mainCategoryTabScrollView.topAnchor.constraint(equalTo: shortcapLogoView.bottomAnchor, constant: 12.87),
            mainCategoryTabScrollView.leftAnchor.constraint(equalTo: shortcapLogoView.safeAreaLayoutGuide.leftAnchor),
            mainCategoryTabScrollView.rightAnchor.constraint(equalTo: shortcapLogoView.safeAreaLayoutGuide.rightAnchor),
            
            mainCategoryTabScrollView.heightAnchor.constraint(equalToConstant: 29),
            mainCategoryTabContainer.heightAnchor.constraint(equalTo: mainCategoryTabScrollView.heightAnchor),
            
            
            // MARK: SEARCH
            searchButton.topAnchor.constraint(equalTo: mainCategoryTabScrollView.bottomAnchor, constant: 12),
            searchButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            searchButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            
            summaryLoadingView.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 10),
            summaryLoadingView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            
            
            // MARK: 테이블뷰
            summariesTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            summariesTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            summariesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
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
        
        // MARK: 라디오 버튼 세팅
        let categorySelectionEvent = mainCategoryTabItems
            .map { (key, button) in
                button.tap
                    .map { _ in key }
            }
        
        Observable
            .merge(categorySelectionEvent)
            .withUnretained(self)
            .subscribe { (vc, category) in
                
                // 상태변경
                vc.mainCategoryTabItems.forEach { (key, button) in
                    
                    if key != category {
                        button.toIdle()
                    }
                }
            }
            .disposed(by: disposeBag)
        
        // 첫번째 버튼은 all
        mainCategoryTabItems[.all]?.toAccent()
    }
    
    private func startSummaryLoading() {
        
        summaryLoadingView.alpha = 1
        
        UIView.animate(withDuration: 0.35) {
            self.topConstraintForTableView?.constant = 54
            self.view.layoutIfNeeded()
        }
        
        summaryLoadingView.start()
    }
    
    private func stopSummaryLoading() {
        
        UIView.animate(withDuration: 0.15) {
            self.topConstraintForTableView?.constant = 10
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.summaryLoadingView.alpha = 0
        }
        
        summaryLoadingView.stop()
    }
}

extension SummaryListPageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let cell = cell as? Cell else { fatalError() }
        
        cell.cellIsAppeared()
    }
}
