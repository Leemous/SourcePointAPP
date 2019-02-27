//
//  VCAddDaily.swift
//  
//  编辑日报的view controll，对应的storyboard是Main
//
//  Created by 姬鹏 on 2017/3/22.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import UIKit

class VCAddDaily: UIViewController {

    @IBOutlet weak var dailyText: TextViewWithFinishButton!
    
    var placeHolderView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.configTitleLabelByText(title: "编辑日报")

        self.dailyText.delegate = self

        initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func initView() {
        // 设置右上角的barButtonItem
        let saveDailyButton = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(VCAddDaily.saveDaily(_:)))
        self.navigationItem.rightBarButtonItem = saveDailyButton
        
        // 设置作为place holder的text view
        self.placeHolderView = UITextView(frame: CGRect(x: 16, y: 2, width: self.view.frame.size.width - 24, height: 50))
        self.placeHolderView.backgroundColor = UIColor.clear
        self.placeHolderView.font = systemFont
        self.placeHolderView.textColor = placeholderDarkColor
        self.placeHolderView.text = "填写今天的日报内容。日报不可修改，请确认后提交。"
        self.placeHolderView.isEditable = false
        self.placeHolderView.isSelectable = false
        self.view.insertSubview(placeHolderView, at: 0)

        self.dailyText.becomeFirstResponder()
    }
    
    func saveDaily(_ sender: AnyObject) {
        let daily = Daily()
        daily.saveDaily(content: self.dailyText.text) { (status: ReturnedStatus, msg: String?) in
            switch status {
            case .normal:
                self.performSegue(withIdentifier: "backToDailyList", sender: self)
            case .warning,.noData:
                self.alert(viewToBlock: nil, msg: msg == nil ? "保存日报失败" : msg!)
                return
            case .noConnection:
                self.alert(viewToBlock: nil, msg: msgNoConnection)
                return
            default:
                return
            }
        }
    }
}

extension VCAddDaily: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" {
            self.placeHolderView.isHidden = false
        } else {
            self.placeHolderView.isHidden = true
        }
    }
}























