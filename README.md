# DragLoad

`Swift` `iOS` `DragLoad` `UIScrollView` `UITableView` `UICollectionView`

`UIScrollView` 滑动加载，支持上下左右滑动加载

自定义`UIView`只需继承`DragLoadProtocol`协议，设置拖动方向，即可实现拖动加载。
已实现简易的拖动加载视图`DragLoadView`、`DragLoadTitleView`

## Integration

### Xcode
    File -> Swift Packages -> Add Package dependency

### CocoaPods

[GitHub DragLoad](https://github.com/VeryLoveLoli/DragLoad)

## Usage

### Initialization

```swift
    
    @IBOutlet weak var scrollView: UIScrollView?
    
    /// 顶部加载视图（创建加载视图并设置拖动方向和偏移值）
    let topLoad = DragLoadTitleView(.down(60))
    
    /// 底部加载视图（创建加载视图并设置拖动方向和偏移值）
    let bottomLoad = DragLoadTitleView(.up(60))
    
    /// 页码
    var page = 0
    /// 列表
    var items: [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 开始加载回调
        topDragLoad.dragLoadCallback = { [weak self] in
            
            self?.page = 0
            self?.network()
        }
        
        /// 加入到滑动视图
        scrollView?.addSubview(topDragLoad)
        
        /// 开始加载回调
        bottomDragLoad.dragLoadCallback = { [weak self] in
            
            self?.page += 1
            self?.network()
        }
        
        /// 加入到滑动视图
        scrollView?.addSubview(bottomDragLoad)
        
        /// 是否可拖动加载
        bottomDragLoad.isDragLoad = false
        
        network()
    }
    
    /// 网络
    func network() {
        
        if page == 0 {
            
            /// 顶部在加载，关闭底部加载
            bottomDragLoad.isDragLoad = false
        }
        else {
            
            /// 底部在加载，关闭顶部加载
            topDragLoad.isDragLoad = false
        }
        
        /// 延时模拟网络加载
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            
            self.loadEnd()
        }
    }
    
    /// 网络结束
    func loadEnd() {
        
        if page == 0 {
            
            /// 更新视图
            updateUI()
            /// 结束加载
            topDragLoad.loadEnd(scrollView)
        }
        else {
            
            /// 结束加载
            bottomDragLoad.loadEnd(scrollView) { [weak self] bool in
                
                /// 加载动画完成，更新视图
                self?.updateUI()
            }
        }
        
        /// 开启顶部加载
        topDragLoad.isDragLoad = true
        /// 开启底部部加载
        bottomDragLoad.isDragLoad = true
    }
    
    /// 更新视图
    func updateUI() {
    
    }
    
```
