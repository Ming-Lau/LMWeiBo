//
//  VisitorView.swift
//  LMWeiBo
//
//  Created by 刘明 on 16/4/22.
//  Copyright © 2016年 LM. All rights reserved.
//

import UIKit
//swift中定义代理,必须遵守NSObjectProtocol协议
protocol VisitorViewDelegate: NSObjectProtocol{
    //注册回调
    func registerBtnWillClick()
    //登陆回调
    func loginBtnWillClick()
}

class VisitorView: UIView {
    //定义一个属性保存代理   一定要加上weak  避免循环应用
    weak var delegate:VisitorViewDelegate?
    
    
    /**
     设置未登陆界面
     
     - parameter isHome:      是否是主页
     - parameter imageName:   图片的名字
     - parameter messageText: 显示的消息
     */
    func setupVisitorInfo(_ isHome:Bool,imageName:String,messageText:String){
        //如果不是首页就隐藏转盘
        iconView.isHidden = !isHome
        //设置Home
        homeICon.image = UIImage(named: imageName)
        //设置文字
        messageLable.text = messageText
        if isHome {
            startAnimation()
        }
        
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        //添加子控件
        addSubview(iconView)
        addSubview(maskBGView)
        addSubview(homeICon)
        addSubview(messageLable)
        addSubview(loginButton)
        addSubview(registerButton)
        //布局子控件
        //设置背景
        iconView.xmg_AlignInner(type: XMG_AlignType.center, referView: self, size: nil)
        //设置home
        homeICon.xmg_AlignInner(type: XMG_AlignType.center, referView: self, size: nil)
        //设置蒙版
        maskBGView.xmg_Fill(self)
        //设置消息
        messageLable.xmg_AlignVertical(type: XMG_AlignType.bottomCenter, referView: iconView, size: nil)
        //通过autolayout布局
        //哪个"控件"的什"属性" "等于" "另一个控件" 的什么 "属性"  乘以 "多少"  加上 "多少"
        let widthCons = NSLayoutConstraint(item: messageLable, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 224)
        addConstraint(widthCons);
        
        //设置注册按钮
        registerButton.xmg_AlignVertical(type: XMG_AlignType.bottomLeft, referView: messageLable, size:CGSize(width: 100,height: 30), offset: CGPoint(x: 0, y: 20))
        //设置登录按钮
        loginButton.xmg_AlignVertical(type: XMG_AlignType.bottomRight, referView: messageLable, size: CGSize(width: 100,height: 30), offset: CGPoint(x: 0, y: 20))
        
        
        
        
        
    }
    //Swift推荐我们创建一个VIEW要么纯代码,要么xib不要混着用
    required init?(coder aDecoder: NSCoder) {
        //如果使用了纯代码 在使用XIB 下面这行会使程序崩溃
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: -按钮点击事件
    func loginBtnClick(){
        delegate?.loginBtnWillClick()
    }
    func registerBtnClick(){
        delegate?.registerBtnWillClick()
    }
    //MARK: -转盘动画
    fileprivate func startAnimation(){
        //1.创建动画
        let anima = CABasicAnimation(keyPath: "transform.rotation")
        //2.设置动画属性
        anima.toValue = 2 * M_PI
        anima.duration = 20
        anima.repeatCount = MAXFLOAT
        //该属性默认为yes代表该动画执行完毕就移除
        anima.isRemovedOnCompletion = false
        //3.添加图层
        iconView.layer.add(anima, forKey: nil)
    }
    //MARK: -懒加载控件
        /// 蒙版
    fileprivate lazy var maskBGView : UIImageView = {
        let mask = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
        return mask
        
    }()
        /// 转盘
    fileprivate lazy var iconView : UIImageView = {
        let icon = UIImageView(image:UIImage(named: "visitordiscover_feed_image_smallicon"))
        return icon
    }()
        /// 房子
    fileprivate lazy var homeICon : UIImageView = {
       let home = UIImageView(image:UIImage(named: "visitordiscover_feed_image_house"))
        return home
    }()
        /// 信息
    fileprivate lazy var messageLable : UILabel = {
        let lable = UILabel()
        lable.numberOfLines = 0
        lable.textColor = UIColor.darkGray
        lable.text = "咳咳咳的目的你呢面对面看吃的么的呃呃奥东科的而飞机我们的买"
       return lable
    }()
        /// 登录按钮
    fileprivate lazy var loginButton : UIButton = {
       let loginBtn = UIButton()
        loginBtn.setTitleColor(UIColor.darkGray, for: UIControlState())
        loginBtn.setTitle("登录", for: UIControlState())
        loginBtn.setBackgroundImage(UIImage(named:"common_button_white_disable"), for: UIControlState())
        
        loginBtn.addTarget(self, action: #selector(VisitorView.loginBtnClick), for: UIControlEvents.touchUpInside)
        return loginBtn
    }()
        /// 注册按钮
    fileprivate lazy var registerButton : UIButton = {
       let registerBtn = UIButton()
        registerBtn.setTitleColor(UIColor.orange, for: UIControlState())
        registerBtn.setTitle("注册", for: UIControlState())
        registerBtn.setBackgroundImage(UIImage(named:"common_button_white_disable"), for: UIControlState())
        
        registerBtn.addTarget(self, action: #selector(VisitorView.registerBtnClick), for: UIControlEvents.touchUpInside)
        return registerBtn
    }()
    
}
