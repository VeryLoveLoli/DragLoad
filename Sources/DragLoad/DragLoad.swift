//
//  DragLoad.swift
//  DragLoadTest
//
//  Created by 韦烽传 on 2019/4/27.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation
import UIKit

/**
 拖动加载状态
 */
public enum DragLoadStatus {
    
    /// 常态
    case normal
    /// 正在拖拽
    case dragging
    /// 正在加载
    case loading
    /// 加载结束
    case loadEnd
}

/**
 拖动方向
 */
public enum DragLoadDirection {
    
    /// 上
    case up
    /// 下
    case down
    /// 左
    case left
    /// 右
    case right
}

/**
 拖动加载协议
 */
public protocol DragLoadProtocol: UIView {
    
    /// 拖动加载状态
    var dragLoadStatus: DragLoadStatus {set get}
    /// 拖动加载方向
    var dragLoadDirection: DragLoadDirection {set get}
    
    /**
     拖动加载状态改变
     */
    func dragLoadStatusChange()
    
    /**
     拖动加载 偏移量变化、视图位置大小
     */
    func dragload(_ offset: CGPoint, frameSize: CGRect)
    
    /**
     拖动加载 内容大小、视图位置大小
     */
    func dragload(_ contentSize: CGSize, frameSize: CGRect)
}

/**
 拖动加载视图
 */
open class DragLoadView: UIView, DragLoadProtocol {
    
    /// 指示器
    open var activity: UIActivityIndicatorView = UIActivityIndicatorView.init(style: .gray)
    /// 提示内容
    open var title: UILabel = UILabel.init()
    
    /// 提示内容
    open var normalTitle = "拖动可加载"
    open var draggingTitle = "松开立即加载"
    open var loadEndTitle = "加载完成"
    
    /// 约束列表
    open var layoutConstraints: [NSLayoutConstraint] = []
    /// 顶部/左边约束（用于`.up`、`.left`方向拖动）
    open var layoutConstraintTL: NSLayoutConstraint?
    
    // MARK: - init
    
