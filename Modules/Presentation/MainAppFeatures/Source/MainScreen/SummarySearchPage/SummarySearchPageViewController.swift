//
//  SummarySearchPageViewController.swift
//  Shortcap
//
//  Created by choijunios on 11/24/24.
//

import UIKit

import DSKit
import PresentationUtil
import CommonUI

import RxSwift

class SummarySearchPageViewController: BaseVC {
    
    // View
    private let navigationBar: CAPSummaryDetailNavigationBar = {
        let view = CAPSummaryDetailNavigationBar(titleText: "숏폼 검색")
        view.optionButton.alpha = 0
        return view
    }()
    private let searchField: UITextField = .init()
    private let searchArea: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = DSColors.gray5.color
        return view
    }()
    private let searchButton: TappableUIView = {
        let view = TappableUIView()
        return view
    }()
    
    // MARK: TableView
    typealias Cell = SummaySearchCell
    private var tableViewDataSource: UITableViewDiffableDataSource<Int, String>!
    private let summariesTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    
    private var viewModel: SummarySearchPageViewModelable?
    
    private let disposeBag: DisposeBag = .init()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        setTextField()
        setSearchUI()
    }
    required init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAppearance()
        setLayout()
        setObservable()
        setTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchField.becomeFirstResponder()
    }
    
    private func setAppearance() {
        
        view.backgroundColor = DSColors.gray0.color
    }
    
    private func setTextField() {
        
        // 입력 폰트 설정
        var editAttributes = TypographyStyle.baseBold.typography.attributes()
        editAttributes[.foregroundColor] = DSColors.primary80.color
        searchField.defaultTextAttributes = editAttributes
        
        
        // 플레이스 홀더 폰트 및 텍스트 설정
        var placeholderAttributes = TypographyStyle.smallRegular.typography.attributes()
        placeholderAttributes[.foregroundColor] = DSColors.gray40.color
        let placeholderText: NSAttributedString = .init(
            string: "저장했던 숏폼을 키워드로 검색해보세요!",
            attributes: placeholderAttributes
        )
        searchField.attributedPlaceholder = placeholderText
    }
    
    private func setSearchUI() {
        
        let searchIcon = UIImageView(image: DSKitAsset.Images.search.image)
        
        searchButton.addSubview(searchIcon)
        searchIcon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            searchIcon.topAnchor.constraint(
                equalTo: searchButton.topAnchor),
            searchIcon.bottomAnchor.constraint(
                equalTo: searchButton.bottomAnchor),
            searchIcon.leftAnchor.constraint(
                equalTo: searchButton.leftAnchor),
            searchIcon.rightAnchor.constraint(
                equalTo: searchButton.rightAnchor),
        ])
        
        let searchStack: HStack = .init([
            searchField,
            searchButton
        ], spacing: 10, alignment: .center, distribution: .fill)
        
        searchArea.addSubview(searchStack)
        searchStack.translatesAutoresizingMaskIntoConstraints = false
        
        searchArea.layoutMargins = .init(
            top: 14,
            left: 18,
            bottom: 14,
            right: 18
        )
        
        NSLayoutConstraint.activate([
            
            searchStack.topAnchor.constraint(
                equalTo: searchArea.layoutMarginsGuide.topAnchor),
            searchStack.bottomAnchor.constraint(
                equalTo: searchArea.layoutMarginsGuide.bottomAnchor),
            searchStack.leftAnchor.constraint(
                equalTo: searchArea.layoutMarginsGuide.leftAnchor),
            searchStack.rightAnchor.constraint(
                equalTo: searchArea.layoutMarginsGuide.rightAnchor),
            
            searchButton.widthAnchor.constraint(equalToConstant: 24),
            searchButton.heightAnchor.constraint(equalTo: searchIcon.widthAnchor),
        ])
    }
    
    
    private func setLayout() {
        
        [
            navigationBar,
            searchArea,
            summariesTableView,
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            navigationBar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            
            searchArea.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 30),
            searchArea.leftAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leftAnchor,
                constant: 10
            ),
            searchArea.rightAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.rightAnchor,
                constant: -10
            ),
            searchArea.heightAnchor.constraint(equalToConstant: 52),
            
            summariesTableView.topAnchor.constraint(equalTo: searchArea.bottomAnchor, constant: 30),
            summariesTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            summariesTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            summariesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setObservable() {
        
        searchButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                
                vc.searchField.resignFirstResponder()
            })
            .disposed(by: disposeBag)
    }
    
    private func setTableView() {
        // MARK: DataSource
        tableViewDataSource = .init(tableView: summariesTableView, cellProvider: { [weak self] tableView, indexPath, itemIdentifier in
            
            guard let self else { return Cell() }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier) as! Cell
            
            if let detail = viewModel?.getItem(index: indexPath.item) {
                
                cell.bind(
                    titleText: detail.title,
                    categoryText: detail.mainCategory.korWordText
                )
            }
            
            return cell
        })
        summariesTableView.dataSource = tableViewDataSource
        summariesTableView.delegate = self
        summariesTableView.register(Cell.self, forCellReuseIdentifier: Cell.identifier)
        summariesTableView.separatorStyle = .singleLine
        summariesTableView.delaysContentTouches = false
        summariesTableView.rowHeight = 65
    }
    
    
    func bind(viewModel: SummarySearchPageViewModelable) {
        
        self.viewModel = viewModel
        
        // Output
        viewModel
            .cellIdentifiers
            .drive(onNext: { [weak self] identifiers in
                
                guard let self else { return }
            
                var snapShot: NSDiffableDataSourceSnapshot<Int, String> = .init()
                snapShot.appendSections([0])
                snapShot.appendItems(identifiers, toSection: 0)
                
                tableViewDataSource.apply(snapShot, animatingDifferences: false)
            })
            .disposed(by: disposeBag)
        
        
        // Input
        searchField
            .rx.text
            .compactMap({ $0 })
            .bind(to: viewModel.searchingText)
            .disposed(by: disposeBag)
        
        navigationBar
            .backButton.rx.tap
            .bind(to: viewModel.exitButtonClicked)
            .disposed(by: disposeBag)
    }
}

extension SummarySearchPageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        viewModel?.clickedCellIndex.onNext(indexPath.item)
    }
}
