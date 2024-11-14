//
//  SummaryCell.swift
//  Shortcap
//
//  Created by choijunios on 11/14/24.
//

import UIKit

import Entity
import DSKit
import CommonUI

import RxSwift
import RxCocoa
import Kingfisher

class SummaryCell: UITableViewCell {
    
    static let identifier = String(describing: SummaryCell.self)
    
    // View
    let cellContentView = SummaryCellContentView()
    
    let loadingIndicatorView: CAPLoadingIndicatorView = .init()
    
    // Observable
    var viewModel: SummaryCellVMable?
    var disposables: [Disposable] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setAppearance()
        setLayout()
        setObservable()
    }
    required init?(coder: NSCoder) { return nil }
    
    override func prepareForReuse() {
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
    
    override func layoutSubviews() {
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
    
    func bind(viewModel: SummaryCellVMable) {
        
        self.viewModel = viewModel
        
        // Output
        let disposables: [Disposable?] = [
            
            // Output
            viewModel
                .summaryDetail?
                .drive(onNext: { [weak self] detail in
                    
                    guard let self else { return }
                    
                    // 셀 썸네일
                    
                    if let rawCode = detail.rawVideoCode, let thumbNailUrl = URL(string: "https://img.youtube.com/vi/\(rawCode)/mqdefault.jpg") {
                        
                        let thumbNailView = cellContentView.videoImageView
                        
                        let processor = DownsamplingImageProcessor(size: thumbNailView.bounds.size)
                        
                        thumbNailView.kf.setImage(
                            with: thumbNailUrl,
                            options: [
                                    .processor(processor),
                                    .scaleFactor(UIScreen.main.scale),
                                    .transition(.fade(0.25)),
                                    .cacheOriginalImage
                            ])
                        
                        cellContentView.videoImageView.kf.setImage(with: thumbNailUrl)
                    }
                    
                    
                    // 메인 타이틀 정보
                    cellContentView.titleLabel.text = detail.title
                    
                    // 카테고리 정보
                    let categoryText = detail.mainCategory.twoLetterKorWordText
                    let fullCategoryText = "\(categoryText) 카테고리에 숏폼을 저장했어요!"
                    let catRange = NSRange(fullCategoryText.range(of: categoryText)!, in: fullCategoryText)
                    cellContentView.categoryLabel.text = fullCategoryText
                    let font = TypographyStyle.smallBold.typography.font
                    
                    cellContentView.categoryLabel.applyAttribute(
                        attributes: [
                            .foregroundColor : DSColors.secondary90.color,
                            .font : font
                        ],
                        range: catRange
                    )
                    
                    // 로딩 스크린 종료, 셀이 클릭가능함
                    loadingIndicatorView.turnOff()
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
    
    override var intrinsicContentSize: CGSize {
        .init(width: super.intrinsicContentSize.width, height: 160)
    }
    
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
        videoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            videoImageView.widthAnchor.constraint(equalToConstant: 120),
            
            mainStack.topAnchor.constraint(equalTo: self.topAnchor),
            mainStack.leftAnchor.constraint(equalTo: self.leftAnchor),
            mainStack.rightAnchor.constraint(equalTo: self.rightAnchor),
            mainStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    func prepareForeReuse() {
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
