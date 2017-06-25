//
//  VCDailyList.swift
//
//  显示日报列表的view controller，对应storyboard是Main
//
//  Created by 姬鹏 on 2017/3/22.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import UIKit

private let dailyCell = "dailyCell"

class VCDailyList: UIViewController {
    
    let dlTable = UITableView()
    var ds = [Daily]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configTitleLabelByText(title: "日报")
        
        initView()
        launchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initView() {
        // 设置右上角的barButtonItem
        let addDailyButton = UIBarButtonItem(image: UIImage(named: "addDailyImage"), style: .plain, target: self, action: #selector(VCDailyList.addDaily(_:)))
        
        self.navigationItem.rightBarButtonItem = addDailyButton
        self.navigationItem.rightBarButtonItem!.imageInsets = UIEdgeInsetsMake(3, 0, 0, 0)
    }

    private func launchData(completion: (() -> Swift.Void)? = nil) {
        // 设置日报数据
        let d = Daily()
        d.getDailyList { (status: ReturnedStatus, msg: String?, ds: [Daily]?) in
            switch status {
            case .normal:
                self.view.addSubview(self.dlTable)

                self.dlTable.translatesAutoresizingMaskIntoConstraints = false
                self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tv]|", options: [], metrics: nil, views: ["tv": self.dlTable]))
                self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tv]|", options: [], metrics: nil, views: ["tv": self.dlTable]))
                
                self.dlTable.dataSource = self
                self.dlTable.delegate = self

                // 取消所有多余分隔线
                self.dlTable.tableFooterView = UIView()

                // 设置cell的分隔线，以便其可以顶头开始
                self.dlTable.layoutMargins = UIEdgeInsets.zero
                self.dlTable.separatorInset = UIEdgeInsets.zero
                self.dlTable.separatorColor = separatorLineColor
                
                self.dlTable.register(UITableViewCell.self, forCellReuseIdentifier: dailyCell)
                
                self.ds = ds!
                
                if let c = completion {
                    c()
                }
                
                // 如果之前存在无数据、无网络连接等问题，则先移除这些view
                self.removeNoConnectView(containerView: self.view)
                self.removeNoDataView(containerView: self.view)
            case .noData:
                self.showNoDataView(containerView: self.view)
            case .needLogin:
                self.needsLogout()
            case .noConnection:
                self.showNoConnectionView(containerView: self.view) { _ in
                    self.launchData()
                }
            default:
                break
            }
        }
    }
    
    func addDaily(_ sender: AnyObject) {
        self.pushViewControllerFromStoryboard(storyboardName: "Main", idInStoryboard: "vcAddDaily", animated: true, completion: nil)
        self.configNavigationBackItem(sourceViewController: self)
    }
    
    // 用于从添加日报界面返回
    @IBAction func backToDailyList(_ seg: UIStoryboardSegue!) {
        self.launchData(completion: {
            self.dlTable.reloadData()
        })
    }
}

extension VCDailyList: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: dailyCell, for: indexPath)

        cell.selectionStyle = .none
        
        cell.textLabel!.font = textFont
        cell.textLabel!.textColor = mainTextColor
        cell.textLabel!.text = self.ds[indexPath.row].dailyPerson + "于" + self.ds[indexPath.row].dailyTime + ":" + self.ds[indexPath.row].dailyDetail
//        cell.textLabel!.text = convertDateToCNDateFormat(self.ds[indexPath.row].dailyDate)

        return cell
    }
}

extension VCDailyList: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
}

























