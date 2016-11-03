//
//  OAuthViewController.swift
//  LMWeiBo
//
//  Created by 刘明 on 16/6/13.
//  Copyright © 2016年 LM. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {

    let WB_App_Key = "3598446047"
    let WB_App_Secret = "eb77c704bfe879cbd528199911a93e8d"
    let WB_redirect_uri = "http://www.520it.com"
    override func loadView() {
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //0.设置导航条
        navigationItem.title = "登录"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.plain, target: self, action: #selector(OAuthViewController.close))
        //1.获取未授权的requesttoken
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(WB_App_Key)&redirect_uri=\(WB_redirect_uri)"
        let url = URL(string: urlStr)
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
    }
    //关闭控制器
    func close() {
        dismiss(animated: true, completion: nil)
    }
    //MARK: -懒加载
    fileprivate lazy var webView : UIWebView = {
       let wv = UIWebView()
        wv.delegate = self
        return wv
    }()

}
extension OAuthViewController : UIWebViewDelegate
{
    /**
     返回true正常加载  返回FALSE停止加载
     
     - parameter webView:
     - parameter request:
     - parameter navigationType:
     
     - returns:
     */
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        //1.判断是否是授权回调页,如果不是就继续加载
        let urlStr = request.url!.absoluteString
        if !urlStr.hasPrefix(WB_redirect_uri) {
            //继续加载
            return true
        }
        //判断是否授权成功
        let codeStr = "code="
        if request.url!.query!.hasPrefix(codeStr) {
            //授权成功
            let code = request.url!.query?.substring(from: codeStr.endIndex)
            loadAccessToken(code!)
            
        }else
        {
            //取消授权
            close()
        }
        return false
        
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show(withStatus: "正在加载...", maskType: SVProgressHUDMaskType.black)
        
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    fileprivate func loadAccessToken(_ code:String){
        //1.定义路径
        let path = "oauth2/access_token"
        let params = ["client_id":WB_App_Key,"client_secret":WB_App_Secret,"grant_type":"authorization_code","code":code,"redirect_uri":WB_redirect_uri]
        
            NetWorkTools.shareNetWorkTools().post(path, parameters: params, success: { (_, json) in
            let account = UserAccount.init(dict: (json as? [String:AnyObject])!)
            account.loadUserInfo({ (account, error) in
                if account != nil
                {
                    account?.saveAccout()
                    NotificationCenter.default.post(name: Notification.Name(rawValue: LMSwitchRootViewControllerKey), object: false);
                    return
                    
                }
                SVProgressHUD.show(withStatus: "网络不给力", maskType: SVProgressHUDMaskType.black)
            })
//            account.saveAccout()
//            self.close()
            }) { (_, error) in
                print(error)
        }
        
    }
}
