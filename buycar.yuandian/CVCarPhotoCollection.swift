//
//  CVCarPhotoCollection.swift
//
//  显示和添加车辆照片的collection view
//
//  Created by 姬鹏 on 2017/3/23.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import UIKit

private let carPhotoCell = "carPhotoCell"
private let carPhotoHeader = "carPhotoHeader"

class CVCarPhotoCollection: UICollectionView {
    
    var carPhotoCollectionDelegate = CarPhotoCollectionDelegate()
    
    override func draw(_ rect: CGRect) {
        self.dataSource = self
        
        // 注册collection view头
        self.register(UINib(nibName: "CarPhotoHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: carPhotoHeader)
        
        // 注册功能区Cell
        self.register(UINib(nibName: "CarPhotoCell", bundle: nil), forCellWithReuseIdentifier: carPhotoCell)
    }
    
    // 得到collection view的最新高度，该方法用于在收车界面计算collection view需要加高多少高度，每个单元格高度为106
    func getNeedAddedHeight(availableImageNumber n: Int) -> CGFloat {
        if n == 0 {
            return 0
        }
        
        switch n % 3 {
        case 1, 2: // 余数为1或2时，说明一行不满，不必加高度
            return 0
        default:    // 余数为0时，说明一行已满，需要加一行高度
            return CGFloat(106)
        }
    }
    
    func getNeedRemovedHeight(availableImageNumber n: Int) -> CGFloat {
        if n == 0 {
            return 0
        }
        
        switch n % 3 {
        case 0, 1:  // 余数为0或1时，说明该行还有单元，不必减高度
            return 0
        default:    // 余数为2时，说明单元格正好充满整，所以需要减去多余的一行高度
            return CGFloat(106)
        }
    }
}

extension CVCarPhotoCollection: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.carPhotoCollectionDelegate.carPhotos.count + (self.carPhotoCollectionDelegate.allowAdd ? 1 : 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: carPhotoCell, for: indexPath) as! CVCCarPhotoCell
        
        // 将已有的图片放到单元格中，并将最后一个设置为缺省图片
        if indexPath.item < self.carPhotoCollectionDelegate.carPhotos.count {
            let canRemove = indexPath.item >= self.carPhotoCollectionDelegate.originPhotoCount
            if (canRemove) {
                cell.setRemovableItem(self.carPhotoCollectionDelegate.carPhotos[indexPath.item], removeCompletion: {
                    // 删除照片
                    if let rc = self.carPhotoCollectionDelegate.removeCallback {
                        rc(indexPath.item)
                    }
                })
            } else {
                cell.setItem(self.carPhotoCollectionDelegate.carPhotos[indexPath.item])
            }
        } else {
            cell.setItem(UIImage(named: "defaultCatchImage")!, imageClick: self.carPhotoCollectionDelegate.pickerImageClick)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let v = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: carPhotoHeader, for: indexPath) as UICollectionReusableView
        
        return v
    }
}

class CarPhotoCollectionDelegate {
    var allowAdd: Bool! = true
    // 原始照片数量
    var originPhotoCount: Int! = 0
    // 本次上传照片数量
    var uploadCount: Int! = 0
    // 本次上传成功数量
    var successCount: Int! = 0
    // 本次上传失败数量
    var failedCount: Int! = 0
    // 全部照片
    var carPhotos: [UIImage]!
    // 已上传的文件url
    var uploadedFileUrls: [String]!
    // 照片选择事件
    var pickerImageClick: (() -> Void)!
    // 移除图片完成后的回调处理
    var removeCallback: ((_ removeIndex: Int) -> Void)!
}
