//
//  VideoCodeRepository.swift
//  UseCase
//
//  Created by choijunios on 8/18/24.
//

import Foundation
import Entity
import RxSwift

public protocol VideoCodeRepository {
    
    /// 로컬에 저장된 모든 비디오코드를 가져옵니다.
    func getVideoCodes() -> [String]
    
    /// 비디오 코드를 로컬에 저장합니다.
    func saveVideoCode(_ videoCode: String) -> Single<Void>
    
    /// 비디오 코드를 제거합니다.
    func removeVideoCode(_ videoCode: String) -> Single<Void>
}
