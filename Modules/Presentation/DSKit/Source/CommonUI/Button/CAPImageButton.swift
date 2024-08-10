//
//  CAPImageButton.swift
//  DSKit
//
//  Created by choijunios on 8/10/24.
//

import UIKit
import RxSwift

/// 설명: 바텀 넓은 영역을 차지하는 버튼으 버튼중간에 라벨이 표시됩니다.
///      + 버튼의 라벨앞에 이미지가 배치됩니다.
///      + 버튼의 벡그라운드 뷰를 지정할 수 있습니다.
/// IntrinsicContentSize정보
///     - width: flexible
///     - height: 50
public class CAPImageButton: TappableUIView {
    
    // init
    let backgroundView: UIView
    
    // Views
    public let imageView: UIImageView = {
        let view: UIImageView = .init()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    public let label: CapLabel = {
        let label = CapLabel()
        label.numberOfLines = 2
        label.typographyStyle = .baseSemiBold
        label.attrTextColor = .white
        return label
    }()
    
    public var idleBackgroundColor: UIColor = DSKitAsset.Colors.primary90.color
    public var idleTextColor: UIColor = .white
    
    public var accentBackgroundColor: UIColor = DSKitAsset.Colors.gray10.color
    public var accentTextColor: UIColor = DSKitAsset.Colors.gray40.color
    
    public override var intrinsicContentSize: CGSize {
        .init(
            width: super.intrinsicContentSize.width,
            height: 50
        )
    }
    
    private let disposeBag = DisposeBag()
    
    public init(
        backgroundView: UIView = .init(),
        labelText: String
    ) {
        self.backgroundView = backgroundView
        super.init()
        
        // 라벨 설정
        label.text = labelText
        
        setAppearance()
        setLayout()
        setObservable()
    }
    public required init?(coder: NSCoder) { fatalError() }
    
    private func setAppearance() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 12
        clipsToBounds = true
    }
    
    private func setLayout() {
        
        let contentStack = HStack([imageView, label], spacing: 8, alignment: .center)
        
        [
            contentStack,
            backgroundView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        contentStack.layer.zPosition = 1
        backgroundView.layer.zPosition = 0
        
        NSLayoutConstraint.activate([
            
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.leftAnchor.constraint(equalTo: self.leftAnchor),
            backgroundView.rightAnchor.constraint(equalTo: self.rightAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            contentStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            contentStack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    private func setObservable() {
        self.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                setAppearanceToAccent()
                UIView.animate(withDuration: 0.45) { [weak self] in
                    self?.setAppearanceToIdle()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setAppearanceToIdle() {
        backgroundView.alpha = 1.0
    }
    
    private func setAppearanceToAccent() {
        backgroundView.alpha = 0.5
    }
}

#Preview("CapBottomButton", traits: .defaultLayout) {
    
    let backgroundView = UIView()
    backgroundView.backgroundColor = .red
    
    let imageButton = CAPImageButton(
        backgroundView: backgroundView,
        labelText: "여기룰 눌러 시작하기"
    )
    
    imageButton.imageView.image = DSKitAsset.Images.youtubeBadge.image
    
    return imageButton
}
    
