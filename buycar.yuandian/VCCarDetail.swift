//
//  VCCarDetail.swift
//  buycar.yuandian
//  车辆详细信息页面
//  Created by 李萌 on 2017/11/8.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import UIKit
import SwiftyJSON

class VCCarDetail: UIViewController {
    
    @IBOutlet weak var checkTable: TVCarCheckItemTable!
    
    var detail: [JSON]!
    
    // 创建一个作为header的容器view
    var headerView: UIView!
    var baseView: VCarTextGroupsView!
    var statusView: VCarTextGroupsView!
    var photoCollection: CVCarPhotoCollection!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configTitleLabelByText(title: "车辆信息")
        
        // 守卫代码，保证页面正常绘制不闪退
        guard detail != nil else {
            return
        }
        
        self.initView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func initView() {
        // 基础信息
        var baseDetail: JSON!
        // 状态信息
        var statusDetail: JSON!
        // 车况检查
        var checkDetail: JSON!
        // 照片信息
        var photoDetail: JSON!
        
        // 把查询结果按类型区分
        for item in detail {
            switch item["type"] {
            case "base":
                baseDetail = item
                break
            case "check":
                checkDetail = item
                break
            case "status":
                statusDetail = item
                break
            case "photo":
                photoDetail = item
            default:
                break
            }
        }
        
        // 初始化头部视图
        self.headerView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 0))
        self.headerView.backgroundColor = heavyBackgroundColor
        
        /********************************设置基础信息********************************/
        // 添加一个显示标题的label
        let lvBaseTitle = VTextGroupTitleView(frame: CGRect(x: 0, y: self.headerView.frame.size.height, width: screenWidth, height: 35), titleText: baseDetail["title"].stringValue, drawSeparatorLine: true)
        lvBaseTitle.backgroundColor = UIColor.white
        self.headerView.addSubview(lvBaseTitle)
        self.headerView.frame.size.height += 35
        
        // 构造基础信息数据源
        let baseContent = baseDetail["content"].arrayValue
        var baseGroups = [TextGroup]()
        for content in baseContent {
            let tg = TextGroup(content["label"].stringValue, content["text"].stringValue)
            baseGroups.append(tg)
        }
        let baseTextGroupView = VCarTextGroupsView(frame: CGRect(x: 0, y: self.headerView.frame.size.height, width: screenWidth, height: 0), drawBottomSeparator: false)
        baseTextGroupView.backgroundColor = UIColor.white
        baseTextGroupView.tgs = baseGroups
        baseTextGroupView.frame.size.height = baseTextGroupView.calculateTotalHeight()
        self.headerView.addSubview(baseTextGroupView)
        self.headerView.frame.size.height += baseTextGroupView.frame.size.height + 10
        /********************************设置基础信息********************************/
        
        /********************************设置状态信息********************************/
        // 添加一个显示标题的label
        let lvStatusTitle = VTextGroupTitleView(frame: CGRect(x: 0, y: self.headerView.frame.size.height, width: screenWidth, height: 35), titleText: statusDetail["title"].stringValue, drawSeparatorLine: true)
        lvStatusTitle.backgroundColor = UIColor.white
        self.headerView.addSubview(lvStatusTitle)
        self.headerView.frame.size.height += 35
        
        // 构造状态信息数据源
        let statusContent = statusDetail["content"].arrayValue
        var statusGroups = [TextGroup]()
        for content in statusContent {
            let tg = TextGroup(content["label"].stringValue, content["text"].stringValue)
            statusGroups.append(tg)
        }
        let statusTextGroupView = VCarTextGroupsView(frame: CGRect(x: 0, y: self.headerView.frame.size.height, width: screenWidth, height: 0), drawBottomSeparator: false)
        statusTextGroupView.backgroundColor = UIColor.white
        statusTextGroupView.tgs = statusGroups
        statusTextGroupView.frame.size.height = statusTextGroupView.calculateTotalHeight()
        self.headerView.addSubview(statusTextGroupView)
        self.headerView.frame.size.height += statusTextGroupView.frame.size.height + 10
        /********************************设置状态信息********************************/
        
        /********************************设置收车照片信息********************************/
        // 添加一个显示标题的label
        let lvPhotoTitle = VTextGroupTitleView(frame: CGRect(x: 0, y: self.headerView.frame.size.height, width: screenWidth, height: 35), titleText: photoDetail["content"][0]["label"].stringValue, drawSeparatorLine: true)
        lvPhotoTitle.backgroundColor = UIColor.white
        self.headerView.addSubview(lvPhotoTitle)
        self.headerView.frame.size.height += 35
        
        // 照片布局及展示
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.itemSize = CGSize(width: (screenWidth - 2)/3, height: 106)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        self.photoCollection = CVCarPhotoCollection(frame: CGRect(x: 0, y: self.headerView.frame.size.height, width: screenWidth, height: 106), collectionViewLayout: layout)
        self.photoCollection.backgroundColor = UIColor.white
        self.photoCollection.isScrollEnabled = false
        
        var photoUrls = photoDetail["content"][0]["urls"].arrayValue
        var images = [UIImage]()
        for i in 0..<photoUrls.count {
            let urlString = photoUrls[i].stringValue
            let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            
            let data = try! Data(contentsOf: url!)
            let image = UIImage(data: data)
            images.append(image!)
        }
        self.photoCollection.carPhotoCollectionDelegate.allowAdd = false
        self.photoCollection.carPhotoCollectionDelegate.carPhotos = images
        self.photoCollection.carPhotoCollectionDelegate.originPhotoCount = images.count
        self.headerView.addSubview(photoCollection)
        
        // 计算collection view的实际高度
        self.photoCollection.frame.size.height += self.photoCollection.getNeedAddedHeight(availableImageNumber: 1)
        self.headerView.addSubview(self.photoCollection)
        self.headerView.frame.size.height += self.photoCollection.frame.size.height + 10
        /********************************设置收车照片信息********************************/
        
        /********************************设置车况检查信息********************************/
        // 添加一个显示标题的label
        let lvCheckTitle = VTextGroupTitleView(frame: CGRect(x: 0, y: self.headerView.frame.size.height, width: screenWidth, height: 35), titleText: checkDetail["title"].stringValue)
        lvCheckTitle.backgroundColor = UIColor.white
        self.headerView.addSubview(lvCheckTitle)
        self.headerView.frame.size.height += 35
        
        let checkContent = checkDetail["content"].arrayValue
        var cis = [CheckItem]()
        for content in checkContent {
            let ci = CheckItem()
            ci.itemOptions = [CheckItemOption]()
            ci.itemName = content["label"].stringValue
            
            for option in content["options"].arrayValue {
                ci.itemOptions.append(CheckItemOption(optionKey: option["label"].stringValue, optionName: option["label"].stringValue, isDefault: option["checked"].boolValue))
            }
            cis.append(ci)
        }
        self.checkTable.cis = cis
        self.checkTable.tableHeaderView = self.headerView
        /********************************设置车况检查信息********************************/
    }
}
