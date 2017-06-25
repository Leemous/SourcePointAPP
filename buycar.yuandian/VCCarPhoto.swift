//
//  VCCarPhoto.swift
//  
//  收车和监销的车辆照片列表界面
//
//  Created by 姬鹏 on 2017/3/24.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import UIKit
import Alamofire

class VCCarPhoto: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var carInfoView: UIView!
    @IBOutlet weak var lisenceLabel: UILabel!
    @IBOutlet weak var frameLabel: UILabel!
    
    var cpc: CVCarPhotoCollection!
    
    var pickedPhoto: UIImage!
    var pickedIndex: Int!

    var carPhotoDelegate = CarPhotoDelegate()

    var cameraPicker: UIImagePickerController!
    var photoPicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configTitleLabelByText(title: self.carPhotoDelegate.photoTitle)

        self.initView()
        
        self.cameraPicker = self.initCameraPicker()
        self.cameraPicker.delegate = self
        self.photoPicker = self.initPhotoPicker()
        self.photoPicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func initView() {
        // 初始化标签值
        self.lisenceLabel.text = self.carPhotoDelegate.lisenceNo
        self.frameLabel.text = self.carPhotoDelegate.frameNo
        
        // 初始化照片collection view
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.itemSize = CGSize(width: (screenWidth - 2)/3, height: 106)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        self.cpc = CVCarPhotoCollection(frame: CGRect(x: 0, y: 97, width: screenWidth, height:  screenHeight - 161), collectionViewLayout: layout)
        self.cpc.isScrollEnabled = true
        self.cpc.alwaysBounceVertical = true
        self.cpc.backgroundColor = textInTintColor

        self.cpc.delegate = self
        
        self.cpc.carPhotoCollectionDelegate.originPhotoCount = self.carPhotoDelegate.carPhotos.count
        self.cpc.carPhotoCollectionDelegate.carPhotos = self.carPhotoDelegate.carPhotos
        self.cpc.carPhotoCollectionDelegate.uploadCount = 0
        self.cpc.carPhotoCollectionDelegate.successCount = 0
        self.cpc.carPhotoCollectionDelegate.failedCount = 0
        self.cpc.carPhotoCollectionDelegate.uploadedFileUrls = [String]()
        
        // 计算collection view的实际高度
        self.view.addSubview(self.cpc)
        
        // 设置右上角的barButtonItem
        let saveButton = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(VCCarPhoto.saveCarPhoto(_:)))
        self.navigationItem.rightBarButtonItem = saveButton
    }

    func saveCarPhoto(_ sender: UIViewController) {
        // 请求七牛云
        let qiniu = Qiniu()
        qiniu.getConfig { (status: ReturnedStatus, msg: String?, qn: Qiniu?) in
            switch status {
            case .normal:
                // 上传并保存图片
                let currentDate = Date()
                let datePrefix = convertDateToCNDateFormat(currentDate)
                let filePrefix = "_" + self.carPhotoDelegate.lisenceNo + "_"
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
                sender.alert(viewToBlock: nil, msg: msg!)
            case .noConnection:
                sender.alert(viewToBlock: nil, msg: msg!)
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
            savePhotoUrls()
        }
    }
    
    func savePhotoUrls() {
        // 保存到服务器
        var router: Router!
        if self.carPhotoDelegate.seekFor == .forPurchase {
            router = Router.addCollectPhoto(self.carPhotoDelegate.carId, self.cpc.carPhotoCollectionDelegate.uploadedFileUrls)
        } else {
            router = Router.addSupervisedPhoto(self.carPhotoDelegate.carId, self.cpc.carPhotoCollectionDelegate.uploadedFileUrls)
        }
        Alamofire.request(router).responseJSON { response in
            if (response.result.isSuccess) {
                // 请求成功
                if let jsonValue = response.result.value {
                    let json = JSON(jsonValue)
                    let code = json["code"].int
                    let msg = json["msg"].string!
                    if (code == 1) {
                        self.performSegue(withIdentifier: "backToSeekForPhoto", sender: self)
                    } else {
                        self.alert(viewToBlock: nil, msg: msg)
                    }
                } else {
                    self.alert(viewToBlock: nil, msg: "服务器开小差了，请稍后再试")
                }
            } else {
                self.alert(viewToBlock: nil, msg: msgNoConnection)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToSeekForPhoto" && self.cpc.carPhotoCollectionDelegate.failedCount > 0 {
            let target = segue.destination as! VCSeekForPhoto
            target.uploadResultMsg = "\(self.cpc.carPhotoCollectionDelegate.failedCount)张照片上传失败"
        }
    }
}

extension VCCarPhoto: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CVCCarPhotoCell

        self.pickedIndex = indexPath.item
        if cell.setted {
            cell.setItem(UIImage(named: "defaultCatchImage")!, setted: false)

            // 更新照片数组
            self.cpc.carPhotoCollectionDelegate.carPhotos.remove(at: pickedIndex)
            collectionView.reloadData()
            
        } else if self.pickedIndex == self.cpc.carPhotoCollectionDelegate.carPhotos.count {
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

class CarPhotoDelegate {
    var seekFor: SeekForType!
    var carId: String!
    var carNo: String?
    var photoTitle: String!
    var lisenceNo: String!
    var frameNo: String!
    var carPhotos: [UIImage]!
}

























