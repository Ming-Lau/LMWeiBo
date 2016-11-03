//
//  MainViewController.swift
//  LMWeiBo
//
//  Created by 刘明 on 16/4/21.
//  Copyright © 2016年 LM. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        //设置tabbar的图片与文字颜色  注意因为全局的  tabbar  和 navgationbar的颜色都是橘色 所以应该在appdelegate里面设置
//        tabBar.tintColor = UIColor.orangeColor()
        //添加控制器
        addChildViewControllers()
        //添加加号按钮
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupComposeBtn()
        
    }
    
    fileprivate func setupComposeBtn()
    {
        //添加加号按钮
        tabBar.addSubview(composeBtn)
        //计算按钮宽度
        let width = UIScreen.main.bounds.size.width / CGFloat(viewControllers!.count)
        //设置frame
        let rect = CGRect(x: 0, y: 0, width: width, height: 49)
        //设置按钮偏移
        composeBtn.frame = rect.offsetBy(dx: width * 2, dy: 0)
        
    }
    func composeBtnClick() {
        print("1111")
    }
    /**
     添加控制器
     */
    fileprivate func addChildViewControllers() {
        //添加首页
        addChildViewController(HomeTableViewController(), title: "首页", image: "tabbar_home")
        //添加消息
        addChildViewController(MessageTableViewController(), title: "消息", image: "tabbar_message_center")
        //添加加号按钮预留位
        addChildViewController(NULLViewController(), title: "", image: "")
        //添加发现
        addChildViewController(DiscoverTableViewController(), title: "发现", image: "tabbar_discover")
        //添加我
        addChildViewController(ProfileTableViewController(), title: "我", image: "tabbar_profile")
    }
    /**
     设置控制器
     
     - parameter childController: 传入的控制器
     - parameter title:           控制器标题
     - parameter image:           tabbar显示的图片
     */
    fileprivate func addChildViewController(_ childController: UIViewController,title:String,image:String) {
        //设置图片
        childController.tabBarItem.image = UIImage(named: image)
        //设置选中图片
        childController.tabBarItem.selectedImage = UIImage(named: image+"_highlighted")
        //设置标题
        childController.title = title
        
        //包装导航控制器
        let nav = UINavigationController()
        nav.addChildViewController(childController)
        
        //添加到tabbar控制器中
        addChildViewController(nav)
        
    }
    /// btn懒加载
    fileprivate lazy var composeBtn:UIButton = {
        //1.创建一个btn
        let btn = UIButton()
        
        //2.设置前景图片
        btn.setImage(UIImage(named:"tabbar_compose_icon_add"), for: UIControlState())
        btn.setImage(UIImage(named:"tabbar_compose_icon_add_highlighted"), for: UIControlState.highlighted)
        
        // 3.设置背景图片
        btn.setBackgroundImage(UIImage(named:"tabbar_compose_button"), for: UIControlState())
        btn.setBackgroundImage(UIImage(named:"tabbar_compose_button_highlighted"), for: UIControlState.highlighted)
        //4.添加点击事件
        btn.addTarget(self, action: #selector(MainViewController.composeBtnClick), for: UIControlEvents.touchUpInside)
        return btn
        
    }()

}
