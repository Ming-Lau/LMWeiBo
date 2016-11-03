//
//  UILable+Category.swift
//  LMWeiBo
//
//  Created by 刘明 on 16/6/29.
//  Copyright © 2016年 LM. All rights reserved.
//

import UIKit

extension UILabel {
    class func createLable(_ color:UIColor , fontSize : CGFloat)->UILabel{
        let label = UILabel()
        label.textColor = color
        label.font = UIFont.systemFont(ofSize: fontSize)
        return label
    }
}
