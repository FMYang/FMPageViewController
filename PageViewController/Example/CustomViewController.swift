//
//  CustomViewController.swift
//  PageViewController
//
//  Created by 杨方明 on 2018/3/17.
//  Copyright © 2018年 杨方明. All rights reserved.
//

import UIKit

class CustomViewController: UIViewController {

    var page: Int = 0 {
        willSet {
//            self.label.text = "page" + String(describing: newValue)
            self.tableView.reloadData()
        }
    }
    
//    lazy var label: UILabel = {
//        let label = UILabel()
//        label.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 100))
//        label.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
//        label.textColor = .black
//        label.font = UIFont.systemFont(ofSize: 20)
//        return label
//    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.frame = CGRect(x: 0, y: 0, width: fm_screenWidth, height: self.view.frame.size.height-64)
        view.dataSource = self
        view.delegate = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\(self.view.frame.origin.x / fm_screenWidth) viewWillAppear")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(self.view.frame.origin.x / fm_screenWidth) viewWillDisappear")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = []

//        self.view.addSubview(label)
        self.view.addSubview(tableView)

        // Do any additional setup after loading the view.
    }
    
    func loadData() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CustomViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        if cell == nil {
//            cell = UITableViewCell(style: .default, reuseIdentifier: "")
//        }
        cell.textLabel?.text = String.init(format: "page #%d", self.page)
        return cell
    }
}

extension CustomViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.tableView {
            
        }
    }
}


