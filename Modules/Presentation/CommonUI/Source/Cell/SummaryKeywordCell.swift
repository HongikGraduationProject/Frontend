//
//  SummaryKeywordCell.swift
//  CommonUI
//
//  Created by choijunios on 8/22/24.
//

import UIKit
import Entity
import RxSwift
import RxCocoa
import DSKit

// MARK: Cell
public class SummaryKeywordCell: UICollectionViewCell {
    
    public static let identifier = String(describing: SummaryKeywordCell.self)
    
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
