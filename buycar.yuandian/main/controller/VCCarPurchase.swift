//
//  VCCarPurchase.swift
//
//  收车界面的view controller，对应的storyboard是Main
//
//  Created by 姬鹏 on 2017/3/23.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import UIKit
import MobileCoreServices
import Alamofire
import SwiftyJSON

private let checkItemCell = "checkItemCell"
private let checkItemHeanderCell = "checkItemHeaderCell"

class VCCarPurchase: ImagePickerViewController {
    
    @IBOutlet weak var carInfoTable: UITableView!
    
    /// 收车模型
    let carPurchaseModel = CarPurchaseModel()
    /// 车况检查数据源
    var cis = [CheckItem]()
    
    /// 收车信息视图
    var hv: VCarInfoView!
    /// 上传照片视图
    var cpc: CVCarPhotoCollection!
    /// 车况检查label
    var lv: UIView!
    
    /// 创建一个作为header的容器view
    var headerView: UIView!
    
    var layer: VLayerView!
    
    // 拍照文件标识
    private var photographTypeKey = ""
    // 行驶证拍照标识-左
    private var drivingLicenseLeftPhotoKey = "DRIVING_LICENSE_LEFT"
    // 行驶证拍照标识-右
    private var drivingLicenseRightPhotoKey = "DRIVING_LICENSE_RIGHT"
    // 其他拍照标识
    private var otherPhotoKey = "RECEIVE_OTHER_PHOTO"
    // 行驶证拍照
    private var drivingLicenseGroup: DoublePictureGroup!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configTitleLabelByText(title: "收车")
        
