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
import CommonUI
import PresentationUtil

public class SelectMainCategoryViewController: BaseVC {
    
    typealias Cell = CategorySelectionCell
    
    // Init
    private var viewModel: SelectMainCategoryViewModelable?
    
    private let mainCategories: [MainCategory] = {
        let items = MainCategory.allCases.filter { $0 != .all }
        let sorted = items.sorted { $0.pageOrderNumber < $1.pageOrderNumber }
        return sorted
    }()
    
    // View
    let titleLabel: CapLabel = {
        let label = CapLabel()
        label.typographyStyle = .extraLargeBold
        label.attrTextColor = .black
        label.text = "선호하는 카테고리를 선택해 주세요."
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
    
    public init() {
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
    
    private func setObservable() { }
    
    public func bind(viewModel: InitialSelectMainCategoryViewModel) {
        
        self.viewModel = viewModel
        
        // Input
        nextButton
            .rx.tap
            .bind(to: viewModel.nextButtonClicked)
            .disposed(by: disposeBag)
        
        // Output
        viewModel
            .nextButtonIsActive?
            .drive(onNext: { [nextButton] isActive in
                
                nextButton.setState(isActive)
            })
            .disposed(by: disposeBag)
        
        
        viewModel
            .selectedCategoryCount?
            .drive { [titleLabel] count in
                
                if count == 0 {
                    
                    // 선택된 카테고리가 없는 경우 기본 라벨로 변경
                    titleLabel.text = "선호하는 카테고리를 선택해 주세요."
                    
                    return
                }
                
                let countText = "\(count)개의 메인 카테고리"
                let wholeText = "총 \(countText)를 선택하셨네요!"
                
                titleLabel.text = wholeText
                
                if let range = wholeText.range(of: countText) {
                    // 선택개수 표시부분에 파란 라벨 적용
                    let nsRange = NSRange(range, in: wholeText)
                    
                    titleLabel.applyAttribute(
                        attributes: [
                            .foregroundColor : DSKitAsset.Colors.primary80.color
                        ],
                        range: nsRange
                    )
                }
            }
            .disposed(by: disposeBag)
        
        viewModel
            .alert?
            .drive(onNext: { [weak self] alertVO in
                self?.showAlert(alertVO: alertVO)
            })
            .disposed(by: disposeBag)
    }
}

extension SelectMainCategoryViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: UICollectionViewDataSource
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        MainCategory.allCasesExceptAll.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath) as! Cell
        
        if let viewModel {
            
            cell.bind(
                category: mainCategories[indexPath.item],
                viewModel: viewModel
            )
        }
        
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
