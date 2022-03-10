//
//  DragLoadProtocol.swift
//  
//
//  Created by 韦烽传 on 2021/11/6.
//

import Foundation
import UIKit

/**
 拖动加载协议
 */
public protocol DragLoadProtocol: AnyObject {
    
    /// 约束列表
    var itemsLC: [NSLayoutConstraint] { get set }
    /// 末端约束
    var endLC: NSLayoutConstraint? { get set }
    
    /// 内容大小观察
    var sizeKVO: NSKeyValueObservation? { get set }
    /// 内容偏移观察
    var offsetKVO: NSKeyValueObservation? { get set }
    /// 安全区域观察
    var safeAreaKVO: NSKeyValueObservation? { get set }
    /// 内容边缘值
    var edgeInsets: UIEdgeInsets { get set }
    
    /// 拖动加载状态
    var dragLoadStatus: DragLoad.Status { get set }
    /// 拖动加载方向
    var dragLoadDirection: DragLoad.Direction { get set }
    /// 拖动动画时间
    var dragAnimationDuration: TimeInterval { get set }
    
    /// 是否可拖动加载
    var isDragLoad: Bool { get set }
    
    /// 拖动加载回调
    var dragLoadCallback: (()->Void)?  { get set }
    
    /**
     更新拖动设置
     
     - parameter    isDragLoad:     是否可拖动加载
     */
    func updateDragLoadSetting(_ isDragLoad: Bool)
    
    /**
     拖动安全区域
     
     - parameter    scrollView:     滑动视图
     */
    func dragLoadSafeArea(_ scrollView: UIScrollView) -> UIEdgeInsets
    
    /**
     设置布局约束
     
     - parameter    scrollView:     滑动视图
     */
    func layoutConstraint(_ scrollView: UIScrollView)
    
    /**
     设置观察
     
     - parameter    scrollView:     滑动视图
     */
    func kvo(_ scrollView: UIScrollView)
    
    /**
     内容大小改变
     
     - parameter    scrollView:     滑动视图
     - parameter    size:           内容大小
     */
    func contentSizeChange(_ scrollView: UIScrollView, size: CGSize)
    
    /**
     内容偏移改变
     
     - parameter    scrollView:     滑动视图
     - parameter    offset:         内容偏移
     */
    func contentOffsetChange(_ scrollView: UIScrollView, offset: CGPoint)
    
    /**
     拖动中
     
     - parameter    scrollView:     滑动视图
     - parameter    offset:         内容偏移
     */
    func dragging(_ scrollView: UIScrollView, offset: CGPoint)
    
    /**
     加载中
     
     - parameter    scrollView:     滑动视图
     - parameter    duration:       动画时间
     - parameter    completion:     动画完成
     */
    func loading(_ scrollView: UIScrollView, duration: TimeInterval, completion: ((Bool)->Void)?)
    
    /**
     加载结束
     
     - parameter    scrollView:     滑动视图
     - parameter    duration:       动画时间
     - parameter    completion:     动画完成
     */
    func loadEnd(_ scrollView: UIScrollView, duration: TimeInterval, completion: ((Bool)->Void)?)
    
    /**
     模拟拖动加载
     
     - parameter    scrollView:     滑动视图
     - parameter    animated:       偏移动画（`setContentOffset:animated:`）
     - parameter    duration:       动画时间（`loading(_ scrollView:duration:completion:`）
     - parameter    completion:     动画完成（`loading(_ scrollView:duration:completion:`）
     */
    func imitateDragLoading(_ scrollView: UIScrollView, animated: Bool, duration: TimeInterval, completion: ((Bool)->Void)?)
}

/**
 拖动加载协议实现
 */
public extension DragLoadProtocol where Self : UIView {
    
    /**
     更新拖动设置
     
     - parameter    isDragLoad:     是否可拖动加载
     */
    func updateDragLoadSetting(_ isDragLoad: Bool) {
        
        isHidden = !isDragLoad
        
        if isDragLoad {
            
            if let scrollView = superview as? UIScrollView {
                
                kvo(scrollView)
            }
        }
        else {
            
            sizeKVO = nil
            offsetKVO = nil
            safeAreaKVO = nil
        }
    }
    
    /**
     拖动安全区域
     
     - parameter    scrollView:     滑动视图
     */
    func dragLoadSafeArea(_ scrollView: UIScrollView) -> UIEdgeInsets {
        
        scrollView.contentInsetAdjustmentBehavior == .never ? .zero : scrollView.safeAreaInsets
    }
    
    /**
     设置布局约束
     
     - parameter    scrollView:     滑动视图
     */
    func layoutConstraint(_ scrollView: UIScrollView) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.deactivate(itemsLC)
        itemsLC = []
        endLC = nil
        
