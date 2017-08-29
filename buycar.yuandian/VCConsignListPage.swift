//
//  VCConsignListPage.swift
//  buycar.yuandian
//
//  Created by 李萌 on 2017/8/28.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import UIKit

class VCConsignListPage: UIViewController {
    
    var pageViewController: UIPageViewController!
    var pendingList: VCConsignPendingList!
    var historyList: VCConsignHistoryList!
    var controllers = [UIViewController]()
    
    @IBOutlet weak var consignPendingButton: UIButton!
    @IBOutlet weak var consignHistoryButton: UIButton!
    @IBOutlet weak var tabbarView: UIView!
    var sliderImageView: UIImageView!
    
    var lastPage = 0
    var currentPage: Int = 0 {
        didSet {
            //一个微小的动画移动提示条
            let offset = self.view.bounds.width / 2.0 * CGFloat(currentPage)
            UIView.animate(withDuration: 0.3) { () -> Void in
                self.sliderImageView.frame.origin = CGPoint(x: offset, y: -1)
            }
            
            //根据currentPage 和 lastPage的大小关系，控制页面的切换方向
            if currentPage > lastPage {
                self.pageViewController.setViewControllers([controllers[currentPage]], direction: .forward, animated: true, completion: nil)
            }
            else {
                self.pageViewController.setViewControllers([controllers[currentPage]], direction: .reverse, animated: true, completion: nil)
            }
            
            lastPage = currentPage
            
            if currentPage == self.consignPendingButton.tag - 100 {
                self.consignPendingButton.setTitleColor(systemTintColor, for: .normal)
                self.consignHistoryButton.setTitleColor(UIColor.darkGray, for: .normal)
            } else {
                self.consignPendingButton.setTitleColor(UIColor.darkGray, for: .normal)
                self.consignHistoryButton.setTitleColor(systemTintColor, for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configTitleLabelByText(title: "托运")
        
        pageViewController = self.childViewControllers.first as! UIPageViewController
        pendingList = storyboard?.instantiateViewController(withIdentifier: "vcConsignPendingList") as! VCConsignPendingList
        historyList = storyboard?.instantiateViewController(withIdentifier: "vcConsignHistoryList") as! VCConsignHistoryList
        
        //设置pageViewController的数据源代理为当前Controller
        pageViewController.dataSource = self
        
        //手动为pageViewController提供提一个页面
        pageViewController.setViewControllers([pendingList], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        
        //把页面添加到数组中
        controllers.append(pendingList)
        controllers.append(historyList)
        
        //添加提示条到页面中
        sliderImageView = UIImageView(frame: CGRect(x: 0, y: -1, width: self.view.frame.width / 2.0, height: 2.0))
        sliderImageView.backgroundColor = systemTintColor
        self.tabbarView.addSubview(sliderImageView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(VCConsignListPage.currentPageChanged(notification:)), name: NSNotification.Name(rawValue: "currentPageChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(VCConsignListPage.gotoOtherPage(notification:)), name: NSNotification.Name(rawValue: "gotoOtherPage"), object: nil)
    }
    
    /// 点击tab按钮切换页面
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func changePage(_ sender: UIButton) {
        currentPage = sender.tag - 100
    }
    
    /// 当前页面变更通知，用于手势变更页面时做一些改变
    ///
    /// - Parameter notification: <#notification description#>
    func currentPageChanged(notification: NSNotification) {
        currentPage = notification.object as! Int
    }
    
    /// 跳转到其他页面
    ///
    /// - Parameter notification: <#notification description#>
    func gotoOtherPage(notification: NSNotification) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "other")
        self.present(vc, animated: true)
    }
}

extension VCConsignListPage: UIPageViewControllerDataSource {
    //返回当前页面的下一个页面
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKind(of: VCConsignPendingList.classForCoder()) {
            return historyList
        }
        return nil
        
    }
    
    //返回当前页面的上一个页面
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKind(of: VCConsignHistoryList.classForCoder()) {
            return pendingList
        }
        return nil
    }
}