    public override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        initial()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        initial()
    }
    
    /**
     初始化
     */
    open func initial() {
        
        backgroundColor = UIColor.clear
        
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: 14)
        title.textColor = UIColor.lightGray
        title.numberOfLines = 0
        activity.color = UIColor.lightGray
        addSubview(title)
        addSubview(activity)
        
        translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        activity.translatesAutoresizingMaskIntoConstraints = false
        
        dragLoadStatusChange()
    }
    
    // MARK: - LoadingProtocol
    
    open var dragLoadStatus: DragLoadStatus = .normal {
        
        didSet {
            
            if oldValue != dragLoadStatus {
                
                dragLoadStatusChange()
            }
        }
    }
    
    open var dragLoadDirection: DragLoadDirection = .up {
        
        didSet {
            
            
            NSLayoutConstraint.deactivate(layoutConstraints)
            layoutConstraints = []
            layoutConstraintTL = nil
            
            switch dragLoadDirection {
            case .up:
                
                layoutConstraints += [NSLayoutConstraint(item: title, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 12),
                                      NSLayoutConstraint(item: title, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -12),
                                      NSLayoutConstraint(item: title, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 20),
                                      NSLayoutConstraint(item: title, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20)]
                
                
                layoutConstraints += [NSLayoutConstraint(item: activity, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 20),
                                      NSLayoutConstraint(item: activity, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20),
                                      NSLayoutConstraint(item: activity, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20),
                                      NSLayoutConstraint(item: activity, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)]
                
                
                if let sup = superview as? UIScrollView {
                    
                    let top = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: sup, attribute: .top, multiplier: 1, constant: max(sup.contentSize.height, sup.frame.height))
                    
                    layoutConstraintTL = top
                    layoutConstraints.append(top)
                    
                    layoutConstraints += [NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: sup, attribute: .centerX, multiplier: 1, constant: 0),
                                          NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: sup, attribute: .width, multiplier: 1, constant: 0),
                                          NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.height)]
                }
                
            case .down:
                
                layoutConstraints += [NSLayoutConstraint(item: title, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 12),
                                      NSLayoutConstraint(item: title, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -12),
                                      NSLayoutConstraint(item: title, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -20),
                                      NSLayoutConstraint(item: title, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20)]
                
                layoutConstraints += [NSLayoutConstraint(item: activity, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -20),
                                      NSLayoutConstraint(item: activity, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20),
                                      NSLayoutConstraint(item: activity, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20),
                                      NSLayoutConstraint(item: activity, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)]
                
                if let sup = superview as? UIScrollView {
                    
                    layoutConstraints += [NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: sup, attribute: .top, multiplier: 1, constant: 0),
                                          NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: sup, attribute: .centerX, multiplier: 1, constant: 0),
                                          NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: sup, attribute: .width, multiplier: 1, constant: 0),
                                          NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.height)]
                }
                
            case .left:
                
                layoutConstraints += [NSLayoutConstraint(item: title, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 12),
                                      NSLayoutConstraint(item: title, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -12),
                                      NSLayoutConstraint(item: title, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 20),
                                      NSLayoutConstraint(item: title, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20)]
                
                layoutConstraints += [NSLayoutConstraint(item: activity, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 20),
                                      NSLayoutConstraint(item: activity, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20),
                                      NSLayoutConstraint(item: activity, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20),
                                      NSLayoutConstraint(item: activity, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)]
                
                if let sup = superview as? UIScrollView {
                    
                    let left = NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: sup, attribute: .right, multiplier: 1, constant: max(sup.contentSize.width, sup.frame.width))
                    
                    layoutConstraints.append(left)
                    layoutConstraintTL = left
                    
                    layoutConstraints += [NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
                                          NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: sup, attribute: .height, multiplier: 1, constant: 0),
                                          NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.width)]
                }
                
            case .right:
                
                layoutConstraints += [NSLayoutConstraint(item: title, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 12),
                                      NSLayoutConstraint(item: title, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -12),
                                      NSLayoutConstraint(item: title, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -20),
                                      NSLayoutConstraint(item: title, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20)]
                
                layoutConstraints += [NSLayoutConstraint(item: activity, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -20),
                                      NSLayoutConstraint(item: activity, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20),
                                      NSLayoutConstraint(item: activity, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20),
                                      NSLayoutConstraint(item: activity, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)]
                
                if let sup = superview as? UIScrollView {
                    
                    layoutConstraints += [NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: sup, attribute: .right, multiplier: 1, constant: 0),
                                          NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
                                          NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: sup, attribute: .height, multiplier: 1, constant: 0),
                                          NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.width)]
                }
            }
            
            NSLayoutConstraint.activate(layoutConstraints)
        }
    }
    
    open func dragLoadStatusChange() {
        
        switch dragLoadStatus {
        case .normal:
            activity.isHidden = true
            title.isHidden = false
            title.text = normalTitle
        case .dragging:
            activity.isHidden = true
            title.isHidden = false
            title.text = draggingTitle
        case .loading:
            activity.isHidden = false
            title.isHidden = true
            activity.startAnimating()
        case .loadEnd:
            activity.isHidden = true
            title.isHidden = false
            activity.stopAnimating()
            title.text = loadEndTitle
        }
    }
    
    open func dragload(_ offset: CGPoint, frameSize: CGRect) {
        
    }
    
    open func dragload(_ contentSize: CGSize, frameSize: CGRect) {
        
        switch dragLoadDirection {
        case .up:
            layoutConstraintTL?.constant = max(contentSize.height, frameSize.height)
        case .left:
            layoutConstraintTL?.constant = max(contentSize.width, frameSize.width)
        default:
            break
        }
    }
}

/**
 拖动加载列表
 */
open class DragLoadTableView: UITableView {
    
    // MARK: - Parameter
    
    /// 是否可向上拖动
    open var isDragUp: Bool = false {
        
        didSet {
            
            dragUpView?.isHidden = !isDragUp
        }
    }
    
    /// 是否可向下拖动
    open var isDragDown: Bool = false {
        
        didSet {
            
            dragDownView?.isHidden = !isDragDown
        }
    }
    
    /// 向上拖动加载响应
    open var dragUpLoading: ()->Void = { }
    
    /// 向下拖动加载响应
    open var dragDownLoading: ()->Void = { }
    
    /// 向上拖动加载偏移值
    open var dragUpOffsetY: CGFloat = 60
    /// 向下拖动加载偏移值
    open var dragDownOffsetY: CGFloat = 60
    /// 向上拖动偏移动画时间
    open var dragUpAnimationDuration: TimeInterval = 0.25
    /// 向下拖动偏移动画时间
    open var dragDownAnimationDuration: TimeInterval = 0.25
    
    /// 向上拖动底部视图
    open var dragUpView: DragLoadProtocol? {
        
        willSet {
            
            dragUpView?.removeFromSuperview()
            newValue?.removeFromSuperview()
        }
        
        didSet {
            
            if let v = dragUpView {
                
                addSubview(v)
            }
            
            dragUpView?.dragLoadDirection = .up
            dragUpView?.isHidden = !isDragUp
        }
    }
    
