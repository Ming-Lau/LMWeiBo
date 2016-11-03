//
//  QRCodeViewController.swift
//  LMWeiBo
//
//  Created by 刘明 on 16/5/5.
//  Copyright © 2016年 LM. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeViewController: UIViewController,UITabBarDelegate {
        /// 扫描到的结果
    @IBOutlet weak var resultText: UILabel!
        /// 冲击波
    @IBOutlet weak var scanLineView: UIImageView!
        /// 容器高度约束
    @IBOutlet weak var containerHeightCons: NSLayoutConstraint!
        /// 冲击波顶部约束
    @IBOutlet weak var scanLineCons: NSLayoutConstraint!
        /// 底部tabbar
    @IBOutlet weak var customTabBar: UITabBar!
    /**
     我的名片点击事件
     
     - parameter sender:
     */
    @IBAction func myCardBtnClick(_ sender: AnyObject) {
        let vc = QRCodeCardViewController()
        navigationController?.pushViewController(vc, animated: true)
        
    }
    /**
     关闭按钮点击事件
     
     - parameter sender: 按钮
     */
    @IBAction func closeBtnClick(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        customTabBar.delegate = self
        //默认选中第0个
        customTabBar.selectedItem = customTabBar.items![0]
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
        //开始动画
        startAnimate()
        //开始扫描
        startScan()
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    /**
     开始动画
     */
    fileprivate func startAnimate(){
        //让约束从顶部开始
        self.scanLineCons.constant = -self.containerHeightCons.constant
        //强制更新界面
//        self.scanLineView.layoutIfNeeded()
        
        
        UIView.animate(withDuration: 2.0, animations: {
            
            //修改约束
            self.scanLineCons.constant = self.containerHeightCons.constant
//            //设置动画的执行次数
            UIView.setAnimationRepeatCount(MAXFLOAT)
            //强制更新界面
            self.scanLineView.layoutIfNeeded()
        }) 
    }
    /**
     开始扫描
     */
    fileprivate func startScan(){
        //1.判断是否将输入添加到会话中
        if !session.canAddInput(deviceInput)
        {
            return
        }
        //2.判断是否将输出添加到会话中
        if !session.canAddOutput(output) {
            return
        }
        //3.将输入输出添加到会话中
        session.addInput(deviceInput)
        session.addOutput(output)
        //4.设置输出能够解析的数据类型
        //一定要在添加完之后设置类型否则会报错
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        //5.设置输出对象的代理,只要解析成功就会调用代理
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        //添加预览图层
        view.layer.insertSublayer(previewLayer, at: 0)
        //添加绘制图层
        previewLayer.addSublayer(drawLayer)
        //6.告诉session开始扫描
        session.startRunning()
    }
    //MARK: - UITabBarDelegate
    /**
     选中tabbar
     
     - parameter tabBar: tabbar
     - parameter item:   item
     */
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //1.修改容器高度
        if item.tag == 1 {
            self.containerHeightCons.constant = 300
        }
        else{
            self.containerHeightCons.constant = 150
        }
        //2.停止动画
//        self.scanLineView.layer.removeAllAnimations()
        startAnimate()
    }
    //MARK: - 懒加载
    //会话
    fileprivate lazy var session : AVCaptureSession = AVCaptureSession()
    //拿到输入设备
    fileprivate lazy var deviceInput : AVCaptureDeviceInput? = {
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do{
            let input = try AVCaptureDeviceInput(device: device)
            return input
        }catch
        {
            print(error)
            return nil
        }
        
    }()
    //拿到输出对象
    fileprivate lazy var output : AVCaptureMetadataOutput = AVCaptureMetadataOutput()
    //创建预览图层
    fileprivate lazy var previewLayer:AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: self.session)
        layer?.frame = UIScreen.main.bounds
        return layer!
    }()
    //创建边框图层
    fileprivate lazy var drawLayer:CALayer = {
       let layer = CALayer()
        layer.frame = UIScreen.main.bounds
        return layer
    }()

}
extension QRCodeViewController:AVCaptureMetadataOutputObjectsDelegate
{
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!)
    {
        //0.清空原来画的边框
        clearConers()
        //1.获取扫描到的数据
        resultText.text = (metadataObjects.last as AnyObject).stringValue
        resultText.sizeToFit()
        //2获取扫描到的二维码的位置
        //2.1 转换坐标
        for object in metadataObjects {
            //2.1.1判断当前获取到的坐标是否是机器可识别的
            if object is  AVMetadataMachineReadableCodeObject{
                //2.1.2将获取到的坐标转换为机器可识别的坐标
                let codeObject = previewLayer.transformedMetadataObject(for: object as! AVMetadataObject) as!AVMetadataMachineReadableCodeObject
                //2.2绘制图层
                drawCorners(codeObject)
                
            }
        }
    }
    /**
     绘制图层
     
     - parameter codeObject:
     */
    fileprivate func drawCorners(_ codeObject : AVMetadataMachineReadableCodeObject){
        if codeObject.corners.isEmpty {
            return
        }
        //1.创建一个图层
        let layer = CAShapeLayer()
        layer.lineWidth = 3
        layer.strokeColor = UIColor.green.cgColor
        layer.fillColor = UIColor.clear.cgColor
        //2.创建路径
        let path = UIBezierPath()
        var point = CGPoint.zero
        var index : Int = 0
        //2.1移动到第一个点
        //从corners数组中取出第一个元素将x/y赋值给point
        CGPointMakeWithDictionaryRepresentation((codeObject.corners[0] as! CFDictionary), &point)
        path.move(to: point)
        index += 1
        //2.2移动到其他的点
        while index < codeObject.corners.count {
            
            CGPointMakeWithDictionaryRepresentation((codeObject.corners[index] as! CFDictionary), &point)
            path.addLine(to: point)
            index += 1
        }
        //2.3关闭路径
        path.close()
        //2.4绘制路径
        layer.path = path.cgPath
        //3.将创建好的图层添加到drawLayer上
        drawLayer.addSublayer(layer)
    }
    /**
     *  每次绘制前清空原边线
     */
    fileprivate func clearConers(){
        if drawLayer.sublayers == nil || drawLayer.sublayers?.count == 0 {
            return
        }
        for subLayer in drawLayer.sublayers! {
            subLayer.removeFromSuperlayer()
        }
    }
}
