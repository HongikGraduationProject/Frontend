//
//  LeftAlignedFlowLayout.swift
//  BaseFeature
//
//  Created by choijunios on 8/29/24.
//

import UIKit

/// 좌측으로 정렬되는 FlowLayout입니다.
public class LeftAlignedFlowLayout: UICollectionViewFlowLayout {
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let initialAttributesObjects = super.layoutAttributesForElements(in: rect) else { return nil }
        
        var leftMargin = sectionInset.left
        var maxYForCurrentRow: CGFloat = -1
        
        for attributesObject in initialAttributesObjects {
            
            if attributesObject.representedElementCategory == .cell {
                
                if attributesObject.frame.origin.y >= maxYForCurrentRow {
                    // 현재 셀이 현재 Row경계 에서 벗어난 경우
                    leftMargin = sectionInset.left
                }
                
                attributesObject.frame.origin.x = leftMargin
                leftMargin += attributesObject.frame.width + minimumInteritemSpacing
                
                maxYForCurrentRow = max(maxYForCurrentRow, attributesObject.frame.maxY)
            }
            
        }
                
        return initialAttributesObjects
    }
}