        initView()
        launchData()
    }
    
    
    /// 控件加载完成后所作的处理
    ///
    /// - Parameter animated:
    override func viewDidAppear(_ animated: Bool) {
        // 强制报废日期
        self.hv.forceScrappedDateText.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initView() {
        // 实例化header view
        self.headerView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 0))
        self.headerView.backgroundColor = heavyBackgroundColor
        
        // 向header view添加视图，记录y坐标的变化，作为最终高度的参考值
        var yPosition = CGFloat(0)
        // 初始化header view的第一段-行驶证拍照
        self.drivingLicenseGroup = DoublePictureGroup(frame: CGRect(x: 0, y: yPosition, width: screenWidth, height: 150), titleText: "车辆行驶证拍照", holderImageL: UIImage(named: "placeholder_driving_license_1"), pickerPictureL: { (leftImage: UIImage?) in
            if let photo = leftImage {
                // 预览行驶证左侧照片
                super.previewImage(image: photo, alpha: 0.8, deletable: true, deleteText: changeImageText, deleteCompletion: {
                    self.photographTypeKey = self.drivingLicenseLeftPhotoKey
                    super.presentImagePicker(true)
                })
            } else {
                // 车辆行驶证左侧拍照
                self.photographTypeKey = self.drivingLicenseLeftPhotoKey
                self.presentImagePicker(true)
            }
        }, holderImageR: UIImage(named: "placeholder_driving_license_2"), pickerPictureR: { (rightImage: UIImage?) in
            if let photo = rightImage {
                // 预览行驶证右侧照片
                super.previewImage(image: photo, alpha: 0.8, deletable: true, deleteText: changeImageText, deleteCompletion: {
                    self.photographTypeKey = self.drivingLicenseRightPhotoKey
                    super.presentImagePicker(true)
                })
            } else {
                // 车辆行驶证右侧拍照
                self.photographTypeKey = self.drivingLicenseRightPhotoKey
                super.presentImagePicker(true)
            }
        })
        
        self.drivingLicenseGroup.backgroundColor = .white
        self.headerView.addSubview(self.drivingLicenseGroup)
        yPosition += 150
        
        // 初始化header view的第二段-车辆信息
        self.hv = VCarInfoView(frame: CGRect(x: 0, y: yPosition, width: screenWidth, height: 450))
        self.hv.backgroundColor = UIColor.white
        self.headerView.addSubview(self.hv)
        yPosition += 450
        
        // 留出间隙
        yPosition += 10
        
        // 初始化header view的第三段-车辆拍照
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.itemSize = CGSize(width: (screenWidth - 2)/3, height: 106)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.headerReferenceSize = CGSize(width: screenWidth, height: 30)
        self.cpc = CVCarPhotoCollection(frame: CGRect(x: 0, y: yPosition, width: screenWidth, height: 146), collectionViewLayout: layout)
        self.cpc.backgroundColor = UIColor.white
        self.cpc.isScrollEnabled = false
        
        // 计算collection view的实际高度
        self.cpc.frame.size.height += self.cpc.getNeedAddedHeight(availableImageNumber: 1)
        self.headerView.addSubview(self.cpc)
        yPosition += self.cpc.frame.size.height
        
        // 留出间隙
        yPosition += 10
        
        // 添加一个显示“车况检查”的label
        self.lv = UIView(frame: CGRect(x: 0, y: yPosition, width: screenWidth, height: 45))
        self.lv.backgroundColor = UIColor.white
        self.headerView.addSubview(self.lv)
        yPosition += 45
        
        let lbl = UILabel(frame: CGRect(x: 15, y: 5, width: 100, height: 25))
        lbl.backgroundColor = UIColor.white
        lbl.font = textFont
        lbl.textColor = systemTintColor
        lbl.text = "车况检查"
        self.lv.addSubview(lbl)
        
        self.headerView.frame.size.height = yPosition
        
        self.carInfoTable.tableHeaderView = self.headerView
        
        // 设置右上角的barButtonItem
        let saveCarPurchaseButton = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(VCCarPurchase.saveCarPurchase(_:)))
        self.navigationItem.rightBarButtonItem = saveCarPurchaseButton
        
        // 原始照片数量为0
        self.cpc.carPhotoCollectionDelegate.originPhotoCount = 0
        // 待上传数量为0
        self.cpc.carPhotoCollectionDelegate.uploadCount = 0
        // 上传成功数量为0
        self.cpc.carPhotoCollectionDelegate.successCount = 0
        // 上传失败数量为0
        self.cpc.carPhotoCollectionDelegate.failedCount = 0
        // 保存的url数组为空
        self.cpc.carPhotoCollectionDelegate.uploadedFileUrls = []
        // 图片选择事件
        self.cpc.carPhotoCollectionDelegate.pickerImageClick = {
            // 利用委托记录当前值
            if let lisenceText = self.hv.licenseText {
                self.hv.carInfoViewDelegate.lisenceNo = lisenceText.text
            }
            
            if let frameText = self.hv.frameText {
                self.hv.carInfoViewDelegate.frameNo = frameText.text
            }
            
            if let modelText = self.hv.modelText {
                self.hv.carInfoViewDelegate.model = modelText.text
            }
            
            if let scrapValueText = self.hv.scrapValueText {
                self.hv.carInfoViewDelegate.scrapValue = scrapValueText.text
            }
            
            if let memoText = self.hv.memoText {
                self.hv.carInfoViewDelegate.memo = memoText.text
            }
            
            // 收车照片
            self.photographTypeKey = self.drivingLicenseRightPhotoKey
            self.presentImagePicker(true)
        }
        // 移除图片回调
        self.cpc.carPhotoCollectionDelegate.removeCallback = { (removeIndex: Int) -> Void in
            // 更新照片数组
            self.cpc.carPhotoCollectionDelegate.uploadCount! -= 1
            self.cpc.carPhotoCollectionDelegate.carPhotos.remove(at: removeIndex)
            // 重新计算table header view的高度
            let removedH = self.cpc.getNeedRemovedHeight(availableImageNumber: self.cpc.carPhotoCollectionDelegate.carPhotos.count)
            self.cpc.frame.size.height -= removedH
            self.headerView.frame.size.height -= removedH
            self.lv.frame.origin.y -= removedH
            self.carInfoTable.tableHeaderView = self.headerView
            
            self.cpc.reloadData()
        }
        
        // 遮罩层
        self.layer = VLayerView(layerMessage: "正在保存数据...")
    }
    
    private func launchData() {
        // 如果是查看收车信息，则在此处查询车辆信息
        
        // 可以设置数据
        self.hv.carInfoViewDelegate.lisenceNo = ""
        self.hv.carInfoViewDelegate.frameNo = ""
        self.hv.carInfoViewDelegate.model = ""
        self.hv.carInfoViewDelegate.scrapValue = ""
        self.hv.carInfoViewDelegate.memo = ""
        self.cpc.carPhotoCollectionDelegate.carPhotos = [UIImage]()
        
        // 如果新建收车信息，查询所有能用的检查信息
        let checkItem = CheckItem()
        checkItem.getAllCheckItems { (status: ReturnedStatus, msg: String?, cis: [CheckItem]?) in
            switch status {
            case .normal:
                self.cis = cis!
                
                self.carInfoTable.dataSource = self
                self.carInfoTable.delegate = self
                
                self.carInfoTable.separatorInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
                
                self.carInfoTable.register(UINib(nibName: "CheckItemCell", bundle: nil), forCellReuseIdentifier: checkItemCell)
                self.carInfoTable.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: checkItemHeanderCell)
            case .needLogin:
                self.needsLogout()
                break
            case .noData:
                // XXXX
                break
            case .noConnection:
                self.alert(viewToBlock: nil, msg: msgNoConnection)
                break
            default:
                break
            }
        }
    }
    
    func saveCarPurchase(_ sender: UIViewController) {
        if checkEmpty(textfield: self.hv.licenseText as UITextField) {
            self.alert(viewToBlock: nil, msg: "请输入车牌号")
            return
        }
        
        if checkEmpty(textfield: self.hv.frameText as UITextField) {
            self.alert(viewToBlock: nil, msg: "请输入车架号")
            return
        }
        
        if checkEmpty(textfield: self.hv.scrapValueText as UITextField) {
            self.alert(viewToBlock: nil, msg: "请输入残值")
            return
        } else if !checkNumber(textfield: self.hv.scrapValueText as UITextField) {
            self.alert(viewToBlock: nil, msg: "残值只能输入数字")
            return
        }
        
        // 显示遮罩层
        self.view.addSubview(self.layer)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        // 上传图片到七牛
        if self.cpc.carPhotoCollectionDelegate.uploadCount > 0 {
            uploadPhoto()
        } else {
            saveData()
        }
    }
    
    /// TODO 需要将此方法和VCCarPhoto.swift中的savePhoto抽象成一个方法
    func uploadPhoto() {
        // 需要上传的图片
        var toUploadImages = [Data]()
        for i in 0..<self.cpc.carPhotoCollectionDelegate.uploadCount {
            let uploadImgIndex = i + self.cpc.carPhotoCollectionDelegate.originPhotoCount
            if let data = UIImageJPEGRepresentation(self.cpc.carPhotoCollectionDelegate.carPhotos[uploadImgIndex], 0.8) {
                toUploadImages.append(data)
            }
        }
        // 上传文件并保存url到服务器
        let qiniu = Qiniu()
        qiniu.uploadFiles(self, fileIdentifier: self.hv.licenseText.text!, files: toUploadImages) { (isSuccess: Bool, fileUrl: String) in
            let success = isSuccess
            if success {
                self.cpc.carPhotoCollectionDelegate.successCount! += 1
                self.cpc.carPhotoCollectionDelegate.originPhotoCount! += 1
                self.cpc.carPhotoCollectionDelegate.uploadedFileUrls.append(fileUrl)
            } else {
                self.cpc.carPhotoCollectionDelegate.failedCount! += 1
            }
            
            if (self.cpc.carPhotoCollectionDelegate.successCount + self.cpc.carPhotoCollectionDelegate.failedCount == self.cpc.carPhotoCollectionDelegate.uploadCount) {
                // 避免再次上传
                self.cpc.carPhotoCollectionDelegate.uploadCount = 0
                self.saveData()
            }
        }
    }
    
    /// 选择图片或拍照后的回调
    ///
    /// - Parameters:
    ///   - picker: 图片选择器
    ///   - info: 返回信息
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        
        // 获得照片
        let pickedPhoto = (info[UIImagePickerControllerOriginalImage] as! UIImage)
        
        if self.otherPhotoKey == self.photographTypeKey {
            self.cpc.carPhotoCollectionDelegate.uploadCount! += 1
            self.cpc.carPhotoCollectionDelegate.carPhotos.append(pickedPhoto)
            
            // 重新计算table header view的高度
            let addedH = self.cpc.getNeedAddedHeight(availableImageNumber: self.cpc.carPhotoCollectionDelegate.carPhotos.count)
            self.cpc.frame.size.height += addedH
            self.headerView.frame.size.height += addedH
            self.lv.frame.origin.y += addedH
            self.carInfoTable.tableHeaderView = self.headerView
            
            self.cpc.reloadData()
        } else {
            // 行驶证拍照，上传照片，记录图片url
            // 压缩图片
            if let pickedPhotoData = UIImageJPEGRepresentation(pickedPhoto, 0.8) {
                self.showLayer(layerMessage: "正在上传图片...")
                let qiniu = Qiniu()
                qiniu.uploadFiles(self, fileIdentifier: self.photographTypeKey, files: [pickedPhotoData]) { (isSuccess: Bool, fileUrl: String) in
                    self.hideLayer()
                    if isSuccess {
                        if self.drivingLicenseLeftPhotoKey == self.photographTypeKey {
                            self.drivingLicenseGroup.leftImage = pickedPhoto
                            self.carPurchaseModel.drivingLicenseFrontUrl = fileUrl
                        } else if self.drivingLicenseRightPhotoKey == self.photographTypeKey {
                            self.drivingLicenseGroup.rightImage = pickedPhoto
                            self.carPurchaseModel.drivingLicenseBackUrl = fileUrl
                        }
                        // TODO 行驶证信息识别
                    } else {
                        // 上传失败
                        self.showLayer(layerMessage: "上传行驶证照片失败")
                    }
                }
            }
        }
    }
    
    /// 保存收车信息
    private func saveData() {
        // 构造数据
        var paramDict: [String : Any] = [:]
        paramDict["drivingLicenseFrontUrl"] = self.carPurchaseModel.drivingLicenseFrontUrl
        paramDict["drivingLicenseBackUrl"] = self.carPurchaseModel.drivingLicenseBackUrl
        paramDict["carNumber"] = self.hv.licenseText.text
        paramDict["carShelfNumber"] = self.hv.frameText.text
        paramDict["carModelName"] = self.hv.modelText.text
        paramDict["salvage"] = self.hv.scrapValueText.text
        paramDict["forceScrappedDate"] = self.hv.forceScrappedDateText.text
        paramDict["remark"] = self.hv.memoText.text!
        for ci in cis {
            paramDict[ci.itemKey] = ci.itemOptions[ci.optionAnswer].optionKey
        }
        paramDict["urls"] = JSON(cpc.carPhotoCollectionDelegate.uploadedFileUrls)
        // 保存到服务器
        Alamofire.request(Router.addPurchase(paramDict)).responseJSON { response in
            if self.layer.superview != nil {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.layer.removeFromSuperview()
            }
            if (response.result.isSuccess) {
                // 请求成功
                if let jsonValue = response.result.value {
                    let json = JSON(jsonValue)
                    let code = json["code"].int
                    let msg = json["msg"].string!
                    if (code == 1) {
                        // 保存成功，返回首页
                        self.performSegue(withIdentifier: "backToHome", sender: self)
                    } else {
                        self.alert(viewToBlock: nil, msg: msg)
                    }
                } else {
                    self.alert(viewToBlock: nil, msg: "保存车辆信息失败")
                }
            } else {
                self.alert(viewToBlock: nil, msg: msgNoConnection)
            }
        }
    }
    
    /// 展示遮罩层
    ///
    /// - Parameter layerMessage: 遮罩层消息
    private func showLayer(layerMessage: String) {
        // 遮罩层
        self.layer = VLayerView(layerMessage: layerMessage)
        // 显示遮罩层
        self.view.addSubview(self.layer)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    /// 隐藏遮罩层
    private func hideLayer() {
        if self.layer != nil {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.layer.removeFromSuperview()
        }
    }
}

