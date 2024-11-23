//
//  SummaryDetailVC.swift
//  MainAppFeatures
//
//  Created by choijunios on 8/22/24.
//

import UIKit

import Entity
import DSKit
import UseCase
import CommonUI
import PresentationUtil

import Kingfisher
import RxCocoa
import RxSwift

public class SummaryDetailViewController: BaseVC {
    
    // Init
    
    // Not init
    private var viewModel: SummaryDetailViewModel?
    
    // View
    let navigationBar: CAPSummaryDetailNavigationBar = {
        let bar = CAPSummaryDetailNavigationBar(titleText: "상세보기")
        return bar
    }()
    
    let titleLabel: CapLabel = {
        let label = CapLabel()
        label.typographyStyle = .extraLargeMedium
        return label
    }()
    
    let videoThumbNailView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = DSColors.gray10.color
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let playButton: PlayButton = {
        let button = PlayButton()
        button.isUserInteractionEnabled = true
        return button
    }()
    
    // MARK: 키워드
    let keywordLabel: CapLabel = {
        let label = CapLabel()
        label.typographyStyle = .extraLargeMedium
        label.text = "키워드 분석"
        return label
    }()
    let keywordCollectionView: SummaryKeywordCollectionView = {
        let view = SummaryKeywordCollectionView()
        return view
    }()
    
    // MARK: 스크립트
    let scriptLabel: CapLabel = {
        let label = CapLabel()
        label.typographyStyle = .extraLargeMedium
        label.text = "스크립트 자동 요약"
        return label
    }()
    let scriptContentLabel: CapLabel = {
        let label = CapLabel()
        label.typographyStyle = .baseRegular
        label.attrTextColor = DSColors.gray50.color
        label.numberOfLines = 0
        return label
    }()
    
    
    // MARK: 맵뷰
    let mapView: SummaryMapView = .init()
    
    
    // Observable
    private let disposeBag = DisposeBag()
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) { fatalError() }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setAppearance()
        setLayout()
        setObservable()
    }
    
    private func setAppearance() {
        view.backgroundColor = DSColors.gray0.color
    }
    
    private func setLayout() {
        
        videoThumbNailView.addSubview(playButton)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        
        let viewList = [
            Spacer(height: 20),
            titleLabel,
            Spacer(height: 22),
            videoThumbNailView,
            Spacer(height: 35),
            HStack([keywordLabel, Spacer()], alignment: .fill),
            Spacer(height: 16),
            keywordCollectionView,
            Spacer(height: 23),
            Spacer(height: 1, color: .gray),
            Spacer(height: 28),
            HStack([scriptLabel, Spacer()], alignment: .fill),
            Spacer(height: 28),
            scriptContentLabel,
            Spacer(height: 23),
            Spacer(height: 1, color: .gray),
            Spacer(height: 28),
        ]
        let contentView = VStack(viewList, alignment: .fill)
        
        let scrollView = UIScrollView()
        scrollView.contentInset.left = 20
        scrollView.contentInset.right = 20
        scrollView.delaysContentTouches = false
        let contentGuide = scrollView.contentLayoutGuide
        let frameGuide = scrollView.frameLayoutGuide
        scrollView.addSubview(contentView)
        scrollView.addSubview(mapView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            videoThumbNailView.heightAnchor.constraint(equalToConstant: 210),
            
            playButton.centerXAnchor.constraint(equalTo: videoThumbNailView.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: videoThumbNailView.centerYAnchor),
            
            keywordCollectionView.heightAnchor.constraint(equalToConstant: 66),
            
            contentView.topAnchor.constraint(equalTo: contentGuide.topAnchor),
            contentView.leftAnchor.constraint(equalTo: contentGuide.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: contentGuide.rightAnchor),
            
            mapView.leftAnchor.constraint(equalTo: frameGuide.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: frameGuide.rightAnchor),
            mapView.topAnchor.constraint(equalTo: contentView.bottomAnchor),
            mapView.bottomAnchor.constraint(equalTo: contentGuide.bottomAnchor, constant: -350),
            
            contentView.widthAnchor.constraint(equalTo: frameGuide.widthAnchor, constant: -40),
        ])
        
        
        [
            navigationBar,
            scrollView,
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            navigationBar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            
            scrollView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setObservable() {
        
        // 임시 설정
        navigationBar.backButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    public func bind(viewModel: SummaryDetailViewModel) {
        
        self.viewModel = viewModel
        
        // MARK: Output
        viewModel
            .summaryDetail?
            .drive(
                onNext: { [weak self] detail in
                    
                    guard let self else { return }
                    
                    // 썸네일
                    if let rawCode = detail.rawVideoCode,
                       let thumbNailUrl = URL(string: "https://img.youtube.com/vi/\(rawCode)/maxresdefault.jpg") {
                        
                        let processor = DownsamplingImageProcessor(size: videoThumbNailView.bounds.size)
                        
                        videoThumbNailView.kf.setImage(
                            with: thumbNailUrl,
                            options: [
                                .processor(processor),
                                .scaleFactor(UIScreen.main.scale),
                                .transition(.fade(0.25)),
                                .cacheOriginalImage
                            ])
                    }
                    
                    titleLabel.text = detail.title
                    keywordCollectionView.setKeywords(keywords: detail.keywords)
                    scriptContentLabel.text = detail.summary
                    
                    
                    // 맵뷰
                    if let lat = detail.latitude, let lon = detail.longitude {
                        
                        mapView
                            .setMap(
                                name: detail.description,
                                address: detail.address,
                                lat: lat,
                                lon: lon
                            )
                        
                    } else {
                        
                        mapView.isHidden = true
                    }
            })
            .disposed(by: disposeBag)
        
        
        // MARK: Input
        rx.viewDidLoad
            .bind(to: viewModel.viewDidLoad)
            .disposed(by: disposeBag)
        
        playButton.tap
            .bind(to: viewModel.playSourceVideoButtonClicked)
            .disposed(by: disposeBag)
    }
}
