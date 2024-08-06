//
//  UIImage+Extension.swift
//  DSKit
//
//  Created by choijunios on 8/6/24.
//

import UIKit

public extension UIImage {

    /// 이미지뷰를 만듭니다. 기본 컨텐츠모드: ScaleToAspectFit
    func toView() -> UIImageView {
        let view = UIImageView()
        view.image = self
        view.contentMode = .scaleAspectFit
        return view
    }
}
