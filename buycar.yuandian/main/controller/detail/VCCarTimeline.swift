//
//  VCCarTimeline.swift
//  buycar.yuandian
//
//  Created by 李萌 on 2019/2/27.
//  Copyright © 2019年 tymaker. All rights reserved.
//

import UIKit
import SwiftyJSON

class VCCarTimeline: UIViewController {
    
    var detail: [JSON]!
    var ctms = [CarTimelineCellModel]()
    
    @IBOutlet weak var timelineTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 守卫代码，保证页面正常绘制不闪退
        guard detail != nil else {
            return
        }
        
        self.initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //发送一个名字为currentPageChanged，附带object的值代表当前页面的索引
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "carDetailPageChanged"), object: 1)
    }
    
    func initView() {
        // 基础信息
        var timelineDetail: JSON!
        
        // 把查询结果按类型区分
        for item in detail {
            switch item["type"] {
            case "time":
                timelineDetail = item
                break
            default:
                break
            }
        }
        
        // 没有时间线信息则不进行绘制
        if (timelineDetail == nil) {
            return
        }
        
        // 初始化头部视图
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 0))
        headerView.backgroundColor = heavyBackgroundColor
        // 添加一个显示标题的label
        let lvTimelineTitle = VTextGroupTitleView(frame: CGRect(x: 0, y: headerView.frame.size.height, width: screenWidth, height: 35), titleText: timelineDetail["title"].stringValue, drawSeparatorLine: true)
        lvTimelineTitle.backgroundColor = UIColor.white
        headerView.addSubview(lvTimelineTitle)
        headerView.frame.size.height += 35
        
        // 构造基础信息数据源
        let timelineContent = timelineDetail["content"].arrayValue
        for content in timelineContent {
            let tms = CarTimelineCellModel(content["time"].stringValue, content["event"].stringValue, content["isImportant"].boolValue)
            self.ctms.append(tms)
        }
        
        timelineTableView.delegate = self
        timelineTableView.dataSource = self
        
        // 展示标题
        self.timelineTableView.tableHeaderView = headerView
        // 取消所有多余分隔线
        self.timelineTableView.tableFooterView = UIView()
    }
}

extension VCCarTimeline: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension VCCarTimeline: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ctms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TVCCarTimelineCell.mi_xibCell(withTableView: tableView) as! TVCCarTimelineCell
        
        cell.configure(model: self.ctms[indexPath.row])
        
        return cell
    }
}