        switch dragLoadDirection {
            
        case .up:
            
            let top = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1, constant: max(scrollView.contentSize.height + dragLoadSafeArea(scrollView).bottom, scrollView.frame.height - dragLoadSafeArea(scrollView).top))
            
            endLC = top
            itemsLC.append(top)
            
            itemsLC += [NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: scrollView.safeAreaLayoutGuide, attribute: .left, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: scrollView.safeAreaLayoutGuide, attribute: .right, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.height)]
            
        case .down:
            
            let bottom = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1, constant: -dragLoadSafeArea(scrollView).top)
            
            endLC = bottom
            itemsLC.append(bottom)
            
            itemsLC += [NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: scrollView.safeAreaLayoutGuide, attribute: .left, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: scrollView.safeAreaLayoutGuide, attribute: .right, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.height)]
            
        case .left:
            
            let left = NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .right, multiplier: 1, constant: max(scrollView.contentSize.width + dragLoadSafeArea(scrollView).right, scrollView.frame.width - dragLoadSafeArea(scrollView).left))
            
            endLC = left
            itemsLC.append(left)
            
            itemsLC += [NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: scrollView.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: scrollView.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.width)]
            
        case .right:
            
            let right = NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: scrollView, attribute: .left, multiplier: 1, constant: -dragLoadSafeArea(scrollView).left)
            
            endLC = right
            itemsLC.append(right)
            
            itemsLC += [NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: scrollView.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: scrollView.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.width)]
        }
        
        NSLayoutConstraint.activate(itemsLC)
    }
    
    /**
     设置观察
     
     - parameter    scrollView:     滑动视图
     */
    func kvo(_ scrollView: UIScrollView) {
        
        guard isDragLoad else { return }
        
        sizeKVO = scrollView.observe(\.contentSize, changeHandler: { [weak self] object, change in
            
            self?.contentSizeChange(object, size: object.contentSize)
        })
        
        offsetKVO = scrollView.observe(\.contentOffset, changeHandler: { [weak self] object, change in
            
            self?.contentOffsetChange(object, offset: object.contentOffset)
        })
        
        safeAreaKVO = scrollView.observe(\.safeAreaInsets, changeHandler: { [weak self] object, change in
            
            self?.safeAreaChange(object, safeArea: object.safeAreaInsets)
        })
    }
    
    /**
     内容大小改变
     
     - parameter    scrollView:     滑动视图
     - parameter    size:           内容大小
     */
    func contentSizeChange(_ scrollView: UIScrollView, size: CGSize) {
        
        switch dragLoadDirection {
        case .up:
            endLC?.constant = max(scrollView.contentSize.height + dragLoadSafeArea(scrollView).bottom, scrollView.frame.height - dragLoadSafeArea(scrollView).top)
        case .down:
            endLC?.constant = -dragLoadSafeArea(scrollView).top
        case .left:
            endLC?.constant = max(scrollView.contentSize.width + dragLoadSafeArea(scrollView).right, scrollView.frame.width - dragLoadSafeArea(scrollView).left)
        case .right:
            endLC?.constant = -dragLoadSafeArea(scrollView).left
        }
    }
    
    /**
     内容偏移改变
     
     - parameter    scrollView:     滑动视图
     - parameter    offset:         内容偏移
     */
    func contentOffsetChange(_ scrollView: UIScrollView, offset: CGPoint) {
        
        if dragLoadStatus == .loading || dragLoadStatus == .loadEnd {
            
            return
        }
        
        if scrollView.isDragging {
            
            dragging(scrollView, offset: offset)
        }
        else {
            
            if dragLoadStatus == .dragBig {
                
                loading(scrollView, duration: dragAnimationDuration)
            }
        }
    }
    
    /**
     安全区域改变
     
     - parameter    scrollView:     滑动视图
     - parameter    safeArea:       安全区域
     */
    func safeAreaChange(_ scrollView: UIScrollView, safeArea: UIEdgeInsets) {
        
        switch dragLoadDirection {
        case .up:
            endLC?.constant = max(scrollView.contentSize.height + dragLoadSafeArea(scrollView).bottom, scrollView.frame.height - dragLoadSafeArea(scrollView).top)
        case .down:
            endLC?.constant = -dragLoadSafeArea(scrollView).top
        case .left:
            endLC?.constant = max(scrollView.contentSize.width + dragLoadSafeArea(scrollView).right, scrollView.frame.width - dragLoadSafeArea(scrollView).left)
        case .right:
            endLC?.constant = -dragLoadSafeArea(scrollView).left
        }
    }
    
    /**
     拖动中
     
     - parameter    scrollView:     滑动视图
     - parameter    offset:         内容偏移
     */
    func dragging(_ scrollView: UIScrollView, offset: CGPoint) {
        
        /// 临界值
        var value: CGFloat
        /// 偏移值
        var offsetValue: CGFloat
        
        switch dragLoadDirection {
        case .up(let v):
            value = v
            offsetValue = offset.y + scrollView.frame.height - max(scrollView.frame.height - dragLoadSafeArea(scrollView).top, scrollView.contentSize.height + dragLoadSafeArea(scrollView).bottom)
        case .down(let v):
            value = v
            offsetValue = -offset.y - dragLoadSafeArea(scrollView).top
        case .left(let v):
            value = v
            offsetValue = offset.x + scrollView.frame.width - max(scrollView.frame.width - dragLoadSafeArea(scrollView).left, scrollView.contentSize.width + dragLoadSafeArea(scrollView).right)
        case .right(let v):
            value = v
            offsetValue = -offset.x - dragLoadSafeArea(scrollView).left
        }
        
        if offsetValue <= 0 {
            
            dragLoadStatus = .normal
        }
        else if offsetValue < value {
            
            dragLoadStatus = .dragSmall
        }
        else {
            
            dragLoadStatus = .dragBig
        }
    }
    
    /**
     加载中
     
     - parameter    scrollView:     滑动视图
     - parameter    duration:       动画时间
     - parameter    completion:     动画完成
     */
    func loading(_ scrollView: UIScrollView, duration: TimeInterval = DragLoad.animationDuration, completion: ((Bool)->Void)? = nil) {
        
        dragLoadStatus = .loading
        
        edgeInsets = scrollView.contentInset
        
        var inset = edgeInsets
        
        switch dragLoadDirection {
        case .up(let value):
            inset.bottom = max(scrollView.frame.height - scrollView.contentSize.height - dragLoadSafeArea(scrollView).top - dragLoadSafeArea(scrollView).bottom + value, value)
        case .down(let value):
            inset.top += value
        case .left(let value):
            inset.right = max(scrollView.frame.width - scrollView.contentSize.width - dragLoadSafeArea(scrollView).left - dragLoadSafeArea(scrollView).right + value, value)
        case .right(let value):
            inset.left += value
        }
                
        UIView.animate(withDuration: duration, animations: {
            
            scrollView.contentInset = inset
            
        }, completion: { (bool) in
            
            completion?(bool)
        })
        
        self.dragLoadCallback?()
    }
    
    /**
     加载结束
     
     - parameter    scrollView:     滑动视图
     - parameter    duration:       动画时间
     - parameter    completion:     动画完成
     */
    func loadEnd(_ scrollView: UIScrollView, duration: TimeInterval = DragLoad.animationDuration, completion: ((Bool)->Void)? = nil) {
        
        dragLoadStatus = .loadEnd
        
        UIView.animate(withDuration: duration, animations: {
            
            scrollView.contentInset = self.edgeInsets
            
        }, completion: { (bool) in
            
            self.dragLoadStatus = .normal
            completion?(bool)
        })
    }
    
    /**
     模拟拖动加载
     
     - parameter    scrollView:     滑动视图
     - parameter    animated:       偏移动画（`setContentOffset:animated:`）
     - parameter    duration:       动画时间（`loading(_ scrollView:duration:completion:`）
     - parameter    completion:     动画完成（`loading(_ scrollView:duration:completion:`）
     */
    func imitateDragLoading(_ scrollView: UIScrollView, animated: Bool = true, duration: TimeInterval = DragLoad.animationDuration, completion: ((Bool)->Void)? = nil) {
        
        guard isDragLoad else { return }
        guard dragLoadStatus == .normal else { return }
        
        var offset: CGPoint = .zero
        
        switch dragLoadDirection {
            
        case .up(let value):
            
            offset.y = max(scrollView.contentSize.height + dragLoadSafeArea(scrollView).top + dragLoadSafeArea(scrollView).bottom + value - scrollView.frame.height, value)
            
        case .down(let value):
            
            if scrollView.frame.height > scrollView.contentSize.height + dragLoadSafeArea(scrollView).top + dragLoadSafeArea(scrollView).bottom {
                
                offset.y = 0
            }
            else {
                
                offset.y = -value
            }
            
        case .left(let value):
            
            offset.x = max(scrollView.contentSize.width + dragLoadSafeArea(scrollView).left + dragLoadSafeArea(scrollView).right + value - scrollView.frame.width, value)
            
        case .right(let value):
            
            if scrollView.frame.width > scrollView.contentSize.width + dragLoadSafeArea(scrollView).left + dragLoadSafeArea(scrollView).left {
                
                offset.x = 0
            }
            else {
                
                offset.x = -value
            }
        }
        
        scrollView.setContentOffset(offset, animated: animated)
        
        loading(scrollView, duration: duration, completion: completion)
    }
}