    /// 向下拖动顶部视图
    open var dragDownView: DragLoadProtocol? {
        
        willSet {
            
            dragDownView?.removeFromSuperview()
            newValue?.removeFromSuperview()
        }
        
        didSet {
            
            if let v = dragDownView {
                
                addSubview(v)
            }
            
            dragDownView?.dragLoadDirection = .down
            dragDownView?.isHidden = !isDragDown
        }
    }
    
    /// 监听 contentSize
    open override var contentSize: CGSize {
        
        didSet {
            
            dragUpView?.dragload(contentSize, frameSize: frame)
            dragDownView?.dragload(contentOffset, frameSize: frame)
        }
    }
    
    /// 监听 contentOffset
    open override var contentOffset: CGPoint {
        
        didSet {
            
            dragUpView?.dragload(contentOffset, frameSize: frame)
            dragDownView?.dragload(contentOffset, frameSize: frame)
            
            if dragUpView?.dragLoadStatus != .loading && dragDownView?.dragLoadStatus != .loading
                && dragUpView?.dragLoadStatus != .loadEnd && dragDownView?.dragLoadStatus != .loadEnd {
                
                let offsetY = contentOffset.y + frame.size.height - max(contentSize.height, frame.size.height)
                
                if isDragUp && offsetY > 0 {
                    
                    if offsetY >= dragUpOffsetY {
                        
                        dragUpView?.dragLoadStatus = .dragging
                    }
                    else {
                        
                        dragUpView?.dragLoadStatus = .normal
                    }
                }
                
                if isDragDown && contentOffset.y < 0 {
                    
                    if contentOffset.y <= -dragDownOffsetY {
                        
                        dragDownView?.dragLoadStatus = .dragging
                    }
                    else {
                        
                        dragDownView?.dragLoadStatus = .normal
                    }
                }
                
                if !isDragging {
                    
                    startDragUpLoading()
                    startDragDownLoading()
                }
            }
        }
    }
    
    // MARK: - Loading
    
    /**
     开始向上拖动加载
     */
    open func startDragUpLoading() {
        
        if dragUpView?.dragLoadStatus == .dragging && dragDownView?.dragLoadStatus != .loading && dragDownView?.dragLoadStatus != .loadEnd && isDragUp == true {
            
            dragUpView?.dragLoadStatus = .loading
            
            var inset = contentInset
            inset.bottom = max(dragUpOffsetY, frame.height - contentSize.height + dragUpOffsetY)
            
            UIView.animate(withDuration: dragUpAnimationDuration, animations: {
                
                self.contentInset = inset
                
            }, completion: { (bool) in
                
                self.dragUpLoading()
            })
        }
    }
    
    /**
     开始向下拖动加载
     */
    open func startDragDownLoading() {
        
        if dragUpView?.dragLoadStatus != .loading && dragUpView?.dragLoadStatus != .loadEnd && dragDownView?.dragLoadStatus == .dragging && isDragDown == true {
            
            dragDownView?.dragLoadStatus = .loading
            
            var inset = contentInset
            inset.top = dragDownOffsetY
            
            UIView.animate(withDuration: dragDownAnimationDuration, animations: {
                
                self.contentInset = inset
                
            }, completion: { (bool) in
                
                self.dragDownLoading()
            })
        }
    }
    
    /**
     结束向上拖动加载
     */
    open func endDragUpLoading() {
        
        dragUpView?.dragLoadStatus = .loadEnd
        
        UIView.animate(withDuration: dragUpAnimationDuration, animations: {
            
            self.contentInset = UIEdgeInsets.zero
            
        }, completion: { (bool) in
            
            self.dragUpView?.dragLoadStatus = .normal
        })
    }
    
    /**
     结束向下拖动加载
     */
    open func endDragDownLoading() {
        
        dragDownView?.dragLoadStatus = .loadEnd
        
        UIView.animate(withDuration: dragDownAnimationDuration, animations: {
            
            self.contentInset = UIEdgeInsets.zero
            
        }, completion: { (bool) in
            
            self.dragDownView?.dragLoadStatus = .normal
        })
    }
    
    // MARK: - 模拟上下拖动加载
    
    /**
     模拟向上拖动加载
     */
    open func imitateDragUploading() {
        
        setContentOffset(CGPoint.init(x: 0, y: max(contentSize.height, frame.size.height) - frame.size.height + 1.2*dragUpOffsetY), animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            
            self.startDragUpLoading()
        }
    }
    
