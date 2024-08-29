//
//  SummaryKeywordCell.swift
//  DSKit
//
//  Created by choijunios on 8/22/24.
//

import UIKit
import Entity
import RxSwift
import RxCocoa

// MARK: CollectionView
public class SummaryKeywordCollectionView: UIView {
    typealias Cell = SummaryKeywordCell
    
    let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
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
        
        print(label.intrinsicContentSize)
        
        return .init(
            width: label.intrinsicContentSize.width + 26,
            height: label.intrinsicContentSize.height + 10
        )
    }
}

// MARK: Cell
public class SummaryKeywordCell: UICollectionViewCell {
    
    static let identifier = String(describing: SummaryKeywordCell.self)
    
    // View
    public let label: CapLabel = {
        let label = CapLabel()
        label.typographyStyle = .baseRegular
        label.attrTextColor = DSColors.primary60.color
        label.textAlignment = .center
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAppearance()
        setLayout()
    }
    public required init?(coder: NSCoder) { return nil }
    
    public func bind(keywordText: String) {
        let labelText = "#\(keywordText)"
        label.text = labelText
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = contentView.bounds.height/2
    }
    
    private func setAppearance() {
        self.backgroundColor = DSColors.sub19.color
    }
    
    private func setLayout() {
        contentView.layoutMargins = .init(top: 5, left: 13, bottom: 5, right: 13)
        
        [
            label
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            label.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor),
            label.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
        ])
    }
}
