//
//  PageViewController.swift
//  PageViewController
//
//  Created by 杨方明 on 2018/3/16.
//  Copyright © 2018年 杨方明. All rights reserved.
//
//  横向重用的翻页控件，实现原理参考UITableView
//

import UIKit

/// 页面滑动方向
///
/// - left: 左滑
/// - right: 右滑
enum FMPageViewScrollDiretion {
    case left
    case right
}

protocol FMPageViewControllerDataSource: class {
    /// page的数量
    ///
    /// - Returns: page的数量
    func numberOfPages() -> Int

    /// 获取childController
    ///
    /// - Parameters:
    ///   - pageViewController: 容器视图控制器
    ///   - index: 第几页
    /// - Returns: 当前页加载的VC
    func pageViewController(pageViewController: FMPageViewController, controllerAtIndex index: Int) -> UIViewController
}

protocol FMPageViewControllerDelegate: class {
    /// 页面切换完成代理
    ///
    /// - Parameters:
    ///   - viewController: 当前控制器
    ///   - page: 当前页码
    func pageViewControllerDidChange(viewController: UIViewController, page: Int)

    /// 预加载控制器的代理
    ///
    /// - Parameters:
    ///   - viewController: 预加载的控制器
    ///   - page: 预加载控制器的页码
    func pageViewControllerPreLoad(viewController: UIViewController, page: Int)

    /// 滑动代理
    ///
    /// - Parameters:
    ///   - scrollView: 滑动View
    ///   - page: 滑动到哪一页
    func pageViewControllerScrollDidScroll(_ scrollView: UIScrollView, page: Int)
}

class FMPageViewController: UIViewController {
    weak var datasource: FMPageViewControllerDataSource?
    weak var delegate: FMPageViewControllerDelegate?
    var direction: FMPageViewScrollDiretion = .right   // 滑动方向
    var reuseViewControllers = [UIViewController]() // 重用池
    var visibleViewController = [UIViewController]() // 可用池
    var currentPage: Int = -1
    var viewFrame: CGRect = .zero

    var totalPages = 0 {
        willSet {
            pageScrollView.contentSize = CGSize(width: CGFloat(newValue) * viewFrame.size.width, height: viewFrame.size.height)
        }
    }

