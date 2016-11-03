//
//  BaseTableViewController.swift
//  LMWeiBo
//
//  Created by 刘明 on 16/4/21.
//  Copyright © 2016年 LM. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController,VisitorViewDelegate {
    //设置登录状态
    var userLogin = UserAccount.userLogin()
    
    var visitorView : VisitorView?
    
    override func loadView() {
        //判断用户是否登录  如果登录了就加载默认视图 否则加载自定义未登录视图
        userLogin ? super.loadView() : setUnLoginView()
    }
    /**
     设置未登录视图
     */
    fileprivate func setUnLoginView(){
        //1.设置导航条
        //注册
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.plain, target: self, action: #selector(BaseTableViewController.registerBtnWillClick))
        //登陆
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登陆", style: UIBarButtonItemStyle.plain, target: self, action: #selector(BaseTableViewController.loginBtnWillClick))
        //2.设置未登录页面
        let customView = VisitorView()
        customView.delegate = self
        view = customView
        visitorView = customView
        
    }
    //MARK: -VisitorViewDelegate
    /**
     登陆事件
     */
    func loginBtnWillClick() {
//        print(#function)
        let ovc = OAuthViewController()
        let nav = UINavigationController(rootViewController: ovc)
        present(nav, animated: true, completion: nil)
        
        
    }
    /**
     注册事件
     */
    func registerBtnWillClick() {
        print(#function)
    }

}
