//
//  ViewController.swift
//  DragLoadTest
//
//  Created by 韦烽传 on 2019/4/27.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

class DragLoadTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: DragLoadTableView!
    var number = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.isDragUp = true
        tableView.isDragDown = true
        
        tableView.dragUpView = DragLoadView.init()
        tableView.dragDownView = DragLoadView.init()
        
        tableView.dragUpLoading = { [weak self] in
            
            self?.number += 10
            self?.networking()
        }
        
        tableView.dragDownLoading = { [weak self] in
            
            self?.number = 10
            self?.networking()
        }
        
        tableView.imitateDragDownloading()
    }
    
    func networking() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            
            self.tableView.endDragUpLoading()
            self.tableView.endDragDownLoading()
            
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
}

class DragLoadCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: DragLoadCollectionView!
    var number = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.isDragUp = true
        collectionView.isDragDown = true
        
        collectionView.dragUpView = DragLoadView.init()
        collectionView.dragDownView = DragLoadView.init()
        
        collectionView.dragUpLoading = { [weak self] in
            
            self?.number += 10
            self?.networking()
        }
        
        collectionView.dragDownLoading = { [weak self] in
            
            self?.number = 10
            self?.networking()
        }
        
        collectionView.imitateDragDownloading()
    }
    
    func networking() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            
            self.collectionView.endDragUpLoading()
            self.collectionView.endDragDownLoading()
            
            self.collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        (cell.viewWithTag(1000) as? UILabel)?.text = "\(indexPath.row)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return collectionView.frame.size
    }
    
    @IBAction func horizontalOrVertical(_ sender: UIButton) {
        
        collectionView.isVerticalScroll = !collectionView.isVerticalScroll
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = collectionView.isVerticalScroll ? .vertical : .horizontal
        collectionView.reloadData()
        
        sender.setTitle(collectionView.isVerticalScroll ? "横向" : "竖向", for: .normal)
    }
}
