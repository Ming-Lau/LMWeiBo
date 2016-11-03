//
//  QRCodeCardViewController.swift
//  LMWeiBo
//
//  Created by 刘明 on 16/6/12.
//  Copyright © 2016年 LM. All rights reserved.
//

import UIKit

class QRCodeCardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        //1.设置标题
        navigationItem.title = "我的名片"
        //2.添加图片容器
        view.addSubview(iconView)
        //3.布局图片容器
        iconView.xmg_AlignInner(type: XMG_AlignType.center, referView: view, size: CGSize(width: 200, height: 200))
        //4.生成二维码
        let qrCodeImage = createQRCoedImage()
        
        //5.将生成好的二维码添加到图片容器上
        iconView.image = qrCodeImage
    }
    //生成二维码图片
    fileprivate func createQRCoedImage()->UIImage{
        //1.创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        //2.还原滤镜默认属性
        filter?.setDefaults()
        //3.设置需要生成的二维码数据
        filter?.setValue("刘明".data(using: String.Encoding.utf8), forKey: "inputMessage")
        //4.从滤镜中取出生成好的图片
        let ciImage = filter?.outputImage
        let bgImage = createNonInterpolatedUIImageFormCIImage(ciImage!, size: 300)
        
        //5.创建一个头像
        let icon = UIImage(named: "qrcode_tabbar_icon_qrcode_highlighted")
        //6.合成图片
        let newImage = creatImage(bgImage, icomImage: icon!)
        
        //7.返回合成后的二维码
        return newImage
    }
    /**
     合成图片
     
     - parameter bgImage:   背景图片
     - parameter icomImage: 头像
     
     - returns: 合成后的图片
     */
    fileprivate func creatImage(_ bgImage:UIImage , icomImage : UIImage)->UIImage{
        //1.开启上下文
        UIGraphicsBeginImageContext(bgImage.size)
        //2.绘制背景图片
        bgImage.draw(in: CGRect(origin: CGPoint.zero, size: bgImage.size))
        //3.绘制头像
        let width:CGFloat = 50
        let height:CGFloat = width
        let x = (bgImage.size.width - width)*0.5
        let y = (bgImage.size.height - height)*0.5
        icomImage.draw(in: CGRect(x: x, y: y, width: width, height: height))
        //4.取出绘制好的图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        //5.关闭上下文
        UIGraphicsEndImageContext()
        //6.返回合成好的图片
        return newImage!
    }
    /**
     根据CIImage生成指定大小的高清UIImage
     
     :param: image 指定CIImage
     :param: size    指定大小
     :returns: 生成好的图片
     */
    fileprivate func createNonInterpolatedUIImageFormCIImage(_ image: CIImage, size: CGFloat) -> UIImage {
        
        let extent: CGRect = image.extent.integral
        let scale: CGFloat = min(size/extent.width, size/extent.height)
        
        // 1.创建bitmap;
        let width = extent.width * scale
        let height = extent.height * scale
        let cs: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImage = context.createCGImage(image, from: extent)!
        
        bitmapRef.interpolationQuality = CGInterpolationQuality.none
        bitmapRef.scaleBy(x: scale, y: scale);
        bitmapRef.draw(bitmapImage, in: extent);
        
        // 2.保存bitmap到图片
        let scaledImage: CGImage = bitmapRef.makeImage()!
        
        return UIImage(cgImage: scaledImage)
    }
    //MARK: - 懒加载
    //二维码图片
    fileprivate lazy var iconView : UIImageView = UIImageView()
}
