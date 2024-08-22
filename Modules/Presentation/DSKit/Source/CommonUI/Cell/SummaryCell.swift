//
//  SummaryCell.swift
//  DSKit
//
//  Created by choijunios on 8/22/24.
//

import UIKit
import Entity
import RxSwift
import RxCocoa

/// 요약된 비디오를 나타내는 Cell입니다.

public protocol SummaryCellVMable {
    
    /// 비디오 아이디
    var videoId: Int { get }
    
    /// 상세정보를 요청합니다.
    func requestDetail()
    
    /// Input: 셀이 클릭됨
    var cellClicked: PublishRelay<Void> { get }
    
    /// Ouptut: 요약 상세정보를 가져옵니다.
    var summaryDetail: Driver<SummaryDetail>? { get }
}

public class SummaryCell: UITableViewCell {
    
    public static let identifier = String(describing: SummaryCell.self)
    
    // View
    let cellContentView = SummaryCellContentView()
    
    let loadingIndicatorView: CAPLoadingIndicatorView = .init()
    
    // Observable
    var viewModel: SummaryCellVMable?
    var disposables: [Disposable] = []
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setAppearance()
        setLayout()
        setObservable()
    }
    public required init?(coder: NSCoder) { return nil }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        viewModel = nil
        disposables.forEach { disposable in
            disposable.dispose()
        }
        disposables.removeAll()
        
        // UI관련
        cellContentView.prepareForeReuse()
        loadingIndicatorView.turnOn(withAnimation: false)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: .init(top: 0, left: 20, bottom: 14, right: 20))
    }
    
    private func setAppearance() { }
    
    private func setLayout() {
        
        // MARK: contentView
        [
            cellContentView,
            loadingIndicatorView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            cellContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellContentView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            cellContentView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            cellContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            loadingIndicatorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            loadingIndicatorView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            loadingIndicatorView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            loadingIndicatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    private func setObservable() {
        // 내부 옵저버블
    }
    
    public func bind(viewModel: SummaryCellVMable) {
        
        self.viewModel = viewModel
        
        // Output
        let disposables: [Disposable?] = [
            
            // Output
            viewModel
                .summaryDetail?
                .drive(onNext: {
                    [weak self] detail in
                    guard let self else { return }
                    
                    // 메인 타이틀 정보
                    self.cellContentView.titleLabel.text = detail.title
                    
                    // 카테고리 정보
                    let categoryText = detail.mainCategory.twoLetterKorWordText
                    let fullCategoryText = "\(categoryText) 카테고리에 숏폼을 저장했어요!"
                    let catRange = NSRange(fullCategoryText.range(of: categoryText)!, in: fullCategoryText)
                    self.cellContentView.categoryLabel.text = fullCategoryText
                    let font = TypographyStyle.smallBold.typography.font
                    
                    self.cellContentView.categoryLabel.applyAttribute(
                        attributes: [
                            .foregroundColor : DSColors.secondary90.color,
                            .font : font
                        ],
                        range: catRange
                    )
                    
                    // 로딩 스크린 종료, 셀이 클릭가능함
                    self.loadingIndicatorView.turnOff()
                }),
            
            // Input
            self.cellContentView
                .rx.tap
                .bind(to: viewModel.cellClicked)
        ]
        
        self.disposables = disposables.compactMap { $0 }
        
        // MARK: 디테일 정보 요청
        viewModel.requestDetail()
    }
}

class SummaryCellContentView: TappableUIView {
    // View
    let videoImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.backgroundColor = DSColors.gray30.color
        return view
    }()
    
    let titleLabel: CapLabel = {
        let label = CapLabel()
        label.typographyStyle = .extraLargeBold
        label.attrTextColor = DSColors.primary80.color
        label.textAlignment = .left
        return label
    }()
    
    let categoryLabel: CapLabel = {
        let label = CapLabel()
        label.typographyStyle = .smallRegular
        label.attrTextColor = DSColors.gray50.color
        label.textAlignment = .left
        return label
    }()
    
    override init() {
        super.init()
        
        setAppearance()
        setLayout()
    }
    required init?(coder: NSCoder) { return nil }
    
    private func setAppearance() {
        self.backgroundColor = DSColors.gray0.color
    }
    
    private func setLayout() {
        let labelStack = VStack(
            [
                titleLabel,
                categoryLabel
            ],
            alignment: .fill
        )
        
        let summaryCaptionStack = VStack(
            [
                labelStack,
                Spacer()
            ],
            alignment: .fill
        )
        
        let mainStack = HStack(
            [
                videoImageView,
                summaryCaptionStack,
                Spacer()
            ],
            spacing: 15,
            alignment: .fill
        )
        mainStack.isUserInteractionEnabled = false
        
        self.addSubview(mainStack)
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            videoImageView.widthAnchor.constraint(equalToConstant: 120),
            videoImageView.heightAnchor.constraint(equalToConstant: 160),
            
            mainStack.topAnchor.constraint(equalTo: self.topAnchor),
            mainStack.leftAnchor.constraint(equalTo: self.leftAnchor),
            mainStack.rightAnchor.constraint(equalTo: self.rightAnchor),
            mainStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    public func prepareForeReuse() {
        videoImageView.image = nil
        titleLabel.text = ""
        categoryLabel.text = ""
    }
}

@available(iOS 17.0, *)
#Preview("Preview", traits: .defaultLayout) {
    let cellContentView = SummaryCellContentView()
    cellContentView.titleLabel.text = "테스트 타이틀"
    cellContentView.categoryLabel.text = "테스트 카테고리"
    return cellContentView
}
