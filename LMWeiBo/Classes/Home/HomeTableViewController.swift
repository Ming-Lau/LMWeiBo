//
//  HomeTableViewController.swift
//  LMWeiBo
//
//  Created by 刘明 on 16/4/21.
//  Copyright © 2016年 LM. All rights reserved.
//

import UIKit
let LMReuseIdentifier = "LMReuseIdentifier"

class HomeTableViewController: BaseTableViewController {
    var statuses:[Status]?{
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //未登录页面加载
        if !userLogin {
            visitorView?.setupVisitorInfo(true, imageName: "visitordiscover_feed_image_house", messageText: "关注一些人，回这里看看有什么惊喜")
            return
        }
        //登录状态导航条设置
        setNavBar()
        //注册通知修改箭头
        NotificationCenter.default.addObserver(self, selector: #selector(HomeTableViewController.change), name:NSNotification.Name(rawValue: LMPopoverWillShow), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeTableViewController.change), name: NSNotification.Name(rawValue: LMPopoverWillDismiss), object: nil)
        //注册一个cell
        tableView.register(StatusTableViewCell.self, forCellReuseIdentifier:LMReuseIdentifier )
        //设置行高
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        //加载微博数据
        loadStatuese()
    }
    fileprivate func loadStatuese(){
        Status.loadStatuses { (models, error) in
            if error != nil
            {
                return
            }
            self.statuses = models!
        }
    }
    /**
     移除监听
     */
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    /**
     修改标题按钮状态
     */
    func change(){
        let titleBtn = navigationItem.titleView as! TitleButton
        titleBtn.isSelected = !titleBtn.isSelected
    }
    /**
     设置登录后导航条按钮
     */
    fileprivate func setNavBar(){
        //设置title
        let titleBtn = TitleButton()
        titleBtn.setTitle("刘明0830 ", for: UIControlState())
        titleBtn.addTarget(self, action: #selector(HomeTableViewController.titleBtnClick(_:)), for: UIControlEvents.touchUpInside)
        navigationItem.titleView = titleBtn
        
        //设置nav左侧按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_friendattention", target: self, action: #selector(HomeTableViewController.leftItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_pop", target: self, action: #selector(HomeTableViewController.rightItemClick))
    }
    func titleBtnClick(_ btn:TitleButton)
    {
        //1.修改箭头方向
//        btn.selected = !btn.selected
        //2.弹出菜单
        let sb = UIStoryboard(name: "PopoverViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        //3.设置转场代理
        vc?.transitioningDelegate = popoverAnimation
        //4.设置转场样式
        vc?.modalPresentationStyle = UIModalPresentationStyle.custom
        
        present(vc!, animated: true, completion: nil)
        
    }
    /**
     导航条左侧点击事件
     */
    func leftItemClick(){
        print(#function)
    }
    /**
     导航条右侧点击事件
     */
    func rightItemClick(){
        let sb = UIStoryboard(name: "QRCodeViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        present(vc!, animated: true, completion: nil)
        
        
    }
    //MARK: - 懒加载
    //一定要自定义一个属性来保存自定义转场对象,否则会报错
    fileprivate lazy var popoverAnimation : PopoverAnimator = {
        let pa = PopoverAnimator()
        pa.presentFrame = CGRect(x: 100, y: 56, width: 200, height: 350)
        return pa
    }()
}

extension HomeTableViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: LMReuseIdentifier, for: indexPath) as! StatusTableViewCell
        let model = statuses![(indexPath as NSIndexPath).row]
        cell.status = model
        return cell
    }
}