    lazy var pageScrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .clear
        view.isPagingEnabled = true
        view.delegate = self
        return view
    }()

    convenience init(frame: CGRect) {
        self.init()
        viewFrame = frame
    }

    override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        assert(datasource != nil, "datasource can not be nil")

        self.edgesForExtendedLayout = []

        totalPages = datasource!.numberOfPages()

        self.view.frame = viewFrame
        pageScrollView.frame = CGRect(x: 0, y: 0, width: viewFrame.size.width, height: viewFrame.size.height)
        pageScrollView.contentSize = CGSize(width: CGFloat(totalPages) * viewFrame.size.width, height: viewFrame.size.height)
        print(self.view)
        self.view.addSubview(pageScrollView)
        self.loadPage(page: 0)

        // 首次加载，预加载第二页的内容
        if self.currentPage == 0 {
            self.pageDidChange(page: 0)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - private method
    private func loadPage(page: Int) {
        if self.currentPage == page { return }
        self.currentPage = page

        // 当前屏幕显示的Frame集合
        var pagesFrames = [viewFrame.size.width * CGFloat(page), viewFrame.size.width * CGFloat(page-1),  viewFrame.size.width * CGFloat(page+1)]

        // 记录滑出屏幕的VC，加入队列，稍后删除
        var vcsToEnqueue = [UIViewController]()

        // 遍历当前容器可用的vc
        for vc in visibleViewController {
            // 如果vc是第一次创建的，或者移出当前屏幕
            if vc.view.frame.origin.x == 0 || !pagesFrames.contains(vc.view.frame.origin.x) {
                // 找到离开屏幕的vc
                vcsToEnqueue.append(vc)
            } else {
                // 保留不在容器显示vc
                pagesFrames.remove(vc.view.frame.origin.x)
            }
        }

        // 将离开屏幕的vc从父视图移除，并加入重用池
        for vc in vcsToEnqueue {
            // 将要移除
            vc.view.removeFromSuperview()
            visibleViewController.remove(vc)
            reuseViewControllers.append(vc)
        }

        // 不在容器VC，添加到容器
        for originX in pagesFrames {
            self.addChildViewController(page: Int(originX/viewFrame.size.width))
        }
    }

    // 加入容器并设置frame
    private func addChildViewController(page: Int) {
        if page < 0 || page > totalPages-1 { return }
        let vc = datasource!.pageViewController(pageViewController: self, controllerAtIndex: page)
        //self.dequeueReuseViewController(page: page)

        vc.view.frame = CGRect(x: viewFrame.size.width * CGFloat(page), y: 0, width: viewFrame.size.width, height: viewFrame.size.height)

        // vc是重用池取出来的，从重用池移除
        if reuseViewControllers.contains(vc) {
            reuseViewControllers.remove(vc)
        } else {
            // vc是新创建的，加入容器
            vc.willMove(toParentViewController: self)
            self.addChildViewController(vc)
            vc.didMove(toParentViewController: self)
        }

        // 视图将要显示
        pageScrollView.addSubview(vc.view)
        // 将vc加入可用池
        visibleViewController.append(vc)
    }

    // 获取容器中的VC，前一个、当前、后一个VC
    private func pageDidChange(page: Int) {
        for vc in visibleViewController {
            if vc.view.frame.origin.x == pageScrollView.contentOffset.x {
                let (beforeVC, afterVC) = self.getBeforAndAfterVC(currentVC: vc)
                if direction == .left {
                    if let vc = beforeVC {
                        let page = Int(vc.view.frame.origin.x / viewFrame.size.width)
                        delegate?.pageViewControllerPreLoad(viewController: vc, page: page)
                    }
                } else {
                    if let vc = afterVC {
                        let page = Int(vc.view.frame.origin.x / viewFrame.size.width)
                        delegate?.pageViewControllerPreLoad(viewController: vc, page: page)
                    }
                }
                delegate?.pageViewControllerDidChange(viewController: vc, page: page)
                break
            }
        }
    }

    // 获取前面和后面的VC
    private func getBeforAndAfterVC(currentVC: UIViewController) -> (UIViewController?, UIViewController?) {
        var beforeVC: UIViewController?
        var afterVC: UIViewController?

        for vc in visibleViewController {
            if currentVC.view.frame.origin.x  > vc.view.frame.origin.x  {
                beforeVC = vc
            } else if currentVC.view.frame.origin.x  < vc.view.frame.origin.x  {
                afterVC = vc
            }
        }
        return (beforeVC, afterVC)
    }

    // MARK: - public method
    /// 重用VC
    ///
    /// - Parameter identify: 重用标识符
    /// - Returns: 可重用的VC
    public func dequeueReuseViewController(identify: String) -> UIViewController? {
        // 根据重用标识从重用池获取可用的VC
        for vc in reuseViewControllers {
            if vc.reuseIdentify == identify {
                return vc
            }
        }
        return nil
    }
}

extension FMPageViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == pageScrollView {
            var page = Int(roundf(Float(scrollView.contentOffset.x / scrollView.frame.size.width)))
            page = max(page, 0)
            page = min(page, totalPages-1)
            delegate?.pageViewControllerScrollDidScroll(scrollView, page: page)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == pageScrollView {
            if scrollView.contentOffset.x <= 0 || scrollView.contentOffset.x >= scrollView.contentSize.width {
                return
            }
            var page = Int(roundf(Float(scrollView.contentOffset.x / scrollView.frame.size.width)))
            page = max(page, 0)
            page = min(page, totalPages-1)
            self.loadPage(page: page)

            self.pageDidChange(page: page)
        }
    }

    // 跳页和快速滑动情况处理
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView == pageScrollView {
            if scrollView.contentOffset.x <= 0 || scrollView.contentOffset.x >= scrollView.contentSize.width {
                return
            }
            var page = Int(roundf(Float(scrollView.contentOffset.x / scrollView.frame.size.width)))
            page = max(page, 0)
            page = min(page, totalPages-1)
            self.loadPage(page: page)

            self.pageDidChange(page: page)
        }
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.x > 0 {
            direction = .right
        } else {
            direction = .left
        }
    }
}

extension Array where Element: Equatable {
    /// 根据值删除对象
    ///
    /// - Parameter object: 要删除的对象
    mutating func remove(_ object: Element) {
        self = self.filter() { $0 != object }
    }
}

private var pageReuseKey = "page_reuse_key"

// 扩展UIViewController
extension UIViewController {
    /// 添加重用标识属性
    var reuseIdentify: String? {
        get {
            return objc_getAssociatedObject(self, &pageReuseKey) as? String
        }
        set {
            objc_setAssociatedObject(self,
                                     &pageReuseKey,
                                     newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// 初始化UIViewController
    ///
    /// - Parameter reuseIdentify: 重用标识
    convenience init(reuseIdentify: String) {
        self.init()
        self.reuseIdentify = reuseIdentify
    }
}

