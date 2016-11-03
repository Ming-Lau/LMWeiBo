//
//  UIButton+Category.swift
//  LMWeiBo
//
//  Created by 刘明 on 16/6/29.
//  Copyright © 2016年 LM. All rights reserved.
//

import UIKit

extension UIButton{
    class func createButton(_ imageName:String , title:String)->UIButton{
        let btn = UIButton()
        btn.setImage(UIImage(named:imageName), for: UIControlState())
        btn.setTitle(title, for: UIControlState())
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        btn.setBackgroundImage(UIImage(named:"timeline_card_bottom_background"), for: UIControlState())
        btn.setTitleColor(UIColor.darkGray, for: UIControlState())
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        return btn
    }
}
