//
//  VideoVC.swift
//  PageViewController
//
//  Created by yfm on 2018/3/19.
//  Copyright © 2018年 杨方明. All rights reserved.
//

import UIKit

class VideoVC: UIViewController {
    var page: Int = 0 {
        willSet {
            self.tableView.reloadData()
        }
    }

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

        self.view.addSubview(tableView)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension VideoVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = String.init(format: "Video #%d", self.page)
        return cell
    }
}
