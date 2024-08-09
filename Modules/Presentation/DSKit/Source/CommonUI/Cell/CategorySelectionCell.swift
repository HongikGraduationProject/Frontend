//
//  CategorySelectionCell.swift
//  DSKit
//
//  Created by choijunios on 8/6/24.
//

import UIKit
import Entity
import RxSwift
import RxCocoa

/// 카테고리의 선택상태를 나타내는 타입입니다.
public typealias CategoryState = (category: MainCategory, isActive: Bool)

/// 카테고리 선택셀에 사용할 수 있는 ViewModel프로토콜 입니다.
public protocol CategorySelectionCellViewModelable {
    var previousSelectedStates: [MainCategory: Driver<Bool>] { get }
    var categorySelectionState: PublishRelay<CategoryState> { get }
}

/// 설명: 이미지와 라벨이 중앙에 배치되는 셀로 클릭할 수 있습니다.
/// IntrinsicContentSize정보, 넓이는 50이상이여야 합니다
///     - width: 100
///     - height: flexible
public class CategorySelectionCell: UICollectionViewCell {
    
    /// 셀인식표입니다.
    public static let identifier: String = .init(describing: CategorySelectionCell.self)
    
    // View
    let innerView = CategorySelectionView()
    
    private var disposables: [Disposable] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAppearance()
        setLayout()
    }
    public required init?(coder: NSCoder) { fatalError() }
    
    public override func prepareForReuse() {
        disposables.forEach { dis in
            dis.dispose()
        }
        disposables.removeAll()
    }
    
    private func setAppearance() { }
    
    private func setLayout() {
        [
            innerView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            innerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            innerView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            innerView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            innerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    public func bind(category: MainCategory ,viewModel: CategorySelectionCellViewModelable) {
        
        // 기본세팅
        innerView.setCategoryView(category)
        
        let input: Disposable? = innerView.stateEmitter
            .bind(to: viewModel.categorySelectionState)
        
        let output: Disposable? = viewModel
            .previousSelectedStates[category]?
            .drive(onNext: { [weak innerView] prevState in
                innerView?.setState(prevState ? .clicked : .idle)
            })
        
        [input, output].forEach {
            if let dis = $0 { disposables.append(dis) }
        }
    }
}

public class CategorySelectionView: TappableUIView {
    public enum State {
        case idle, clicked
        func toggle() -> State {
            self == .idle ? .clicked : .idle
        }
    }
    
    public var category: MainCategory?
    private var state: State?
    
    public lazy var stateEmitter: Observable<CategoryState> = {
        self.rx.tap
            .compactMap { [weak self] _ -> CategoryState? in
                guard let self, let category = category, let state = state else { return nil }
                
                // 상태변경
                setState(state.toggle())
                
                return (category, self.state == .clicked)
            }
    }()
    
    // View
    let image: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    let label: CapLabel = {
        let label = CapLabel()
        label.attrTextColor = .black
        label.typographyStyle = .baseRegular
        return label
    }()
    
    public override var intrinsicContentSize: CGSize {
        .init(
            width: super.intrinsicContentSize.width,
            height: 100
        )
    }
    
    public override init() {
        super.init()
        
        setAppearance()
        setLayout()
        
        // 초기설정
        setState(.idle)
    }
    public required init?(coder: NSCoder) { fatalError() }
    
    private func setAppearance() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        self.layer.borderColor = UIColor.blue.cgColor
    }
    
    private func setLayout() {
        let labelImageStack = VStack([image, label], spacing: 6)
        
        [
            labelImageStack
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(equalToConstant: 30),
            image.heightAnchor.constraint(equalTo: image.widthAnchor),
            
            labelImageStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 21.5),
            labelImageStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
    
    public func setState(_ state: State) {
        
        self.state = state
        
        if state == .clicked {
            
            UIView.animate(withDuration: 0.25) { [weak self] in
                guard let self else { return }
                
                backgroundColor = DSKitAsset.Colors.sub19.color
                layer.borderWidth = 1.5
                layer.borderColor = DSKitAsset.Colors.primary80.color.cgColor
            }
            
        } else {
            
            UIView.animate(withDuration: 0.25) { [weak self] in
                guard let self else { return }
                
                backgroundColor = DSKitAsset.Colors.gray0.color
                layer.borderWidth = 0.0
            }
        }
    }
    
    public func setCategoryView(_ category: MainCategory) {
        self.category = category
        label.text = category.korWordText
        image.image = category.image
    }
}

// MARK: 카테고리 이미지를 반환
extension MainCategory {
    
    var image: UIImage {
        switch self {
        case .technology:
            DSKitAsset.Images.categoryGear.image
        case .beauty:
            DSKitAsset.Images.categoryLipstick.image
        case .cook:
            DSKitAsset.Images.categoryFork.image
        case .living:
            DSKitAsset.Images.categoryHouse.image
        case .health:
            DSKitAsset.Images.categoryHealth.image
        case .travel:
            DSKitAsset.Images.categoryLuggage.image
        case .art:
            DSKitAsset.Images.categoryBrush.image
        case .news:
            DSKitAsset.Images.categoryEarth.image
        case .entertainment:
            DSKitAsset.Images.categoryEntertain.image
        case .other:
            DSKitAsset.Images.categoryEtc.image
        case .all:
            fatalError("잘못된 접근입니다.")
        }
    }
}

extension UIView {
    func deleteInnerBorder() {
        self.layer.sublayers?.filter { $0.name == "innerBorder" }.forEach { $0.removeFromSuperlayer() }
    }
    
    func addInnerBorder(borderColor: UIColor, borderWidth: CGFloat) {
        // 이전에 추가된 내부 경계 제거
        self.layer.sublayers?.filter { $0.name == "innerBorder" }.forEach { $0.removeFromSuperlayer() }

        let borderLayer = CAShapeLayer()
        borderLayer.name = "innerBorder"
        borderLayer.frame = self.bounds

        let insetRect = self.bounds.insetBy(dx: borderWidth / 2, dy: borderWidth / 2)
        borderLayer.cornerRadius = layer.cornerRadius
        borderLayer.path = UIBezierPath(rect: insetRect).cgPath
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = borderWidth

        self.layer.addSublayer(borderLayer)
    }
}
