//
//  PopoverPresentationController.swift
//  LMWeiBo
//
//  Created by 刘明 on 16/4/25.
//  Copyright © 2016年 LM. All rights reserved.
//

import UIKit

class PopoverPresentationController: UIPresentationController {
    
    /// 定义属性保存当前frame
    var presentFrame = CGRect.zero
    
    
    /**
     初始化方法 用于创建负责转场动画的对象
     
     - parameter presentedViewController:  被展现的控制器
     - parameter presentingViewController: 发起的控制器
     
     - returns: 负责转场动画的对象
     */
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
    }
    /**
     即将布局转场子视图时调用
     */
    override func containerViewWillLayoutSubviews()
    {
        if presentFrame == CGRect.zero
        {
        //设置子控制器frame
        presentedView?.frame = CGRect(x: 100, y: 56, width: 200, height: 200)
        }else
        {
            presentedView?.frame = presentFrame
        }
        
        //在容器中插入一个蒙版
        containerView?.insertSubview(coverView, at: 0)
    }
    //MARK: - 蒙版懒加载
    fileprivate lazy var coverView:UIView = {
        //1.创建view
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.frame = UIScreen.main.bounds
        //2.添加点击事件
        let tap = UITapGestureRecognizer(target: self, action: #selector(PopoverPresentationController.close))
        view.addGestureRecognizer(tap)
        
        return view
    }()
    //蒙版点击事件
    func close(){
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
