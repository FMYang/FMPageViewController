# FMPageViewController
# 横向翻页控件

### 效果图
![效果图](https://github.com/FMYang/FMPageViewController/blob/master/Screenshot.gif)


### 使用

**注： FMPageViewController是个控制器，所以要以addChildViewController的方式添加，与UIView的加载方式稍有不同，这里需要注意下**

```
/// 使用懒加载初始化FMPageViewController
lazy var pageVC: FMPageViewController = {
        let vc = FMPageViewController(frame: CGRect(x: 0, y: 0, width: fm_screenWidth, height: self.view.frame.size.height-64))
        vc.datasource = self
        vc.delegate = self
        return vc
    }()

override func viewDidLoad() {
     super.viewDidLoad()
          
     /// 添加到当前控制器      
     self.addChildViewController(pageVC)
     self.view.addSubview(pageVC.view)
     pageVC.didMove(toParentViewController: self)
}


extension ViewController: FMPageViewControllerDataSource {
    /// 设置页面数量
    func numberOfPages() -> Int {
        return 10
    }

    /// 返回当前控制器
    func pageViewController(pageViewController: FMPageViewController, controllerAtIndex index: Int) -> UIViewController {
        return CustomViewController(reuseIdentify: "Custom")
    }
}

extension ViewController: FMPageViewControllerDelegate {
    /// 页面切换完成
    func pageViewControllerDidChange(viewController: UIViewController, page: Int)       {
    }
    
    /// 预加载页面
    func pageViewControllerPreLoad(viewController: UIViewController, page: Int) {
    }

    /// 滑动代理
    func pageViewControllerScrollDidScroll(_ scrollView: UIScrollView, page: Int)  {

    }
}
```

详细使用请查看Example工程

### 原理

以左滑为例
- ----0、1、2  第一次显示，当前显示的是1
- 0 - 1、2、3  左滑，当前显示的是2, 0滑出屏幕加入重用池
- 1 - 2、3、4  左滑，当前显示的是3, 滑到第3页的时候，加载第4页的时候，就是从重用池取之前加入的0来重用
- 2 - 3、4、5  左滑，当前显示的是4, 滑到第4页的时候，加载第5页的时候，就是从重用池取之前加入的1来重用

依次类推，右滑同理

详细请查看源码


