//
//  AllSummaryListView.swift
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

public class AllSummaryListView: UIView {
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
        super.init(frame: .zero)
        
        setTableView()
        setAppearance()
        setLayout()
        setObservable()
    }
    
    public required init?(coder: NSCoder) { fatalError() }
    
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
        self.backgroundColor = DSColors.gray0.color
    }
    
    private func setLayout() {
        [
            tableView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.leftAnchor.constraint(equalTo: self.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    private func setObservable() {
        summaryItems
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension AllSummaryListView: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        summaryItems.value.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier) as! Cell
        cell.selectionStyle = .none
        
        if let viewModel {
            let summaryItem = summaryItems.value[indexPath.item]
            let vm = viewModel.createCellVM(videoId: summaryItem.videoSummaryId)
            
            cell.bind(viewModel: vm)
        }
        
        return cell
    }
}
