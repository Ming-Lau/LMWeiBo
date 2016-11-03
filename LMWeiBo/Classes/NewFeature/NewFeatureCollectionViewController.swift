//
//  NewFeatureCollectionViewController.swift
//  LMWeiBo
//
//  Created by 刘明 on 16/6/16.
//  Copyright © 2016年 LM. All rights reserved.
//

import UIKit
private let reuseIdentifier = "reuseIdentifier"
class NewFeatureCollectionViewController: UICollectionViewController {
    /// 新特性页面个数
    fileprivate let pageCount = 4
    /// 创建一个布局
    fileprivate let layout:UICollectionViewFlowLayout = NewFeatrueLayout()
    init(){
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        collectionView?.register(NewFeatrueCell.self, forCellWithReuseIdentifier:reuseIdentifier )
    }
    //返回共有多少个Item
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageCount
    }
    //返回cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1.取出cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! NewFeatrueCell
        //2.设置cell的内容
        cell.imageIndex = (indexPath as NSIndexPath).item
        //3.返回cell
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let path = collectionView.indexPathsForVisibleItems.last!
        if (path as NSIndexPath).item == (pageCount - 1) {
            let cell = collectionView.cellForItem(at: path) as! NewFeatrueCell
            cell.startBtnAnimation()
        }
        
    }
}
class NewFeatrueCell:UICollectionViewCell
{
    var imageIndex:Int?{
        didSet{
            iconView.image = UIImage(named: "new_feature_\(imageIndex! + 1)")
                    }
    }
    func startBtnAnimation() {
        if imageIndex == 3 {
            startButton.isHidden = false
            //执行动画
            startButton.transform = CGAffineTransform(scaleX: 0, y: 0)
            startButton.isUserInteractionEnabled = false
            UIView.animate(withDuration: 2.2, delay: 0, usingSpringWithDamping: 1.2, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue:0), animations: {
                self.startButton.transform = CGAffineTransform.identity
                }, completion: { (_) in
                    self.startButton.isUserInteractionEnabled = true
            })
        }

    }
    //进入微博点击事件
    func startBtnClick() {
        //如果需要切换根控制器最好都在appdelegate中进行
        NotificationCenter.default.post(name: Notification.Name(rawValue: LMSwitchRootViewControllerKey), object: true);
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func setUpUI()
    {
        //1.添加到视图上
        contentView.addSubview(iconView)
        contentView.addSubview(startButton)
        startButton.addTarget(self, action: #selector(NewFeatrueCell.startBtnClick), for: UIControlEvents.touchUpInside)
        //2.布局
        iconView.xmg_Fill(contentView)
        startButton.xmg_AlignInner(type: XMG_AlignType.bottomCenter, referView: contentView, size: nil, offset: CGPoint(x: 0, y: -160))
    }
    //MARK: - 懒加载
    /// 背景图片
    fileprivate var iconView = UIImageView()
    /// 进入微博按钮
    fileprivate var startButton : UIButton = {
       let btn = UIButton()
        btn.setBackgroundImage(UIImage(named:"new_feature_button"), for: UIControlState())
        btn.setBackgroundImage(UIImage(named:"new_feature_button_highlighted"), for: UIControlState.highlighted)
        btn.isHidden = true
        return btn
    }()
}
private class NewFeatrueLayout:UICollectionViewFlowLayout
{
    fileprivate override func prepare() {
        //设置layout布局
        itemSize = UIScreen.main.bounds.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.horizontal
        //设置collectionView的属性
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.bounces = false
        collectionView?.isPagingEnabled = true
    }
}
