//
//  ImagePickerViewController.swift
//  buycar.yuandian
//
//  Created by 李萌 on 2019/3/4.
//  Copyright © 2019年 tymaker. All rights reserved.
//

import UIKit
import MobileCoreServices

class ImagePickerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // 照相机选择控制器
    var cameraPicker: UIImagePickerController!
    // 相册选择控制器
    var photoPicker: UIImagePickerController!
    // 弹出图片选择控制器
    var presentImagePicker: ((Bool) -> Void)!
    // 预览删除完成事件
    private var previewDeleteCompletion: (() -> Void)?
    // 预览视图
    private var previewView: UIView?
    // 预览图片视图
    private var previewImageView: UIImageView?
    // 删除图片按钮
    private var previewDeleteButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cameraPicker = UIImagePickerController()
        self.cameraPicker.sourceType = .camera
        self.cameraPicker.mediaTypes = [kUTTypeImage as String]
        self.cameraPicker.delegate = self
        
        self.photoPicker = UIImagePickerController()
        self.photoPicker.sourceType = .savedPhotosAlbum
        self.photoPicker.mediaTypes = [kUTTypeImage as String]
        self.photoPicker.delegate = self
        
        self.presentImagePicker = { (allowPickFromAlbum: Bool) in
            if allowPickFromAlbum {
                // 如果允许从相册选择照片，则展示拍照和选择照片的选项
                let action = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                action.addAction(UIAlertAction(title: "拍照", style: .default) {_ in
                    self.present(self.cameraPicker, animated: true, completion: nil)
                })
                action.addAction(UIAlertAction(title: "从相册选取", style: .default) {_ in
                    self.present(self.photoPicker, animated: true, completion: nil)
                })
                action.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                self.present(action, animated: true, completion: nil)
            } else {
                // 否则直接打开相机拍照
                self.present(self.cameraPicker, animated: true, completion: nil)
            }
        }
    }
    
    /// 预览图片，点击图片放大，全屏展示
    ///
    /// - Parameters:
    ///   - image: 要预览的图片
    ///   - alpha: 预览背景透明度
    ///   - deletable: 是否允许删除
    ///   - deleteText: 删除文本
    ///   - deleteEvent: 删除事件
    func previewImage(image: UIImage, alpha: CGFloat, deletable: Bool = false, deleteText: String? = nil, deleteCompletion: (() -> Void)? = nil) {
        let window = UIApplication.shared.keyWindow!
        self.previewDeleteCompletion = deleteCompletion
        
        if self.previewView == nil {
            // 预览图片背景
            self.previewView = UIView(frame: CGRect(x: 0, y: 0, width: window.bounds.width, height: window.bounds.height))
            self.previewView!.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: alpha)
            self.previewView!.alpha = 0
            // 点击预览视图事件
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hidePreviewImage))
            self.previewView!.addGestureRecognizer(tapGestureRecognizer)
            
            // 预览图片视图
            self.previewImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: window.bounds.width, height: window.bounds.height))
            self.previewImageView!.tag = 500
            self.previewImageView!.contentMode = .scaleAspectFit
            self.previewView!.addSubview(self.previewImageView!)
            // 设置手势响应事件
            self.previewImageView!.isUserInteractionEnabled = true
            // 捏合手势
            let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchDid(_:)))
            self.previewImageView!.addGestureRecognizer(pinchGestureRecognizer)
            // 拖动手势
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panDid(_:)))
            self.previewImageView!.addGestureRecognizer(panGestureRecognizer)
            
            // 删除按钮
            self.previewDeleteButton = UIButton()
            self.previewDeleteButton!.isHidden = true
            self.previewDeleteButton!.setTitle(deleteText, for: .normal)
            self.previewDeleteButton!.setTitleColor(UIColor.white, for: .normal)
            self.previewDeleteButton!.translatesAutoresizingMaskIntoConstraints = false
            self.previewView!.addSubview(self.previewDeleteButton!)
            self.previewView!.addConstraint(NSLayoutConstraint(item: self.previewDeleteButton!, attribute: .top, relatedBy: .equal, toItem: self.previewView, attribute: .top, multiplier: 1, constant: 20))
            self.previewView!.addConstraint(NSLayoutConstraint(item: self.previewDeleteButton!, attribute: .trailing, relatedBy: .equal, toItem: self.previewView, attribute: .trailing, multiplier: 1, constant: -20))
            self.previewView!.addConstraint(NSLayoutConstraint(item: self.previewDeleteButton!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80))
            self.previewView!.addConstraint(NSLayoutConstraint(item: self.previewDeleteButton!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50))
            
            self.previewDeleteButton!.addTarget(self, action: #selector(deletePreviewImage), for: .touchUpInside)
        }
        
        // 设置初始位置及大小
        self.previewImageView!.frame.size.width = window.bounds.width
        self.previewImageView!.frame.size.height = window.bounds.height
        self.previewImageView!.frame.origin = window.bounds.origin
        window.addSubview(self.previewView!)
        
        self.previewImageView!.image = image
        self.previewDeleteButton!.isHidden = !deletable
        
        // 动画展示
        UIView.animate(withDuration: 0.4) {
            let width = screenWidth
            let height = image.size.height * width / image.size.width
            let y = (screenHeight - height) * 0.5
            
            self.previewImageView!.frame = CGRect(x: 0, y: y, width: width, height: height)
            self.previewView!.alpha = 1
        }
    }
    
    /// 点击隐藏预览图
    ///
    /// - Parameter tap: 手势操作
    @objc private func hidePreviewImage(tap: UITapGestureRecognizer) {
        let backgroundView = tap.view
        UIView.animate(withDuration: 0.4, animations: {
            backgroundView?.alpha = 0
        }) { (finished) in
            backgroundView?.removeFromSuperview()
        }
    }
    
    /// 删除预览图片
    ///
    /// - Parameter completion: 删除完成后的事件
    @objc private func deletePreviewImage() {
        UIView.animate(withDuration: 0.4, animations: {
            self.previewView?.alpha = 0
        }) { (finished) in
            self.previewView?.removeFromSuperview()
            if let pdc = self.previewDeleteCompletion {
                pdc()
            }
        }
    }
    
    /// 手势缩放图片
    ///
    /// - Parameter sender: 手势操作
    @objc private func pinchDid(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            self.previewImageView!.transform = self.previewImageView!.transform.scaledBy(x: sender.scale, y: sender.scale)
            sender.scale = 1
        }
        // 如果新的视图大小小于视口边框大小，则设置为原始视图大小
        if self.previewImageView!.frame.width < UIApplication.shared.keyWindow!.bounds.width {
            let recoverScale = UIApplication.shared.keyWindow!.bounds.width / self.previewImageView!.frame.width
            self.previewImageView!.transform = self.previewImageView!.transform.scaledBy(x: recoverScale, y: recoverScale)
        }
        self.resetPreviewImageViewFrame()
    }
    
    /// 拖动手势移动图片
    ///
    /// - Parameter sender: 手势操作
    @objc private func panDid(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            // 当前视图超过视口大小
            if self.previewImageView!.frame.width > UIApplication.shared.keyWindow!.bounds.width {
                let translation = sender.translation(in: self.previewImageView!)
                self.previewImageView!.transform = self.previewImageView!.transform.translatedBy(x: translation.x, y: translation.y)
            }
            self.resetPreviewImageViewFrame()
        }
    }
    
    /// 重置预览视图的位置
    private func resetPreviewImageViewFrame() {
        // 重置位置，视图边框不能离开视口
        if self.previewImageView!.frame.origin.x > 0 {
            self.previewImageView!.frame.origin.x = 0
        }
        if self.previewImageView!.frame.origin.y > 0 {
            self.previewImageView!.frame.origin.y = 0
        }
        if self.previewImageView!.frame.maxX < UIApplication.shared.keyWindow!.bounds.maxX {
            self.previewImageView!.frame.origin.x = UIApplication.shared.keyWindow!.bounds.maxX - self.previewImageView!.frame.width
        }
        if self.previewImageView!.frame.maxY < UIApplication.shared.keyWindow!.bounds.maxY {
            self.previewImageView!.frame.origin.y = UIApplication.shared.keyWindow!.bounds.maxY - self.previewImageView!.frame.height
        }
    }
}
