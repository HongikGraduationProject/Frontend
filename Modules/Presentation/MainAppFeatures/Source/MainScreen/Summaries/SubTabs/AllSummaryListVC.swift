//
//  AllSummaryListVC.swift
//  MainAppFeatures
//
//  Created by choijunios on 8/22/24.
//

import UIKit
import BaseFeature
import RxCocoa
import RxSwift
import Entity
import DSKit

public class AllSummaryListVC: BaseVC {
    typealias Cell = SummaryCell
    
    // Init
    
    // Not init
    var viewModel: AllSummaryListVMable?
    
    // View
    let tableView: UITableView = {
        let view = UITableView()
        view.rowHeight = UITableView.automaticDimension
        view.register(Cell.self, forCellReuseIdentifier: Cell.identifier)
        return view
    }()
    
    // Observable
    private let summaryItems: BehaviorRelay<[SummaryItem]> = .init(value: [])
    private let disposeBag = DisposeBag()
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) { fatalError() }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setAppearance()
        setLayout()
        setObservable()
    }
    
    public func bind(viewModel: AllSummaryListVMable) {
        self.viewModel = viewModel
        
        // Output
        viewModel
            .summaryItems?
            .asObservable()
            .bind(to: self.summaryItems)
            .disposed(by: disposeBag)
    }
    
    private func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.delaysContentTouches = false
    }
    
    private func setAppearance() {
        
    }
    
    private func setLayout() {
        
    }
    
    private func setObservable() {
        
    }
}

extension AllSummaryListVC: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        summaryItems.value.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier) as! Cell
        cell.selectionStyle = .none
        
        
        
        return cell
    }
}
