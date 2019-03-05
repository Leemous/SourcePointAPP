//
//  VCCarDetail.swift
//  buycar.yuandian
//  车辆详细信息页面
//  Created by 李萌 on 2017/11/8.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import UIKit
import SwiftyJSON

class VCCarDetail: ImagePickerViewController {
    
    @IBOutlet weak var checkTable: TVCarCheckItemTable!
    
    var detail: [JSON]!
    
    // 创建一个作为header的容器view
    var headerView: UIView!
    var baseView: VCarTextGroupsView!
    var statusView: VCarTextGroupsView!
    var photoCollection: CVCarPhotoCollection!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 守卫代码，保证页面正常绘制不闪退
        guard detail != nil else {
            return
        }
        
        self.initView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //发送一个名字为currentPageChanged，附带object的值代表当前页面的索引
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "carDetailPageChanged"), object: 0)
    }
    
    private func initView() {
        // 行驶证照片信息
        var drivingLicensePhotoDetail: JSON!
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
            case "drivingLicensePhoto":
                drivingLicensePhotoDetail = item
                break
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
        
        /********************************设置行驶证照片********************************/
        if let detial = drivingLicensePhotoDetail {
            // 添加一个显示标题的label
            let lvBaseTitle = VTextGroupTitleView(frame: CGRect(x: 0, y: self.headerView.frame.size.height, width: screenWidth, height: 35), titleText: drivingLicensePhotoDetail["title"].stringValue, drawSeparatorLine: true)
            lvBaseTitle.backgroundColor = UIColor.white
            self.headerView.addSubview(lvBaseTitle)
            self.headerView.frame.size.height += 35
            
            // 初始化行驶证拍照
            let drivingLicenseGroup = DoublePictureGroup(frame: CGRect(x: 0, y: self.headerView.frame.size.height, width: screenWidth, height: 120), titleText: "", holderImageL: UIImage(named: "placeholder_driving_license_1"), pickerPictureL: { (leftmage: UIImage?) in
                if let photo = leftmage {
                    // 预览行驶证左侧照片
                    super.previewImage(image: photo, alpha: 0.8)
                }
            }, holderImageR: UIImage(named: "placeholder_driving_license_2"), pickerPictureR: { (rightImage: UIImage?) in
                if let photo = rightImage {
                    // 预览行驶证右侧照片
                    super.previewImage(image: photo, alpha: 0.8)
                }
            })
            drivingLicenseGroup.backgroundColor = .white
            self.headerView.addSubview(drivingLicenseGroup)
            self.headerView.frame.size.height += 120
            
            // 构造车辆行驶证数据源
            let drivingLicensePhotoContent = detial["content"].arrayValue
            for content in drivingLicensePhotoContent {
                if let data = try? Data(contentsOf: URL(string: content["url"].stringValue)!) {
                    if content["type"] == "drivingLicenseFront" {
                        drivingLicenseGroup.leftImage = UIImage(data: data)
                    } else if content["type"] == "drivingLicenseBack" {
                        drivingLicenseGroup.rightImage = UIImage(data: data)
                    }
                }
            }
        }
        /********************************设置行驶证照片********************************/
        
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
