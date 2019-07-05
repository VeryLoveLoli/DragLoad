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
    case righe
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
     拖动加载 偏移量变化、内容大小、视图位置大小
     */
    func dragload(_ offset: CGPoint, contentSize: CGSize, frameSize: CGRect)
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
    
    // MARK: - init
    
    public override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.initial()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.initial()
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
    }
    
    open override var frame: CGRect {
        
        didSet {
            
            switch dragLoadDirection {
            case .up:
                title.frame = CGRect.init(x: 0, y: 20, width: frame.size.width, height: 20)
                activity.frame = CGRect.init(x: (frame.size.width-20)/2, y: 20, width: 20, height: 20)
            case .down:
                title.frame = CGRect.init(x: 0, y: frame.size.height - 20 - 20, width: frame.size.width, height: 20)
                activity.frame = CGRect.init(x: (frame.size.width-20)/2, y: frame.size.height - 20 - 20, width: 20, height: 20)
            case .left:
                title.frame = CGRect.init(x: 20, y: 0, width: 20, height: frame.size.height)
                activity.frame = CGRect.init(x: 20, y: (frame.size.height-20)/2, width: 20, height: 20)
            case .righe:
                title.frame = CGRect.init(x: frame.size.width - 20 - 20, y: 0, width: 20, height: frame.size.height)
                activity.frame = CGRect.init(x: frame.size.width - 20 - 20, y: (frame.size.height-20)/2, width: 20, height: 20)
            }
        }
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
    
    open func dragload(_ offset: CGPoint, contentSize: CGSize, frameSize: CGRect) {
        
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
            
            dragUpView?.dragLoadDirection = .up
            dragUpView?.frame = CGRect.init(origin: CGPoint.init(x: 0, y: max(contentSize.height, frame.size.height)), size: frame.size)
            dragUpView?.isHidden = !isDragUp
            
            if let v = dragUpView {
                
                self.addSubview(v)
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
            
            dragDownView?.dragLoadDirection = .down
            dragDownView?.frame = CGRect.init(origin: CGPoint.init(x: 0, y: -frame.size.height), size: frame.size)
            dragDownView?.isHidden = !isDragDown
            
            if let v = dragDownView {
                
                self.addSubview(v)
            }
        }
    }
    
    open override var frame: CGRect {
        
        didSet {
            
            dragUpView?.frame = CGRect.init(origin: CGPoint.init(x: 0, y: max(contentSize.height, frame.size.height)), size: frame.size)
            dragDownView?.frame = CGRect.init(origin: CGPoint.init(x: 0, y: -frame.size.height), size: frame.size)
        }
    }
    
    /// 监听 contentSize
    open override var contentSize: CGSize {
        
        didSet {
            
            /// 设置 向上拖动底部视图 顶部高度
            if var dragUpViewFrame = dragUpView?.frame  {
                
                dragUpViewFrame.origin.y = max(contentSize.height, frame.size.height)
                dragUpView?.frame = dragUpViewFrame
            }
        }
    }
    
    /// 监听 contentOffset
    open override var contentOffset: CGPoint {
        
        didSet {
            
            dragUpView?.dragload(contentOffset, contentSize: contentSize, frameSize: frame)
            dragDownView?.dragload(contentOffset, contentSize: contentSize, frameSize: frame)

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
    
    // MARK: - Layout
    
    open override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        dragUpView?.frame = CGRect.init(origin: CGPoint.init(x: 0, y: max(contentSize.height, frame.size.height)), size: frame.size)
        dragDownView?.frame = CGRect.init(origin: CGPoint.init(x: 0, y: -frame.size.height), size: frame.size)
    }
    
    // MARK: - Loading
    
    /**
     开始向上拖动加载
     */
    open func startDragUpLoading() {
        
        if dragUpView?.dragLoadStatus == .dragging && dragDownView?.dragLoadStatus != .loading && dragDownView?.dragLoadStatus != .loadEnd && isDragUp == true {
            
            dragUpView?.dragLoadStatus = .loading
            
            var inset = contentInset
            inset.bottom = dragUpOffsetY
            
            var offsetY = min(frame.size.height - contentSize.height, inset.bottom)
            offsetY = max(offsetY, 0)
            let offsetFrame = CGRect.init(origin: CGPoint.init(x: 0, y: max(contentSize.height, frame.size.height) - offsetY), size: frame.size)
            
            UIView.animate(withDuration: dragUpAnimationDuration, animations: {
                
                self.contentInset = inset
                self.dragUpView?.frame = offsetFrame
                
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
        
        let offsetFrame = CGRect.init(origin: CGPoint.init(x: 0, y: max(contentSize.height, frame.size.height)), size: frame.size)
        
        UIView.animate(withDuration: dragUpAnimationDuration, animations: {
            
            self.contentInset = UIEdgeInsets.zero
            self.dragUpView?.frame = offsetFrame
            
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
                
                let f = frame
                frame = f
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
            
            if isVerticalScroll {
                
                dragUpView?.dragLoadDirection = .up
                dragUpView?.frame = CGRect.init(origin: CGPoint.init(x: 0, y: max(contentSize.height, frame.size.height)), size: frame.size)
            }
            else {
                
                dragUpView?.dragLoadDirection = .left
                dragUpView?.frame = CGRect.init(origin: CGPoint.init(x: max(contentSize.width, frame.size.width), y: 0), size: frame.size)
            }
            
            dragUpView?.isHidden = !isDragUp
            
            if let v = dragUpView {
                
                self.addSubview(v)
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
            
            if isVerticalScroll {
                
                dragDownView?.dragLoadDirection = .down
                dragDownView?.frame = CGRect.init(origin: CGPoint.init(x: 0, y: -frame.size.height), size: frame.size)
            }
            else {
                
                dragDownView?.dragLoadDirection = .righe
                dragDownView?.frame = CGRect.init(origin: CGPoint.init(x: -frame.size.width, y: 0), size: frame.size)
            }
            
            dragDownView?.isHidden = !isDragDown
            
            if let v = dragDownView {
                
                self.addSubview(v)
            }
        }
    }
    
    open override var frame: CGRect {
        
        didSet {
            
            if isVerticalScroll {
                
                dragUpView?.dragLoadDirection = .up
                dragDownView?.dragLoadDirection = .down
                dragUpView?.frame = CGRect.init(origin: CGPoint.init(x: 0, y: max(contentSize.height, frame.size.height)), size: frame.size)
                dragDownView?.frame = CGRect.init(origin: CGPoint.init(x: 0, y: -frame.size.height), size: frame.size)
            }
            else {
                
                dragUpView?.dragLoadDirection = .left
                dragDownView?.dragLoadDirection = .righe
                dragUpView?.frame = CGRect.init(origin: CGPoint.init(x: max(contentSize.width, frame.size.width), y: 0), size: frame.size)
                dragDownView?.frame = CGRect.init(origin: CGPoint.init(x: -frame.size.width, y: 0), size: frame.size)
            }
        }
    }
    
    /// 监听 contentSize
    open override var contentSize: CGSize {
        
        didSet {
            
            /// 设置 向上拖动底部视图 顶部高度
            if var dragUpViewFrame = dragUpView?.frame  {
                
                if dragUpView?.dragLoadStatus == .loading {
                    
                    if isVerticalScroll {
                        
                        var offsetY = min(frame.size.height - contentSize.height, contentInset.bottom)
                        offsetY = max(offsetY, 0)
                        dragUpViewFrame.origin.x = 0
                        dragUpViewFrame.origin.y = max(contentSize.height, frame.size.height) - offsetY
                    }
                    else {
                        
                        var offsetX = min(frame.size.width - contentSize.width, contentInset.right)
                        offsetX = max(offsetX, 0)
                        dragUpViewFrame.origin.x = max(contentSize.width, frame.size.width) - offsetX
                        dragUpViewFrame.origin.y = 0
                    }
                }
                else {
                    
                    if isVerticalScroll {
                        
                        dragUpViewFrame.origin.x = 0
                        dragUpViewFrame.origin.y = max(contentSize.height, frame.size.height)
                        dragUpView?.frame = dragUpViewFrame
                    }
                    else {
                        
                        dragUpViewFrame.origin.x = max(contentSize.width, frame.size.width)
                        dragUpViewFrame.origin.y = 0
                        dragUpView?.frame = dragUpViewFrame
                    }
                }
            }
        }
    }
    
    /// 监听 contentOffset
    open override var contentOffset: CGPoint {
        
        didSet {
            
            dragUpView?.dragload(contentOffset, contentSize: contentSize, frameSize: frame)
            dragDownView?.dragload(contentOffset, contentSize: contentSize, frameSize: frame)
            
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
    
    // MARK: - Layout
    
    open override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        if isVerticalScroll {
            
            dragUpView?.dragLoadDirection = .up
            dragDownView?.dragLoadDirection = .down
            dragUpView?.frame = CGRect.init(origin: CGPoint.init(x: 0, y: max(contentSize.height, frame.size.height)), size: frame.size)
            dragDownView?.frame = CGRect.init(origin: CGPoint.init(x: 0, y: -frame.size.height), size: frame.size)
        }
        else {
            
            dragUpView?.dragLoadDirection = .left
            dragDownView?.dragLoadDirection = .righe
            dragUpView?.frame = CGRect.init(origin: CGPoint.init(x: max(contentSize.width, frame.size.width), y: 0), size: frame.size)
            dragDownView?.frame = CGRect.init(origin: CGPoint.init(x: -frame.size.width, y: 0), size: frame.size)
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
            
            var offsetFrame = CGRect.init()
            
            if isVerticalScroll {
                
                inset.bottom = dragUpOffset.y
                
                var offsetY = min(frame.size.height - contentSize.height, inset.bottom)
                offsetY = max(offsetY, 0)
                offsetFrame = CGRect.init(origin: CGPoint.init(x: 0, y: max(contentSize.height, frame.size.height) - offsetY), size: frame.size)
            }
            else {
                
                inset.right = dragUpOffset.x
                
                var offsetX = min(frame.size.width - contentSize.width, inset.right)
                offsetX = max(offsetX, 0)
                offsetFrame = CGRect.init(origin: CGPoint.init(x: max(contentSize.width, frame.size.width) - offsetX, y: 0), size: frame.size)
            }
            
            UIView.animate(withDuration: dragUpAnimationDuration, animations: {
                
                self.contentInset = inset
                self.dragUpView?.frame = offsetFrame
                
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
        
        let offsetFrame = CGRect.init(origin: CGPoint.init(x: 0, y: max(contentSize.height, frame.size.height)), size: frame.size)
        
        UIView.animate(withDuration: dragUpAnimationDuration, animations: {
            
            self.contentInset = UIEdgeInsets.zero
            self.dragUpView?.frame = offsetFrame
            
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
