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

class VCCarPurchase: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var carInfoTable: UITableView!
    
    var cps = CarPurchase()
    var cis = [CheckItem]()
    
    var hv: VCarInfoView!
    var cpc: CVCarPhotoCollection!
    var lv: UIView!

    // 创建一个作为header的容器view
    var headerView: UIView!

    var cameraPicker: UIImagePickerController!
    var photoPicker: UIImagePickerController!

    var pickedPhoto: UIImage!
    var pickedIndex: Int!
    
    var layer: VLayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configTitleLabelByText(title: "收车")
        
        initView()
        launchData()
        
        self.cameraPicker = initCameraPicker()
        self.cameraPicker.delegate = self
        self.photoPicker = initPhotoPicker()
        self.photoPicker.delegate = self
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
        self.headerView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 0))
        self.headerView.backgroundColor = heavyBackgroundColor

        // 初始化header view的第一段
        self.hv = VCarInfoView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 408))
        self.hv.backgroundColor = UIColor.white
        self.headerView.addSubview(self.hv)

        // 初始化header view的第二段
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.itemSize = CGSize(width: (screenWidth - 2)/3, height: 106)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.headerReferenceSize = CGSize(width: screenWidth, height: 30)
        self.cpc = CVCarPhotoCollection(frame: CGRect(x: 0, y: 418, width: screenWidth, height: 146), collectionViewLayout: layout)
        self.cpc.backgroundColor = UIColor.white
        self.cpc.isScrollEnabled = false
        self.cpc.delegate = self

        // 计算collection view的实际高度
        self.cpc.frame.size.height += self.cpc.getNeedAddedHeight(availableImageNumber: 1)
        self.headerView.addSubview(self.cpc)
        
        // 添加一个显示“车况检查”的label
        
        self.lv = UIView(frame: CGRect(x: 0, y: 408 + self.cpc.frame.size.height + 20 , width: screenWidth, height: 45))
        self.lv.backgroundColor = UIColor.white
        self.headerView.addSubview(self.lv)
        
        let lbl = UILabel(frame: CGRect(x: 15, y: 5, width: 100, height: 25))
        lbl.backgroundColor = UIColor.white
        lbl.font = textFont
        lbl.textColor = systemTintColor
        lbl.text = "车况检查"
        self.lv.addSubview(lbl)
        
        self.headerView.frame.size.height = hv.frame.size.height + self.cpc.frame.size.height + 55
        
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
        
        // 遮罩层
        self.layer = VLayerView(layerMessage: "正在保存数据...")
    }
    
    private func launchData() {
        // 如果是查看收车信息，则在此处查询车辆信息
        
        // 可以设置数据
        self.hv.carInfoViewDelegate.lisenceNo = ""
        self.hv.carInfoViewDelegate.frameNo = ""
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
        if checkEmpty(textfield: self.hv.lisenceText as UITextField) {
            self.alert(viewToBlock: nil, msg: "请输入车牌号")
            return
        }
        
        if checkEmpty(textfield: self.hv.frameText as UITextField) {
            self.alert(viewToBlock: nil, msg: "请输入车架号")
            return
        }
        
        if !checkEmpty(textfield: self.hv.scrapValueText as UITextField, escapeWhitespace: true) && !checkNumber(textfield: self.hv.scrapValueText as UITextField) {
            self.alert(viewToBlock: nil, msg: "残值只能输入数字")
            return
        }
        
        // 显示遮罩层
        self.view.addSubview(self.layer)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        // 上传图片到七牛
        if self.cpc.carPhotoCollectionDelegate.carPhotos.count > 0 {
            uploadPhoto()
        } else {
            saveData()
        }
    }
    
    
    /// TODO 需要将此方法和VCCarPhoto.swift中的savePhoto抽象成一个方法
    func uploadPhoto() {
        // 请求七牛云
        let qiniu = Qiniu()
        qiniu.getConfig { (status: ReturnedStatus, msg: String?, qn: Qiniu?) in
            switch status {
            case .normal:
                // 上传并保存图片
                let currentDate = Date()
                let datePrefix = convertDateToCNDateFormat(currentDate)
                let filePrefix = "_" + self.hv.lisenceText.text! + "_"
                let util = QNUploadUtil()
                util.setToken(qn!.uptoken)
                self.cpc.carPhotoCollectionDelegate.uploadCount = self.cpc.carPhotoCollectionDelegate.carPhotos.count - self.cpc.carPhotoCollectionDelegate.originPhotoCount
                
                for i in 0..<self.cpc.carPhotoCollectionDelegate.uploadCount {
                    let uploadImgIndex = i + self.cpc.carPhotoCollectionDelegate.originPhotoCount
                    let imgData = UIImageJPEGRepresentation(self.cpc.carPhotoCollectionDelegate.carPhotos[uploadImgIndex], 0.8)
                    util.upload(imgData, fileName: datePrefix + "/" + filePrefix + "\(self.getTimeStamp())" + "_" + "\(self.getRandomSuffix(length: 5))", uploadFinish: {
                        (isSuccess: String!, fileKey: String!) -> Void in
                        self.checkUpload(isSuccess: isSuccess == "1", fileKey: qn!.urlPrefix + fileKey)
                    })
                }
            case .noData:
                self.alert(viewToBlock: nil, msg: msg!)
            case .noConnection:
                self.alert(viewToBlock: nil, msg: msg!)
            default:
                break
            }
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        
        //获得照片
        self.pickedPhoto = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.cpc.carPhotoCollectionDelegate.carPhotos.append(pickedPhoto)

        // 重新计算table header view的高度
        let addedH = self.cpc.getNeedAddedHeight(availableImageNumber: self.cpc.carPhotoCollectionDelegate.carPhotos.count)
        self.cpc.frame.size.height += addedH
        self.headerView.frame.size.height += addedH
        self.lv.frame.origin.y += addedH
        self.carInfoTable.tableHeaderView = self.headerView
        
        self.cpc.reloadData()
    }
    
    func checkUpload(isSuccess: Bool!, fileKey: String!) {
        if (isSuccess) {
            self.cpc.carPhotoCollectionDelegate.successCount! += 1
            self.cpc.carPhotoCollectionDelegate.uploadedFileUrls.append(fileKey)
        } else {
            self.cpc.carPhotoCollectionDelegate.failedCount! += 1
        }
        
        if (self.cpc.carPhotoCollectionDelegate.successCount + self.cpc.carPhotoCollectionDelegate.failedCount == self.cpc.carPhotoCollectionDelegate.uploadCount) {
            // TODO 全部上传完毕，清空待上传的文件
            saveData()
        }
    }
    
    func saveData() {
        // 构造数据
        var paramDict: [String : Any] = [:]
        paramDict["carNumber"] = self.hv.lisenceText.text
        paramDict["carShelfNumber"] = self.hv.frameText.text!
        paramDict["salvage"] = self.hv.scrapValueText.text!
        paramDict["forceScrappedDate"] = self.hv.forceScrappedDateText.text!
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

extension VCCarPurchase: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CVCCarPhotoCell
        
        self.pickedIndex = indexPath.item
        if cell.setted {
            cell.setItem(UIImage(named: "defaultCatchImage")!, setted: false)
            
            // 更新照片数组
            self.cpc.carPhotoCollectionDelegate.carPhotos.remove(at: pickedIndex)
            // 重新计算table header view的高度
            let removedH = self.cpc.getNeedRemovedHeight(availableImageNumber: self.cpc.carPhotoCollectionDelegate.carPhotos.count)
            self.cpc.frame.size.height -= removedH
            self.headerView.frame.size.height -= removedH
            self.lv.frame.origin.y -= removedH
            self.carInfoTable.tableHeaderView = self.headerView

            collectionView.reloadData()
            
        } else {
            // 利用委托记录当前值
            if let lisenceText = self.hv.lisenceText {
                self.hv.carInfoViewDelegate.lisenceNo = lisenceText.text
            }
            
            if let frameText = self.hv.frameText {
                self.hv.carInfoViewDelegate.frameNo = frameText.text
            }
            
            if let scrapValueText = self.hv.scrapValueText {
                self.hv.carInfoViewDelegate.scrapValue = scrapValueText.text
            }
            
            if let memoText = self.hv.memoText {
                self.hv.carInfoViewDelegate.memo = memoText.text
            }
            
            self.presentAlertAction { (type: Int) in
                if type == 0 {
                    self.present(self.cameraPicker, animated: true, completion: nil)
                } else {
                    self.present(self.photoPicker, animated: true, completion: nil)
                }
            }
        }
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
            // 取消其它输入框的第一响应，弹出日期选择器
            self.hv.lisenceText.resignFirstResponder()
            self.hv.frameText.resignFirstResponder()
            self.hv.scrapValueText.resignFirstResponder()
            self.hv.memoText.resignFirstResponder()
            
            self.showDatePicker(dateField: textField as! DatePickerField, minimumDate: Date.init(timeIntervalSinceNow: 0), maximumDate: nil)
            return false
        }
        return true
    }
}

class CarPurchaseDelegate {
    var carPurchase: CarPurchase!
}



























