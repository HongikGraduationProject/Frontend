//
//  UserConfigRepository.swift
//  UseCase
//
//  Created by choijunios on 8/8/24.
//

import Foundation
import Entity

public protocol UserConfigRepository {
    
    /// 선택된 메인 카테고리들을 가져옵니다.
    func getSelectedMainCategories() -> [MainCategory]?
    
    /// 선택된 메인 카테고리들을 저장합니다.
    func saveSelectedMainCategories(categories: [MainCategory])
}
