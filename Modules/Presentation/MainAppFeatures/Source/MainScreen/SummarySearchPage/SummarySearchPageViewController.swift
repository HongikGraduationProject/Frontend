//
//  SummarySearchPageViewController.swift
//  Shortcap
//
//  Created by choijunios on 11/24/24.
//

import UIKit

import DSKit
import PresentationUtil

class SummarySearchPageViewController: BaseVC {
    
    private let searchField: UITextField = .init()
    private let searchArea: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = DSColors.gray5.color
        return view
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        setTextField()
        setSearchUI()
    }
    required init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
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
        
        let searchStack: HStack = .init([
            searchField,
            searchIcon
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
            
            searchStack.topAnchor.constraint(equalTo: searchArea.layoutMarginsGuide.topAnchor),
            searchStack.bottomAnchor.constraint(equalTo: searchArea.layoutMarginsGuide.bottomAnchor),
            searchStack.leftAnchor.constraint(equalTo: searchArea.layoutMarginsGuide.leftAnchor),
            searchStack.rightAnchor.constraint(equalTo: searchArea.layoutMarginsGuide.rightAnchor),
        ])
    }
    
    
    private func setLayout() {
        
        [
            searchArea
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            
            searchArea.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            searchArea.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            searchArea.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            
        ])
    }
}

#Preview("", traits: .defaultLayout, body: {

    SummarySearchPageViewController()
})
