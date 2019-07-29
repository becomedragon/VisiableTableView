//
//  VisiableTableView.swift
//  VisiableTableView
//
//  Created by 程晓龙 on 2019/7/29.
//  Copyright © 2019 程晓龙. All rights reserved.
//

import UIKit

protocol VisiableTableViewDelegate:UITableViewDelegate,UITableViewDataSource {
    func appearCells(indexes:[IndexPath])
    func disappearCells(indexes:[IndexPath])
}

class VisiableTableView: UITableView {
    ///config default cell appear ratio
    public var visiableRatio:CGFloat = 0.5
    
    private var visiableDelegate:VisiableTableViewDelegate?
    convenience init(delegate deg:VisiableTableViewDelegate) {
        self.init(frame:.zero,style:.plain)
        delegate = deg
        dataSource = deg
        visiableDelegate = deg
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - interface
extension VisiableTableView {
    func startListen() {
        addObserver(self, forKeyPath: #keyPath(contentOffset), options:[.new], context: nil)
    }
    
    func endListen() {
        removeObserver(self, forKeyPath: #keyPath(contentOffset), context: nil)
    }
}

//MARK: - visiable
extension VisiableTableView {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(contentOffset) {
            judgeRectIsInVisiableRange()
        }
    }
    
    private func judgeRectIsInVisiableRange() {
        let indexes = indexPathsForVisibleRows ?? []
        print("visiable index \(indexes)")
        
        var appearIndexPathes = [IndexPath]()
        var disappearIndexPathes = [IndexPath]()
        
        for (_,indexPath) in indexes.enumerated() {
            let cellRect = self.rectForRow(at: indexPath)
            let isVisiable = detectIsInRange(rect: cellRect)
            if isVisiable {
                appearIndexPathes.append(indexPath)
            } else {
                disappearIndexPathes.append(indexPath)
            }
        }
        
        if self.visiableDelegate != nil {
            self.visiableDelegate?.appearCells(indexes: appearIndexPathes)
            self.visiableDelegate?.disappearCells(indexes: disappearIndexPathes)
        }
    }
    
    private func detectIsInRange(rect:CGRect) -> Bool {
        let rectTop = rect.origin.y
        let rectBottom = rectTop + rect.height
        let rectHeight = rect.height
        
        let contentTop = contentOffset.y + contentInset.top
        let contentBottom = contentOffset.y + bounds.height - contentInset.bottom - contentInset.top
        
        if rectTop >= contentTop { //cell顶部没有超过tableview content
            if rectBottom <= contentBottom {  //cell在content内
                return true
            } else {  //判断cell的底部超出比例
                let sinkArea = rectBottom - contentBottom
                if (sinkArea / rectHeight) <= (1 - visiableRatio) {
                    return true
                } else {
                    return false
                }
            }
        } else { //cell超过顶部
            let topArea = contentTop - rectTop
            if (topArea / rectHeight) <= (1.0 - visiableRatio) {
                return true
            } else {
                return false
            }
        }
    }
}
