//
//  StatusTableViewCell.swift
//  LMWeiBo
//
//  Created by 刘明 on 16/6/27.
//  Copyright © 2016年 LM. All rights reserved.
//

import UIKit
import SDWebImage

class StatusTableViewCell: UITableViewCell {
    var status:Status?{
        didSet{
            nameLable.text = status?.user?.name
            timeLable.text = "刚刚"
            sourceLable.text = "来自:刘哥微博"
            contentLable.text = status?.text
            //设置用户头像
            if let url = status?.user!.imageUrl {
                iconView.sd_setImage(with: url as URL!)
            }
            //设置认证
            verifiedView.image = status?.user?.verifiedImage
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //初始化UI
        setUpUI()
    }
    fileprivate func setUpUI(){
        //1.添加子控件
        contentView.addSubview(iconView)
        contentView.addSubview(verifiedView)
        contentView.addSubview(nameLable)
        contentView.addSubview(vipView)
        contentView.addSubview(timeLable)
        contentView.addSubview(sourceLable)
        contentView.addSubview(contentLable)
        contentView.addSubview(footerView)
        footerView.backgroundColor = UIColor(white: 0.2, alpha: 0.5)
        //2.布局子控件
        iconView.xmg_AlignInner(type: XMG_AlignType.topLeft, referView: contentView, size: CGSize(width: 50,height: 50), offset: CGPoint(x: 10, y: 10))
        verifiedView.xmg_AlignInner(type: XMG_AlignType.bottomRight, referView: iconView, size: CGSize(width: 14,height: 14), offset: CGPoint(x: 5, y: 5))
        nameLable.xmg_AlignHorizontal(type: XMG_AlignType.topRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        vipView.xmg_AlignHorizontal(type: XMG_AlignType.topRight, referView: nameLable, size: CGSize(width: 14,height: 14), offset: CGPoint(x: 10, y: 0))
        timeLable.xmg_AlignHorizontal(type: XMG_AlignType.bottomRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        sourceLable.xmg_AlignHorizontal(type: XMG_AlignType.bottomRight, referView: timeLable, size: nil, offset: CGPoint(x: 10, y: 0))
        contentLable.xmg_AlignVertical(type: XMG_AlignType.bottomLeft, referView: iconView, size: nil, offset: CGPoint(x: 0, y: 10))
        //添加一个底部约束
//        contentLable.xmg_AlignInner(type: XMG_AlignType.BottomRight, referView: contentView, size: nil, offset: CGPoint(x: -10, y: -10))
        let width = UIScreen.main.bounds.width
        footerView.xmg_AlignVertical(type: XMG_AlignType.bottomLeft, referView: contentLable, size: CGSize(width: width,height: 44), offset: CGPoint(x: -10, y: 10))
        footerView.xmg_AlignInner(type: XMG_AlignType.bottomRight, referView: contentView, size: nil, offset: CGPoint(x: -10, y: -10))
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - 懒加载
    //头像
    fileprivate lazy var iconView :UIImageView = {
        let iv = UIImageView(image: UIImage(named: "avatar_default_big"))
        return iv
    }()
    //认证图标
    fileprivate lazy var verifiedView :UIImageView = UIImageView(image: UIImage(named: "avatar_enterprise_vip"))
    //昵称
    fileprivate lazy var nameLable :UILabel = UILabel.createLable(UIColor.darkGray, fontSize: 14)
    //会员图标
    fileprivate lazy var vipView:UIImageView = UIImageView(image: UIImage(named: "common_icon_membership_level5"))
    //时间
    fileprivate lazy var timeLable :UILabel = UILabel.createLable(UIColor.darkGray, fontSize: 14)
    //来源
    fileprivate lazy var sourceLable :UILabel = UILabel.createLable(UIColor.darkGray, fontSize: 14)
    //正文
    fileprivate lazy var contentLable :UILabel = {
        let label = UILabel.createLable(UIColor.darkGray, fontSize: 15)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 20
        return label
    }()
    //底部视图
    fileprivate lazy var footerView:StatusFooterView = {
        StatusFooterView()
    }()
}

class StatusFooterView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func setUpUI(){
        //1.添加控件
        addSubview(retweetBtn)
        addSubview(unlikeBtn)
        addSubview(commonBtn)
        //2.布局控件
        xmg_HorizontalTile([retweetBtn,unlikeBtn,commonBtn], insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    //MARK: - 懒加载
    //转发
    fileprivate lazy var retweetBtn:UIButton = UIButton.createButton("timeline_icon_retweet", title: "转发")
    //赞
    fileprivate lazy var unlikeBtn:UIButton = UIButton.createButton("timeline_icon_unlike", title: "赞")
    //评论
    fileprivate lazy var commonBtn:UIButton = UIButton.createButton("timeline_icon_comment", title: "评论")
}