    /**
     模拟向下拖动加载
     */
    open func imitateDragDownloading() {
        
        setContentOffset(CGPoint.init(x: 0, y: -1.2*dragDownOffsetY), animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            
            self.startDragDownLoading()
        }
    }
}

/**
 拖动加载集合
 */
open class DragLoadCollectionView: UICollectionView {
    
    // MARK: - Parameter
    
    /// 是否是竖向滑动
    open var isVerticalScroll: Bool = true {
        
        didSet {
            
            if oldValue != isVerticalScroll {
                
                if isVerticalScroll {
                    
                    if dragUpView?.dragLoadDirection != .up {
                        
                        dragUpView?.dragLoadDirection = .up
                    }
                    
                    if dragDownView?.dragLoadDirection != .down {
                        
                        dragDownView?.dragLoadDirection = .down
                    }
                }
                else {
                    
                    if dragUpView?.dragLoadDirection != .left {
                        
                        dragUpView?.dragLoadDirection = .left
                    }
                    
                    if dragDownView?.dragLoadDirection != .right {
                        
                        dragDownView?.dragLoadDirection = .right
                    }
                }
            }
        }
    }
    
    /// 是否可向上拖动
    open var isDragUp: Bool = false {
        
        didSet {
            
            dragUpView?.isHidden = !isDragUp
        }
    }
    
    /// 是否可向下拖动
    open var isDragDown: Bool = false {
        
        didSet {
            
            dragDownView?.isHidden = !isDragDown
        }
    }
    
    /// 向上拖动加载响应
    open var dragUpLoading: ()->Void = { }
    
    /// 向下拖动加载响应
    open var dragDownLoading: ()->Void = { }
    
    /// 向上拖动加载偏移值
    open var dragUpOffset: CGPoint = CGPoint.init(x: 60, y: 60)
    /// 向下拖动加载偏移值
    open var dragDownOffset: CGPoint = CGPoint.init(x: 60, y: 60)
    /// 向上拖动偏移动画时间
    open var dragUpAnimationDuration: TimeInterval = 0.25
    /// 向下拖动偏移动画时间
    open var dragDownAnimationDuration: TimeInterval = 0.25
    
    /// 向上拖动底部视图
    open var dragUpView: DragLoadProtocol? {
        
        willSet {
            
            dragUpView?.removeFromSuperview()
            newValue?.removeFromSuperview()
        }
        
        didSet {
            
            dragUpView?.isHidden = !isDragUp
            
            if let v = dragUpView {
                
                self.addSubview(v)
            }
            
            if isVerticalScroll {
                
                dragUpView?.dragLoadDirection = .up
            }
            else {
                
                dragUpView?.dragLoadDirection = .left
            }
        }
    }
    
    /// 向下拖动顶部视图
    open var dragDownView: DragLoadProtocol? {
        
        willSet {
            
            dragDownView?.removeFromSuperview()
            newValue?.removeFromSuperview()
        }
        
        didSet {
            
            dragDownView?.isHidden = !isDragDown
            
            if let v = dragDownView {
                
                self.addSubview(v)
            }
            
            if isVerticalScroll {
                
                dragDownView?.dragLoadDirection = .down
            }
            else {
                
                dragDownView?.dragLoadDirection = .right
            }
        }
    }
    
    /// 监听 contentSize
    open override var contentSize: CGSize {
        
        didSet {
            
            dragUpView?.dragload(contentSize, frameSize: frame)
            dragDownView?.dragload(contentSize, frameSize: frame)
        }
    }
    
