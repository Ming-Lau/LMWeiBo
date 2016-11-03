//
//  NetWorkTools.swift
//  LMWeiBo
//
//  Created by 刘明 on 16/6/13.
//  Copyright © 2016年 LM. All rights reserved.
//

import UIKit
import AFNetworking
class NetWorkTools: AFHTTPSessionManager {
    static let tools :NetWorkTools = {
       let url = URL(string: "https://api.weibo.com/")
        
        let t = NetWorkTools(baseURL: url)
        //设置AFN能够接收的数据类型
        t.responseSerializer.acceptableContentTypes = NSSet(objects:"application/json", "text/json", "text/javascript",
        "text/plain") as? Set<String>
        return t
    }()
    //获取单例的方法
    class func shareNetWorkTools() -> NetWorkTools {
        return tools
    }
}
