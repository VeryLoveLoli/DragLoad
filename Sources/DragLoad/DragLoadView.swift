//
//  DragLoadView.swift
//  
//
//  Created by 韦烽传 on 2021/11/6.
//

import Foundation
import UIKit

/**
 拖动加载视图
 */
open class DragLoadView: UIView, DragLoadProtocol {
    
    /// 约束列表
    open var itemsLC: [NSLayoutConstraint] = []
    /// 末端约束
    open var endLC: NSLayoutConstraint?
    
    /// 内容大小观察
    open var sizeKVO: NSKeyValueObservation?
    /// 内容偏移观察
    open var offsetKVO: NSKeyValueObservation?
    /// 内容安全区域观察
    open var safeAreaKVO: NSKeyValueObservation?
    /// 内容边缘值
    open var edgeInsets: UIEdgeInsets = .zero
    
    /// 拖动加载状态
    open var dragLoadStatus: DragLoad.Status = .normal
    /// 拖动加载方向
    open var dragLoadDirection: DragLoad.Direction = .down(DragLoad.offsetValue)
    /// 拖动动画时间
    open var dragAnimationDuration: TimeInterval = DragLoad.animationDuration
    
    /// 是否可拖动加载
    open var isDragLoad = true {
        
        didSet {
            
            if isDragLoad {
                
                isHidden = false
                
                if let scrollView = superview as? UIScrollView {
                    
                    kvo(scrollView)
                }
            }
            else {
                
                sizeKVO = nil
                offsetKVO = nil
                
                isHidden = true
            }
        }
    }
    
    /// 拖动加载回调
    open var dragLoadCallback: (()->Void)? = nil
    
    
    /**
     初始化
     
     - parameter    dragLoadDirection:  拖动方向
     */
    public convenience init(_ dragLoadDirection: DragLoad.Direction) {
        self.init()
        
        self.dragLoadDirection = dragLoadDirection
    }
    
    /**
     移动到父视图
     */
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
                
        if let scrollView = superview as? UIScrollView {
            
            layoutConstraint(scrollView)
        }
        
        isDragLoad = true
    }
}
