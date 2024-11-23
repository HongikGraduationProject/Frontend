//
//  CAPTabBarItemView.swift
//  CommonUI
//
//  Created by choijunios on 8/15/24.
//

import UIKit
import RxSwift
import RxCocoa
import DSKit

/// 메인 화면의 탭바 아이템으로 사용됩니다.
public class CAPTabBarItemView: TappableUIView {
    
    // Init
    public let index: Int
    public let idleImage: UIImage
    public let accentImage: UIImage
    
    // State components
    public enum State {
        case idle
        case accent
    }
    
    public struct ImageForState {
        let idleImage: UIImage
        let accentImage: UIImage
        public init(idleImage: UIImage, accentImage: UIImage) {
            self.idleImage = idleImage
            self.accentImage = accentImage
        }
    }
    
    // idle
    let idleTextTStyle: TypographyStyle = .smallRegular
    let idleTextColor: UIColor = DSColors.gray40.color
    let idleBackgroundColor: UIColor = .clear
    
    
    // accent
    let accentTextTStyle: TypographyStyle = .smallBold
    let accentTextColor: UIColor = DSColors.primary90.color
    let accentBackgroundColor: UIColor = DSColors.gray5.color
    
    // View
    let label: CapLabel = {
        let label = CapLabel()
        label.typographyStyle = .smallRegular
        return label
    }()
    let image: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    public init(index: Int, labelText: String, imageSet: ImageForState) {
        self.index = index
        self.label.text = labelText
        self.idleImage = imageSet.idleImage
        self.accentImage = imageSet.accentImage
        
        super.init()
        
        setAppearance()
        setLayout()
        
        // 초기상태
        setToIdle()
    }
    public required init?(coder: NSCoder) { nil }
    
    private func setAppearance() {
        self.layer.cornerRadius = 35
        self.clipsToBounds = true
    }
    
    private func setLayout() {
        let mainStack = VStack([image, label], spacing: 4, alignment: .center)
        
        self.addSubview(mainStack)
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(equalToConstant: 24),
            image.heightAnchor.constraint(equalTo: image.widthAnchor),
            
            mainStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            mainStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            mainStack.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    /// 탭바 아이템의 상태를 변경합니다.
    public func setState(_ state: State, duration: CGFloat = 0.2) {
        UIView.animate(withDuration: duration) { [weak self] in
            if state == .accent {
                self?.setToAccent()
            } else {
                self?.setToIdle()
            }
        }
    }
    
    private func setToIdle() {
        label.attrTextColor = idleTextColor
        label.typographyStyle = idleTextTStyle
        image.image = idleImage
        self.backgroundColor = idleBackgroundColor
    }
    
    private func setToAccent() {
        label.attrTextColor = accentTextColor
        label.typographyStyle = accentTextTStyle
        image.image = accentImage
        self.backgroundColor = accentBackgroundColor
    }
}
