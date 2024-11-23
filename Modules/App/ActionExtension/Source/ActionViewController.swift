//
//  ActionViewController.swift
//  AE
//
//  Created by choijunios on 8/20/24.
//

import UIKit
import Util

import AppExtensionFeatures

class ActionViewController: SummaryRequestVC {
    
    required init?(coder: NSCoder) {
        
        DependencyInjector.shared.assemble([
            
            AppExtensionAssembly()
        ])
        
        super.init(coder: coder)
    }
}
