//
//  DragLoadTitleView.swift
//  
//
//  Created by 韦烽传 on 2021/11/6.
//

import Foundation
import UIKit

/**
 拖动加载标题视图
 */
open class DragLoadTitleView: DragLoadView {
    
    /// 指示器
    open var activity: UIActivityIndicatorView  = UIActivityIndicatorView()
    /// 提示内容
    open var title: UILabel = UILabel.init()
    
    /// 布局约束
    open var lcs: [NSLayoutConstraint] = []
    
    /// 提示内容
    open var normalTitle = ""
    open var dragSmallTitle = "拖动可加载"
    open var dragBigTitle = "松开立即加载"
    open var loadEndTitle = "加载完成"
    
    /// 拖动加载状态
    open override var dragLoadStatus: DragLoad.Status {
        
        didSet {
            
            if dragLoadStatus != oldValue {
                
                updateUI()
            }
        }
    }
    
    /// 拖动加载方向
    open override var dragLoadDirection: DragLoad.Direction {
        
        didSet {
            
            updateLC()
        }
    }
    
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
     
     - parameter    dragLoadDirection:  拖动方向
     */
    public convenience init(_ dragLoadDirection: DragLoad.Direction) {
        self.init()
        
        self.dragLoadDirection = dragLoadDirection
    }
    
    /**
     初始化
     */
    open func initial() {
        
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
        
        updateLC()
        updateUI()
    }
    
    // MARK: - Event
    
    /**
     更新约束
     */
    open func updateLC() {
        
        NSLayoutConstraint.deactivate(lcs)
        lcs = []
        
        switch dragLoadDirection {
            
        case .up(let value):
            
            lcs += [NSLayoutConstraint(item: title, attribute: .left, relatedBy: .greaterThanOrEqual, toItem: self, attribute: .left, multiplier: 1, constant: 12),
                    NSLayoutConstraint(item: title, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: title, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: self, attribute: .top, multiplier: 1, constant: 8),
                    NSLayoutConstraint(item: title, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: value/2)]
            
            lcs += [NSLayoutConstraint(item: activity, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: activity, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: value/2)]

        case .down(let value):
            
            lcs += [NSLayoutConstraint(item: title, attribute: .left, relatedBy: .greaterThanOrEqual, toItem: self, attribute: .left, multiplier: 1, constant: 12),
                    NSLayoutConstraint(item: title, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: title, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: self, attribute: .top, multiplier: 1, constant: -8),
                    NSLayoutConstraint(item: title, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -value/2)]
            
            lcs += [NSLayoutConstraint(item: activity, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: activity, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -value/2)]
            
        case .left(let value):
            
            lcs += [NSLayoutConstraint(item: title, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 12),
                    NSLayoutConstraint(item: title, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: title, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: title.font.pointSize + 1),
                    NSLayoutConstraint(item: title, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: value/2)]
            
            lcs += [NSLayoutConstraint(item: activity, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: activity, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: value/2)]
            
        case .right(let value):
            
            lcs += [NSLayoutConstraint(item: title, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 12),
                    NSLayoutConstraint(item: title, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: title, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: title.font.pointSize + 1),
                    NSLayoutConstraint(item: title, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -value/2)]
            
            lcs += [NSLayoutConstraint(item: activity, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: activity, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -value/2)]
        }
        
        NSLayoutConstraint.activate(lcs)
    }
    
    /**
     更新UI
     */
    open func updateUI() {
        
        switch dragLoadStatus {
        case .normal:
            activity.isHidden = true
            title.isHidden = false
            title.text = normalTitle
        case .dragSmall:
            activity.isHidden = true
            title.isHidden = false
            title.text = dragSmallTitle
        case .dragBig:
            activity.isHidden = true
            title.isHidden = false
            title.text = dragBigTitle
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
}
