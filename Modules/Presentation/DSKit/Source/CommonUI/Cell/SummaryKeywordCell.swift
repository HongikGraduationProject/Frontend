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

public class SummaryKeywordCell: UICollectionViewCell {
    
    static let identifier = String(describing: SummaryKeywordCell.self)
    
    // View
    public let label: CapLabel = {
        let label = CapLabel()
        label.typographyStyle = .baseRegular
        label.attrTextColor = DSColors.primary60.color
        return label
    }()
    
    public init() {

        super.init(frame: .zero)
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
        self.layoutMargins = .init(top: 5, left: 13, bottom: 5, right: 13)
        
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
