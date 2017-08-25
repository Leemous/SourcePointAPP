//
//  VCHome.swift
//
//  首页的view controller，对应的storyboard是Main
//
//  Created by 姬鹏 on 2017/3/20.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import UIKit

private let featureCell = "featureCell"
private let carPurchaseCell = "carPurchaseCell"

class VCHome: UIViewController {

    @IBOutlet weak var featureCollection: UICollectionView!
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var carTable: UITableView!

    var cps = [CarPurchase]()
    var refreshCarTableControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configTitleLabelByText(title: "源点-新能")

        initView()
        launchData()
        
        refreshCarTableControl.addTarget(self, action: #selector(VCHome.refreshData), for: .valueChanged)
        refreshCarTableControl.attributedTitle = NSAttributedString(string: "下拉刷新数据")
        self.carTable.addSubview(refreshCarTableControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func initView() {
        // 设置顶端四个功能按钮
        self.featureCollection.dataSource = self
        self.featureCollection.delegate = self
        
        // 设置collection view的layout属性
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.itemSize = CGSize(width: (screenWidth - 5)/5, height: 124)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        self.featureCollection.collectionViewLayout = layout

        // 设置collection自身的属性
        self.featureCollection.isScrollEnabled = false
        self.featureCollection.backgroundColor = textInTintColor

        // 注册功能区Cell
        self.featureCollection.register(UINib(nibName: "FeatureCell", bundle: nil), forCellWithReuseIdentifier: featureCell)
        
        // 设置右上角的barButtonItem
        let myAccountButton = UIBarButtonItem(image: UIImage(named: "myAccountImage"), style: .plain, target: self, action: #selector(VCHome.goMyAccount(_:)))
        
        self.navigationItem.rightBarButtonItem = myAccountButton
        self.navigationItem.rightBarButtonItem!.imageInsets = UIEdgeInsetsMake(3, 0, 0, 0)
    }
    
    func launchData(completion: (() -> Swift.Void)? = nil) {
        // 设置收车列表数据
        let cp = CarPurchase()
        cp.getAllCarPurchaseToday { (status: ReturnedStatus, msg: String?, cps: [CarPurchase]?) in
            switch status {
            case .normal:
                // 取消所有多余分隔线
                self.carTable.tableFooterView = UIView()
                
                // 设置cell的分隔线
                self.carTable.separatorInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)

                self.carTable.dataSource = self
                self.carTable.delegate = self
                
                self.carTable.register(UINib(nibName: "CarPurchaseCell", bundle: nil), forCellReuseIdentifier: carPurchaseCell)
                
                self.cps = cps!
                
                if let c = completion {
                    c()
                }
                
                // 如果之前存在无数据、无网络连接等问题，则先移除这些view
                self.removeNoConnectView(containerView: self.view)
            case .noConnection:
                self.showNoConnectionView(containerView: self.view) { _ in
                    self.launchData()
                }
                break
            case .needLogin:
                self.needsLogout()
                break
            default:
                break
            }
        }
    }
    
    /// 刷新收车列表
    func refreshData() {
        self.launchData(completion: {
            self.carTable.reloadData()
            self.refreshCarTableControl.endRefreshing()
        })
    }
    
    func goMyAccount(_ sender: AnyObject) {
        var userInfo: User!
        User().getUserInfo { (status: ReturnedStatus, msg: String?, user: User?) in
            switch status {
            case .normal:
                userInfo = user
                self.pushViewControllerFromStoryboard(storyboardName: "Main", idInStoryboard: "vcMyAccount", animated: true) { (vc: UIViewController) -> Void in
                    if let ui = userInfo {
                        let ma = vc as! VCMyAccount
                        ma.myAccountDelegate.userName = ui.userName
                        ma.myAccountDelegate.orgName = ui.orgName
                    }
                }
                self.configNavigationBackItem(sourceViewController: self)
            case .noData:
                self.alert(viewToBlock: nil, msg: msg == nil ? "未得到用户信息" : msg!)
                return
            case .needLogin:
                self.needsLogout()
                return
            case .noConnection:
                self.alert(viewToBlock: nil, msg: msgNoConnection)
                return
            default:
                return
            }
            
        }
    }
    
    @IBAction func backToHome(_ seg: UIStoryboardSegue!) {
        self.launchData(completion: {
            self.carTable.reloadData()
        })
    }
}

extension VCHome: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: featureCell, for: indexPath)

        switch indexPath.item {
        case 0:
            (cell as! CVCFeatureCell).setItem(UIImage(named: "buyCarImage")!, title: "收车")
        case 1:
            (cell as! CVCFeatureCell).setItem(UIImage(named: "carPhotoImage")!, title: "车辆拍照")
        case 2:
            (cell as! CVCFeatureCell).setItem(UIImage(named: "checkPhotoImage")!, title: "监销拍照")
        case 3:
            (cell as! CVCFeatureCell).setItem(UIImage(named: "consignImage")!, title: "托运")
        case 4:
            (cell as! CVCFeatureCell).setItem(UIImage(named: "dailyImage")!, title: "日报")
        default:
            break
        }
        
        return cell
    }
}

extension VCHome: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            self.pushViewControllerFromStoryboard(storyboardName: "Main", idInStoryboard: "vcCarPurchase", animated: true, completion: nil)
            self.configNavigationBackItem(sourceViewController: self)
        case 1:
            self.pushViewControllerFromStoryboard(storyboardName: "Main", idInStoryboard: "vcSeekForPhoto", animated: true) { (vc: UIViewController) -> Void in
                let seekForPhoto = vc as! VCSeekForPhoto
                seekForPhoto.seekForPhotoDelegate.seekFor = .forPurchase
                seekForPhoto.seekForPhotoDelegate.seekForTitle = "车辆拍照"
            }
            self.configNavigationBackItem(sourceViewController: self)
        case 2:
            self.pushViewControllerFromStoryboard(storyboardName: "Main", idInStoryboard: "vcSeekForPhoto", animated: true) { (vc: UIViewController) -> Void in
                let seekForPhoto = vc as! VCSeekForPhoto
                seekForPhoto.seekForPhotoDelegate.seekFor = .forCheck
                seekForPhoto.seekForPhotoDelegate.seekForTitle = "监销拍照"
            }
            self.configNavigationBackItem(sourceViewController: self)
        case 3:
            self.pushViewControllerFromStoryboard(storyboardName: "Main", idInStoryboard: "vcConsignDetail", animated: true, completion: nil)
            self.configNavigationBackItem(sourceViewController: self)
        case 4:
            self.pushViewControllerFromStoryboard(storyboardName: "Main", idInStoryboard: "vcDailyList", animated: true, completion: nil)
            self.configNavigationBackItem(sourceViewController: self)
        default:
            break
        }
    }
}

extension VCHome: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: carPurchaseCell, for: indexPath) as! TVCCarPurchaseCell
        
        cell.carPurchaseCellDelegate.carLisenceNo = self.cps[indexPath.row].carLicenseNo
        cell.carPurchaseCellDelegate.carFrameNo = self.cps[indexPath.row].carFrameNo
        cell.carPurchaseCellDelegate.id = self.cps[indexPath.row].id
        
        if cell.tag != 1000 {
            // 首次绘制单元格
            cell.selectionStyle = .none
        } else {
            // 重用单元格，手动设置label值
            cell.lisenceLabel.text = self.cps[indexPath.row].carLicenseNo
            cell.frameLabel.text = self.cps[indexPath.row].carFrameNo
            cell.idLabel.text = "收车编号：" + self.cps[indexPath.row].id
        }
    
        return cell
    }
}

extension VCHome: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}



























