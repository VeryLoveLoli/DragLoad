# DragLoad

`Swift` `iOS` `UITableView` `UICollectionView` `DragLoad`

* `UITableView` 拖动加载/拖动更新
* `UICollectionView` 拖动加载/拖动更新

## Usage

### Initialization

```swift
    @IBOutlet weak var tableView: DragLoadTableView!
    /// 行数
    var number = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 开启拖到加载
        tableView.isDragUp = true
        tableView.isDragDown = true
        
        /// 设置加载视图
        tableView.dragUpView = DragLoadView.init()
        tableView.dragDownView = DragLoadView.init()
        
        /// 开始加载回调
        tableView.dragUpLoading = { [weak self] in
            
            self?.number += 10
            self?.networking()
        }
        
        tableView.dragDownLoading = { [weak self] in
            
            self?.number = 10
            self?.networking()
        }
        
        /// 模拟向下拖动加载
        tableView.imitateDragDownloading()
    }
    
    func networking() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            
            /// 停止加载
            self.tableView.endDragUpLoading()
            self.tableView.endDragDownLoading()
            
            /// 刷新列表
            self.tableView.reloadData()
        }
    }
```

```swift
    @IBOutlet weak var collectionView: DragLoadCollectionView!
    /// 行数
    var number = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 设置滑动方向
        collectionView.isVerticalScroll = true
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = collectionView.isVerticalScroll ? .vertical : .horizontal
        
        /// 开启拖到加载
        collectionView.isDragUp = true
        collectionView.isDragDown = true
        
        /// 设置加载视图
        collectionView.dragUpView = DragLoadView.init()
        collectionView.dragDownView = DragLoadView.init()
        
        /// 开始加载回调
        collectionView.dragUpLoading = { [weak self] in
            
            self?.number += 10
            self?.networking()
        }
        
        collectionView.dragDownLoading = { [weak self] in
            
            self?.number = 10
            self?.networking()
        }
        
        /// 模拟向下拖动加载
        collectionView.imitateDragDownloading()
    }
    
    func networking() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            
            /// 停止加载
            self.collectionView.endDragUpLoading()
            self.collectionView.endDragDownLoading()
            
            /// 刷新数据
            self.collectionView.reloadData()
        }
    }
```