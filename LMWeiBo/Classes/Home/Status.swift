//
//  Status.swift
//  LMWeiBo
//
//  Created by 刘明 on 16/6/27.
//  Copyright © 2016年 LM. All rights reserved.
//

import UIKit

class Status: NSObject  {
    ///微博创建时间
    var created_at:String?
    /// 微博ID
    var id:Int = 0
    /// 微博内容
    var text:String?
    /// 微博来源
    var source:String?
    /// 配图数组
    var pic_urls:[[String:AnyObject]]?
    var user:User?
    
    
    //加载微博数据
    class func loadStatuses(_ finished:@escaping (_ models:[Status]?,_ error:NSError?)->()) {
        let path = "2/statuses/home_timeline.json"
        let params = ["access_token":UserAccount.loadAccount()!.access_token!]
        
        NetWorkTools.shareNetWorkTools().get(path, parameters: params, success: { (_, JSON) in
//            print(JSON)
            //1.取出statuese字典数组
            //2.遍历数组将字典转换为模型
            let models = dict2Model(JSON!["statuses"] as! [[String:AnyObject]])
            finished(models: models, error: nil)
            }) { (_, error) in
                finished(nil, error)
        }
    }
    class func dict2Model(_ list:[[String:AnyObject]])->[Status] {
        var models = [Status]()
        for dict in list{
            models.append(Status(dict: dict))
        }
        return models
    }
    //字典转换
    init(dict : [String:AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    //setValuesForKeysWithDictionary内部都会调用此方法
    override func setValue(_ value: Any?, forKey key: String) {
        if "user" == key {
            user = User(dict: value as! [String:AnyObject])
            return
        }
        super.setValue(value, forKey: key)
    }
    //找不到Key调用
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    /// 打印当前模型
    var properties = ["created_at","id","text","source","pic_urls"]
    override var description: String{
        let dict = dictionaryWithValues(forKeys: properties)
        return "\(dict)"
    }
    
}