    /// 监听 contentOffset
    open override var contentOffset: CGPoint {
        
        didSet {
            
            dragUpView?.dragload(contentOffset, frameSize: frame)
            dragDownView?.dragload(contentOffset, frameSize: frame)
            
            if dragUpView?.dragLoadStatus != .loading && dragDownView?.dragLoadStatus != .loading
                && dragUpView?.dragLoadStatus != .loadEnd && dragDownView?.dragLoadStatus != .loadEnd {
                
                if isVerticalScroll {
                    
                    let offsetY = contentOffset.y + frame.size.height - max(contentSize.height, frame.size.height)
                    
                    if isDragUp && offsetY > 0 {
                        
                        if offsetY >= dragUpOffset.y {
                            
                            dragUpView?.dragLoadStatus = .dragging
                        }
                        else {
                            
                            dragUpView?.dragLoadStatus = .normal
                        }
                    }
                    
                    if isDragDown && contentOffset.y < 0 {
                        
                        if contentOffset.y <= -dragDownOffset.y {
                            
                            dragDownView?.dragLoadStatus = .dragging
                        }
                        else {
                            
                            dragDownView?.dragLoadStatus = .normal
                        }
                    }
                }
                else {
                    
                    let offsetX = contentOffset.x + frame.size.width - max(contentSize.width, frame.size.width)
                    
                    if isDragUp && offsetX > 0 {
                        
                        if offsetX >= dragUpOffset.x {
                            
                            dragUpView?.dragLoadStatus = .dragging
                        }
                        else {
                            
                            dragUpView?.dragLoadStatus = .normal
                        }
                    }
                    
                    if isDragDown && contentOffset.x < 0 {
                        
                        if contentOffset.x <= -dragDownOffset.x {
                            
                            dragDownView?.dragLoadStatus = .dragging
                        }
                        else {
                            
                            dragDownView?.dragLoadStatus = .normal
                        }
                    }
                }
                
                if !isDragging {
                    
                    startDragUpLoading()
                    startDragDownLoading()
                }
            }
        }
    }
    
    // MARK: - Loading
    
    /**
     开始向上拖动加载
     */
    open func startDragUpLoading() {
        
        if dragUpView?.dragLoadStatus == .dragging && dragDownView?.dragLoadStatus != .loading && dragDownView?.dragLoadStatus != .loadEnd && isDragUp == true {
            
            dragUpView?.dragLoadStatus = .loading
            
            var inset = contentInset
            
            if isVerticalScroll {
                
                inset.bottom = max(dragUpOffset.y, frame.height - contentSize.height + dragUpOffset.y)
            }
            else {
                
                inset.right = max(dragUpOffset.x, frame.width - contentSize.width + dragUpOffset.x)
            }
            
            UIView.animate(withDuration: dragUpAnimationDuration, animations: {
                
                self.contentInset = inset
                
            }, completion: { (bool) in
                
                self.dragUpLoading()
            })
        }
    }
    
    /**
     开始向下拖动加载
     */
    open func startDragDownLoading() {
        
        if dragUpView?.dragLoadStatus != .loading && dragUpView?.dragLoadStatus != .loadEnd && dragDownView?.dragLoadStatus == .dragging && isDragDown == true {
            
            dragDownView?.dragLoadStatus = .loading
            
            var inset = contentInset
            
            if isVerticalScroll {
                
                inset.top = dragDownOffset.y
            }
            else {
                
                inset.left = dragDownOffset.x
            }
            
            UIView.animate(withDuration: dragDownAnimationDuration, animations: {
                
                self.contentInset = inset
                
            }, completion: { (bool) in
                
                self.dragDownLoading()
            })
        }
    }
    
    /**
     结束向上拖动加载
     */
    open func endDragUpLoading() {
        
        dragUpView?.dragLoadStatus = .loadEnd
        
        UIView.animate(withDuration: dragUpAnimationDuration, animations: {
            
            self.contentInset = UIEdgeInsets.zero
            
        }, completion: { (bool) in
            
            self.dragUpView?.dragLoadStatus = .normal
        })
    }
    
    /**
     结束向下拖动加载
     */
    open func endDragDownLoading() {
        
        dragDownView?.dragLoadStatus = .loadEnd
        
        UIView.animate(withDuration: dragDownAnimationDuration, animations: {
            
            self.contentInset = UIEdgeInsets.zero
            
        }, completion: { (bool) in
            
            self.dragDownView?.dragLoadStatus = .normal
        })
    }
    
    // MARK: - 模拟上下拖动加载
    
    /**
     模拟向上拖动加载
     */
    open func imitateDragUploading() {
        
        if isVerticalScroll {
            
            setContentOffset(CGPoint.init(x: 0, y: max(contentSize.height, frame.size.height) - frame.size.height + 1.2*dragUpOffset.y), animated: true)
        }
        else {
            
            setContentOffset(CGPoint.init(x: max(contentSize.width, frame.size.width) - frame.size.width + 1.2*dragUpOffset.x, y: 0), animated: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            
            self.startDragUpLoading()
        }
    }
    
    /**
     模拟向下拖动加载
     */
    open func imitateDragDownloading() {
        
        if isVerticalScroll {
            
            setContentOffset(CGPoint.init(x: 0, y: -1.2*dragDownOffset.y), animated: true)
        }
        else {
            
            setContentOffset(CGPoint.init(x: -1.2*dragDownOffset.x, y: 0), animated: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            
            self.startDragDownLoading()
        }
    }
}
