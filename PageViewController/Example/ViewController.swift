//
//  ViewController.swift
//  PageViewController
//
//  Created by 杨方明 on 2018/3/16.
//  Copyright © 2018年 杨方明. All rights reserved.
//

import UIKit

let fm_screenWidth = UIScreen.main.bounds.size.width
let fm_screenHeight = UIScreen.main.bounds.size.height

class ViewController: UIViewController {
    
    lazy var pageVC: FMPageViewController = {
        let vc = FMPageViewController(frame: CGRect(x: 0, y: 0, width: fm_screenWidth, height: self.view.frame.size.height-64))
        vc.datasource = self
        vc.delegate = self
        return vc
    }()

    lazy var jumpButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("跳页", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(jump), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = []

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: jumpButton)
        
        self.addChildViewController(pageVC)
        self.view.addSubview(pageVC.view)
        pageVC.didMove(toParentViewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc func jump() {
        pageVC.pageScrollView.setContentOffset(CGPoint(x: fm_screenWidth * 5, y: 0), animated: true)
    }
}

extension ViewController: FMPageViewControllerDataSource {
    func numberOfPages() -> Int {
        return 10
    }

    func pageViewController(pageViewController: FMPageViewController, controllerAtIndex index: Int) -> UIViewController {
        if index == 3 {
            let vc = VideoVC(reuseIdentify: "Video")
            return vc
        } else {
            var vc = pageViewController.dequeueReuseViewController(identify: "Custom")
            if vc == nil {
                vc = CustomViewController(reuseIdentify: "Custom")
            }
            return vc!
        }
    }
}

extension ViewController: FMPageViewControllerDelegate {
    func pageViewControllerDidChange(viewController: UIViewController, page: Int) {
        if page == 3 {
            return
        }

        let vc = viewController as! CustomViewController
        vc.page = page
    }

    func pageViewControllerPreLoad(viewController: UIViewController, page: Int) {
        print("预加载: \(page)")

        if page == 3 {
            return
        }

        let vc = viewController as! CustomViewController
        vc.page = page
    }

    func pageViewControllerScrollDidScroll(_ scrollView: UIScrollView, page: Int) {

    }
}


