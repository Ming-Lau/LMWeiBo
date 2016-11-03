//
//  UIBarButtonItem+Category.swift
//  LMWeiBo
//
//  Created by 刘明 on 16/4/25.
//  Copyright © 2016年 LM. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    /**
     UIBarButtonItem扩展方法 设置图片 和点击事件
     
     - parameter imageName: 图片名字
     - parameter target:    监听类
     - parameter action:    方法
     
     - returns: btn
     */
    class func createBarButtonItem(_ imageName:String , target : AnyObject , action : Selector) -> UIBarButtonItem {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: UIControlState())
        btn.setImage(UIImage(named: imageName + "_highlighted"), for: UIControlState.highlighted)
        btn.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        btn.sizeToFit()
        return UIBarButtonItem(customView: btn)
        
    }
}