extension VCCarPurchase: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.cis.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cis[section].itemOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: checkItemCell, for: indexPath) as! TVCCheckItemCell
        
        cell.selectionStyle = .none
        
        cell.itemName.text = self.cis[indexPath.section].itemOptions[indexPath.row].optionName
        // 如果选项存在值，则设置值
        if let a = self.cis[indexPath.section].optionAnswer {
            if a == indexPath.row {
                cell.checkedImage.image = UIImage(named: "checkedImage")
            } else {
                cell.checkedImage.image = UIImage(named: "uncheckedImage")
            }
        } else {
            // 如果选项不存在值，则赋缺省值
            if self.cis[indexPath.section].itemOptions[indexPath.row].isDefault {
                cell.checkedImage.image = UIImage(named: "checkedImage")
            } else {
                cell.checkedImage.image = UIImage(named: "uncheckedImage")
            }
        }
        
        return cell
    }
}

extension VCCarPurchase: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let h = tableView.dequeueReusableHeaderFooterView(withIdentifier: checkItemHeanderCell)
        
        h!.backgroundView = UIView()
        h!.contentView.backgroundColor = UIColor.white
        
        var qlbl = h!.contentView.viewWithTag(1001) as? UILabel
        if qlbl == nil {
            // 添加一个文本框
            qlbl = UILabel()
            qlbl!.tag = 1001
            h!.contentView.addSubview(qlbl!)
        }
        
        qlbl!.translatesAutoresizingMaskIntoConstraints = false
        h!.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-18-[hil]", options: .alignAllCenterY, metrics: nil, views: ["hil": qlbl!]))
        h!.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-9-[hil]", options: .alignAllCenterY, metrics: nil, views: ["hil":qlbl!]))
        
        qlbl!.tag = 1001
        qlbl!.font = textFont
        qlbl!.textColor = mainTextColor
        qlbl!.text = self.cis[section].itemName
        
        // 在底部添加一个下划线
        let hline1 = UIView()
        h!.contentView.addSubview(hline1)
        
        hline1.translatesAutoresizingMaskIntoConstraints = false
        h!.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[hline1]|", options: [], metrics: nil, views: ["hline1": hline1]))
        h!.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[hline1(1)]", options: [], metrics: nil, views: ["hline1": hline1]))
        
        hline1.backgroundColor = separatorLineColor
        
        return h
    }
    
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        self.cis[indexPath.section].optionAnswer = indexPath.row
        self.carInfoTable.reloadData()
        return nil
    }
}

// MARK: - 自定义文本输入框委托
extension VCCarPurchase: UITextFieldDelegate {
    /// 重写文本输入框委托方法，是否开始编辑文本
    ///
    /// - Parameter textField: 文本输入框
    /// - Returns: 返回true成为第一响应项，显示键盘开始编辑，返回false，无法获得焦点
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField is DatePickerField) {
            // 结束当前视图正在进行的编辑
            self.view.endEditing(true)
            
            self.showDatePicker(dateField: textField as! DatePickerField, minimumDate: Date.init(timeIntervalSinceNow: 0), maximumDate: nil)
            return false
        }
        return true
    }
}

/// 收车模型
class CarPurchaseModel {
    /// 行驶证正面url
    var drivingLicenseFrontUrl: String?
    /// 行驶证背面url
    var drivingLicenseBackUrl: String?
}
