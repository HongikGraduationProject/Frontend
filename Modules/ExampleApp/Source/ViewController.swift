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
        
        let label = CapLabel()
        
        label.text = "안녕하세요 반갑습니다~!"
        label.typographyStyle = .largeRegular
        label.attrTextColor = .blue
        
        view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

