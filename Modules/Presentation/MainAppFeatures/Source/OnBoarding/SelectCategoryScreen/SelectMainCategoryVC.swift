//
//  SelectMainCategoryVC.swift
//  MainAppFeatures
//
//  Created by choijunios on 8/7/24.
//

import UIKit
import RxCocoa
import RxSwift
import Entity
import DSKit

public class SelectMainCategoryVC: UIViewController {
    
    typealias Cell = CategorySelectionCell
    
    // Init
    let viewModel: SelectMainCategoryVM
    
    // View
    let titleLabel: CapLabel = {
        let label = CapLabel()
        label.typographyStyle = .extraLargeBold
        label.attrTextColor = .black
        label.text = "숏폼의 카테고리를 선택하세요."
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 32, left: 20, bottom: 30, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .clear
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.delaysContentTouches = false
        
        collectionView.register(Cell.self, forCellWithReuseIdentifier: Cell.identifier)
        
        return collectionView
    }()
    
    let nextButton: CapBottomButton = .init(labelText: "저장하기")
    
    // Observable
    private let disposeBag = DisposeBag()
    
    public init(viewModel: SelectMainCategoryVM) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) { fatalError() }

    public override func viewDidLoad() {
        setAppearance()
        setLayout()
        setObservable()
    }
    
    private func setAppearance() {
        view.backgroundColor = DSKitAsset.Colors.gray1.color
    }
    
    private func setLayout() {
        [
            titleLabel,
            collectionView,
            nextButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 57),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: nextButton.topAnchor),
            
            nextButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
        ])
    }
    
    private func setObservable() {
        
    }
}

extension SelectMainCategoryVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: UICollectionViewDataSource
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        MainCategory.allCasesExceptAll.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath) as! Cell
        
        cell.bind(
            category: MainCategory(rawValue: indexPath.item)!,
            viewModel: viewModel
        )
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // MARK: FlowLayout
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 13
        let cellHeight: CGFloat = 100
        var cellWidth = collectionView.bounds.size.width - spacing
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            let horizontalInset = layout.sectionInset.left+layout.sectionInset.right
            cellWidth -= horizontalInset
        }
        
        let itemSize = CGSize(width: cellWidth / 2, height: cellHeight)
        return itemSize
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        13
    }
    
}

@available(iOS 17.0, *)
#Preview("Preview", traits: .defaultLayout) {
    SelectMainCategoryVC(viewModel: SelectMainCategoryVM())
}
