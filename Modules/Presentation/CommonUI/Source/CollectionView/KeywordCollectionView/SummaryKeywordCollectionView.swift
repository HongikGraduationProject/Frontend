//
//  SummaryKeywordCollectionView.swift
//  CommonUI
//
//  Created by choijunios on 8/29/24.
//

import UIKit
import DSKit
import PresentationUtil

// MARK: CollectionView
public class SummaryKeywordCollectionView: UIView {
    typealias Cell = SummaryKeywordCell
    
    let flowLayout: LeftAlignedFlowLayout = {
        let layout = LeftAlignedFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 6
        layout.minimumInteritemSpacing = 6
        return layout
    }()
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.register(Cell.self, forCellWithReuseIdentifier: Cell.identifier)
        view.dataSource = self
        view.delegate = self
        view.isScrollEnabled = false
        return view
    }()
    
    var keywords: [String] = []
    
    public init() {
        super.init(frame: .zero)
        setLayout()
    }
    public required init?(coder: NSCoder) { return nil }
    
    func setLayout() {
        [
            collectionView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: self.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    public func setKeywords(keywords: [String]) {
        self.keywords = keywords
        collectionView.reloadData()
    }
}

extension SummaryKeywordCollectionView: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keywords.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath) as! Cell
        cell.bind(keywordText: keywords[indexPath.item])
        return cell
    }
}

extension SummaryKeywordCollectionView: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let label = CapLabel()
        label.typographyStyle = .baseRegular
        label.textAlignment = .center
        label.text = "#\(keywords[indexPath.item])"
        
        return .init(
            width: label.intrinsicContentSize.width + 26,
            height: label.intrinsicContentSize.height + 10
        )
    }
}
