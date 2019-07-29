//
//  ViewController.swift
//  VisiableTableView
//
//  Created by 程晓龙 on 2019/7/29.
//  Copyright © 2019 程晓龙. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private lazy var tableView:VisiableTableView = {
       let tb = VisiableTableView(delegate: self)
        tb.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.startListen()
    }
}

extension ViewController:VisiableTableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = "\(indexPath.row)"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func appearCells(indexes: [IndexPath]) {
        print("appear cells \(indexes)")
    }
    
    func disappearCells(indexes: [IndexPath]) {
        print("disappear cells \(indexes)")
    }
}

