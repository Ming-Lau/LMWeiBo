//
//  String+Category.swift
//  LMWeiBo
//
//  Created by 刘明 on 16/6/15.
//  Copyright © 2016年 LM. All rights reserved.
//

import UIKit
extension String{
    /**
     将当前字符串拼接到缓存目录后面
     
     - returns:
     */
    func cacheDir() -> String {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as NSString
        return path.appendingPathComponent((self as NSString).lastPathComponent)
    }
    /**
     将当前字符串拼接到doc目录后面
     
     - returns:
     */
    func docDir() -> String {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory , FileManager.SearchPathDomainMask.userDomainMask, true).last! as NSString
        return path.appendingPathComponent((self as NSString).lastPathComponent)
    }
    /**
     将当前字符串拼接到temp目录后面
     
     - returns:
     */
    func tmpDir() -> String {
        let path = NSTemporaryDirectory() as NSString
        return path.appendingPathComponent((self as NSString).lastPathComponent)
        
    }
    
}
