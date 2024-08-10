//
//  CapAlertVO.swift
//  Entity
//
//  Created by choijunios on 8/10/24.
//

import Foundation

/// Alert를 표출할 수 있는 VO입니다.
/// 해당 객체는 버튼의 title과 버튼클릭시 호출될 클로져묶음을 딕셔너리로 전달받을 수 있습니다.
public struct CapAlertVO {
    public typealias AlertActionInfo = [String: (() -> ())?]
    
    public let title: String
    public let message: String
    public let info: AlertActionInfo
    
    public init(title: String, message: String, info: AlertActionInfo = ["닫기": nil]) {
        self.title = title
        self.message = message
        self.info = info
    }
    
    public static let `default`: CapAlertVO = .init(
        title: "시스템 오류",
        message: "알 수 없는 오류가 발생했습니다."
    )
}
