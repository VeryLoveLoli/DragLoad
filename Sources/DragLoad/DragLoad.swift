//
//  DragLoad.swift
//
//
//  Created by 韦烽传 on 2019/4/27.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation
import CoreGraphics

/**
 拖动加载
 */
open class DragLoad {
    
    /// 方向偏移值
    public static var offsetValue: CGFloat = 60
    /// 动画时间
    public static var animationDuration: TimeInterval = 0.25
}

/**
 拖动加载状态
 */
public extension DragLoad {
    
    // MARK: - Status
    
    /**
     拖动加载状态
     */
    enum Status {
        
        /// 常态
        case normal
        /// 拖动小于临界值
        case dragSmall
        /// 拖动大于临界值
        case dragBig
        /// 正在加载
        case loading
        /// 加载结束
        case loadEnd
    }
}

/**
 拖动加载方向值
 */
public extension DragLoad {
    
    // MARK: - Direction
    
    /**
     拖动加载方向值
     */
    enum Direction {
        
        /// 上
        case up(CGFloat)
        /// 下
        case down(CGFloat)
        /// 左
        case left(CGFloat)
        /// 右
        case right(CGFloat)
    }
}
