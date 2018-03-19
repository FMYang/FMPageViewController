//
//  VideoVC.swift
//  PageViewController
//
//  Created by yfm on 2018/3/19.
//  Copyright © 2018年 杨方明. All rights reserved.
//

import UIKit

class VideoVC: UIViewController {

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

        self.view.backgroundColor = .red
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
