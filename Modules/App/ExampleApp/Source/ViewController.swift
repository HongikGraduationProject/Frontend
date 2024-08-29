//
//  ViewController.swift
//  App
//
//  Created by choijunios on 8/03/24.
//

import UIKit
import DSKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        
        let label = SummaryKeywordCollectionView()
        label.setKeywords(keywords: ["안녕하세요","안녕하세요","안녕하세요","123","안녕하세요","안녕하세요","안녕하세요","123",])
        
        view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: view.leftAnchor),
            label.rightAnchor.constraint(equalTo: view.rightAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.heightAnchor.constraint(equalToConstant: 300),
        ])
    }
}

