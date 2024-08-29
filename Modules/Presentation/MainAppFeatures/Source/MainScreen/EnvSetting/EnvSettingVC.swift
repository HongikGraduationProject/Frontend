//
//  EnvSettingVC.swift
//  MainAppFeatures
//
//  Created by choijunios on 8/18/24.
//

import UIKit
import CommonFeature
import RxCocoa
import RxSwift
import Entity
import DSKit
import PresentationUtil

public class EnvSettingVC: BaseVC {
    
    // Init
    
    // View
    
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
    
    private func setAppearance() {
        view.backgroundColor = .brown
    }
    
    private func setLayout() {
        
    }
    
    private func setObservable() {
        
    }
}

