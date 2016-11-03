//
//  User.swift
//  LMWeiBo
//
//  Created by 刘明 on 16/6/27.
//  Copyright © 2016年 LM. All rights reserved.
//

import UIKit

class User: NSObject {
    /// 用户ID
    var id:Int = 0
    /// 用户名
    var name:String?
    /// 用户头像
    var profile_image_url:String?{
        didSet{
            if let urlStr = profile_image_url {
                imageUrl = URL(string: urlStr)
            }
        }
    }
    /// 保存用户头像URL
    var imageUrl : URL?
    /// 是否是认证true是 false不是
    var verified: Bool = false
    /// 用户认证类型 -1:没有认证 0:认证 2,3,5:企业 220:达人
    var verified_type:Int = -1{
        didSet{
            switch verified_type {
            case 0:
                verifiedImage = UIImage(named: "avatar_vip")
            case 2,3,5:
                verifiedImage = UIImage(named: "avatar_enterprise_vip")
            case 220:
                verifiedImage = UIImage(named: "avatar_grassroot")
            default:
                verifiedImage = nil
            }
        }
    }
    /// 保存认证图标
    var verifiedImage:UIImage?
    
    
    //字典转换
    init(dict : [String:AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    //找不到Key调用
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    /// 打印当前模型
    var properties = ["id","name","profile_image_url","verified","verified_type"]
    override var description: String{
        let dict = dictionaryWithValues(forKeys: properties)
        return "\(dict)"
    }

}
