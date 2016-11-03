//
//  PopoverAnimator.swift
//  LMWeiBo
//
//  Created by 刘明 on 16/4/26.
//  Copyright © 2016年 LM. All rights reserved.
//

import UIKit
let LMPopoverWillShow = "LMPopoverWillShow"
let LMPopoverWillDismiss = "LMPopoverWillDismiss"


class PopoverAnimator: NSObject, UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning
{
    //记录当前是否展开
    var isPressent : Bool = false
    
        /// 定义属性保存当前frame
    var presentFrame = CGRect.zero
    //实现代理方法,告诉系统谁来负责转场动画
    //UIPresentationController iOS8推出的 专门负责转场动画的
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController?
    {
        let pc = PopoverPresentationController(presentedViewController: presented, presentingViewController: presenting!)
        pc.presentFrame = presentFrame
        
        return  pc
    }
    //MARK: - 只要实现了下面的方法 那么系统自带的model动画就消失了.所有东西都需要程序员自己来实现
    /**
     告诉系统谁来负责model的展现动画
     
     - parameter presented:  被展现的视图
     - parameter presenting: 发起的视图
     - parameter source:
     
     - returns: 谁来负责
     */
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPressent = true
        //发送通知,通知控制器即将展开
        NotificationCenter.default.post(name: Notification.Name(rawValue: LMPopoverWillShow), object: self)
        return self
    }
    /**
     告诉系统谁来负责消失
     
     - parameter dismissed: 即将要消失的视图
     
     - returns: 谁来负责
     */
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPressent = false
        //发送通知,通知控制器即将消失
        NotificationCenter.default.post(name: Notification.Name(rawValue: LMPopoverWillDismiss), object: self)
        return self
    }
    //MARK: -UIViewControllerAnimatedTransitioning
    /**
     返回动画时长
     
     - parameter transitionContext: 上下文,保存了动画需要的所有参数
     
     - returns: 时长
     */
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
    {
        return 0.2
    }
    /**
     如何动画,无论是展现还是消失都会调用这个方法.
     
     - parameter transitionContext: 上下文,保存了动画需要的所有参数
     */
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
    {
        if isPressent {
            //拿到展现视图
            let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
            
            toView?.transform = CGAffineTransform(scaleX: 1.0, y: 0.0)
            //注意一定要将展现的视图添加到容器中去
            transitionContext.containerView.addSubview(toView!)
            //设置锚点
            toView?.layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            //执行动画
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                //清空transform
                toView?.transform = CGAffineTransform.identity
            }, completion: { (_) in
                transitionContext.completeTransition(true)
            }) 
        }
        else{
            
            let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                //注意:由于CGFLOAT是不准确的,所以如果写0.0是没有动画的
                //压扁视图
                fromView?.transform = CGAffineTransform(scaleX: 1.0, y: 0.00001)
                }, completion: { (_) in
                    //如果不写可能会导致一些未知错误
                    transitionContext.completeTransition(true)
            })
            
        }
        
    }
}
