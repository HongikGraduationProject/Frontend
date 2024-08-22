//
//  SummaryDetailVC.swift
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

public class SummaryDetailVC: BaseVC {
    
    // Init
    
    // View
    let navigationBar: CAPSummaryDetailNavigationBar = {
        let bar = CAPSummaryDetailNavigationBar(titleText: "")
        return bar
    }()
    
    let originalVideoWebView: UIView = {
        let view = UIView()
        view.backgroundColor = DSColors.gray10.color
        return view
    }()
    
    
    // Observable
    private let disposeBag = DisposeBag()
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) { fatalError() }
    
    private func setAppearance() {
        
    }
    
    private func setLayout() {
        
    }
    
    private func setObservable() {
        
    }
}

