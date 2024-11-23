//
//  SearchButton.swift
//  Shortcap
//
//  Created by choijunios on 11/24/24.
//

import UIKit

import DSKit

import RxSwift

class SearchButton: TappableUIView {
    
    private let searchFieldText: CapLabel = {
        let label = CapLabel()
        label.typographyStyle = .smallRegular
        label.attrTextColor = DSColors.gray40.color
        label.text = "저장했던 숏폼을 키워드로 검색해보세요!"
        return label
    }()
    
    private let disposeBag = DisposeBag()
    
    override init() {
        super.init()
        
        setAppearance()
        setLayout()
        setObservable()
    }
    required init?(coder: NSCoder) { nil }
    
    private func setAppearance() {
        
        self.layer.cornerRadius = 8
        self.backgroundColor = DSColors.gray5.color
    }
    
    private func setLayout() {
        
        let searchIcon = UIImageView(image: DSKitAsset.Images.search.image)
        
        let searchStack: HStack = .init([
            searchFieldText,
            searchIcon
        ], spacing: 10, alignment: .center, distribution: .fill)
        
        self.addSubview(searchStack)
        searchStack.translatesAutoresizingMaskIntoConstraints = false
        
        self.layoutMargins = .init(
            top: 14,
            left: 18,
            bottom: 14,
            right: 18
        )
        
        NSLayoutConstraint.activate([
            
            searchStack.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            searchStack.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor),
            searchStack.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor),
            searchStack.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor),
        ])
    }
    
    private func setObservable() {
        
        rx.tap
            .subscribe(onNext: { [weak self] in
                
                guard let self else { return }
                
                self.alpha = 0.5
                UIView.animate(withDuration: 0.2) {
                    self.alpha = 1
                }
            })
            .disposed(by: disposeBag)
    }
}
