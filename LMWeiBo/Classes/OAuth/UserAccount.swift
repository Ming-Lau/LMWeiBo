//
//  UserAccount.swift
//  LMWeiBo
//
//  Created by 刘明 on 16/6/13.
//  Copyright © 2016年 LM. All rights reserved.
//

import UIKit

class UserAccount: NSObject,NSCoding{
    /// 授权
    var access_token:String?
    /// 授权过期时间
    var expires_in:NSNumber?{
        didSet{
            expires_date = Date(timeIntervalSinceNow: expires_in!.doubleValue);
        }
    }
    /// uid
    var uid:String?
    /// 授权到期日期
    var expires_date: Date?
    /// 用户昵称
    var screen_name : String?
    /// 用户头像
    var avatar_large:String?
    
    
    

    init(dict:[String:AnyObject]) {
        super.init()
//        access_token = dict["access_token"] as? String
//        expires_in = dict["expires_in"] as? NSNumber
//        uid = dict["uid"] as? String
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    //获取登录信息
    func loadUserInfo(_ finished:@escaping (_ account:UserAccount?,_ error:NSError?)->()) {
        let path = "2/users/show.json"
        let parames = ["access_token":access_token!,"uid":uid!]
        
        NetWorkTools.shareNetWorkTools().get(path, parameters: parames, success: { (_, JSON) in
            if let dict = JSON as?[String:AnyObject]
            {
                self.screen_name = dict["screen_name"] as? String
                self.avatar_large = dict["avatar_large"] as? String
//                self.saveAccout()
                finished(self, nil)
                return
            }
            finished(nil, nil)
            }) { (_, error) in
                finished(nil, nil)
                print(error)
        }
    }
    class func userLogin() -> Bool {
        return UserAccount.loadAccount() != nil
    }
    //MARK: 保存和读取
    /**
     保存数据
     */
    func saveAccout() {
        let filePath = "account.plist".cacheDir()
        NSKeyedArchiver.archiveRootObject(self, toFile: filePath)
        
    }
    /**
     读取数据
     
     - returns:
     */
    static var account : UserAccount?
    class func loadAccount() ->UserAccount?{
        if account != nil {
            return account
        }
        
        let filePath = "account.plist".cacheDir()
        account = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? UserAccount
        //判断授权信息是否过期
        if account?.expires_date?.compare(Date()) == ComparisonResult.orderedAscending {
            return nil
        }
        return account
        
    }
    //MARK: -NSCoding
    /**
     将对象写入到文件中 (归档)
     
     - parameter aCoder:
     */
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(expires_in, forKey: "expires_in")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(expires_date, forKey: "expires_date")
        aCoder.encode(screen_name, forKey: "screen_name")
        aCoder.encode(avatar_large, forKey: "avatar_large")
        
    }
    /**
     从文件中读取对象 (解档)
     
     - parameter aDecoder:
     
     - returns:
     */
    required init?(coder aDecoder: NSCoder)
    {
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        expires_in = aDecoder.decodeObject(forKey: "expires_in") as? NSNumber
        uid =   aDecoder.decodeObject(forKey: "uid") as? String
        expires_date = aDecoder.decodeObject(forKey: "expires_date") as? Date
        screen_name = aDecoder.decodeObject(forKey: "screen_name") as? String
        avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
    }
}
