//
//  WPBillAnnimation.swift
//  Egoopay
//
//  Created by 易购付 on 2017/10/23.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPBillAnnimationView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(WPThemeColorView())
        self.addSubview(annulus_imageView)
//        initAnnimation()
        self.addSubview(income_label)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var annulus_imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: kScreenWidth / 2 - 80, y: 10, width: 160, height: 160))
        imageView.image = #imageLiteral(resourceName: "icon_yuanhuan")
        return imageView
    }()
    
    lazy var income_label: UILabel = {
        let label = UILabel(frame: CGRect(x: kScreenWidth / 2 - 80, y: self.annulus_imageView.center.y - 30, width: 160, height: 60))
        label.text = "收入\n 614.32"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight(rawValue: 2))
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 2
        return label
    }()
    
    func initAnnimation() {
        let layer = CALayer()
        layer.frame = CGRect(x: kScreenWidth / 2 - 80, y: 10, width: 160, height: 160)
        layer.backgroundColor = UIColor.yellow.cgColor
        self.layer.addSublayer(layer)
        
        //创建一个圆环
        let bezierPath = UIBezierPath.init(arcCenter: CGPoint(x: 80, y: 80), radius: 72, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        
        //圆环遮罩
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 5
        shapeLayer.strokeStart = 0
        shapeLayer.strokeEnd = 1
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.lineDashPhase = 0.8
        shapeLayer.path = bezierPath.cgPath
        layer.mask = shapeLayer
        
        let colors = [UIColor.red.cgColor, UIColor.yellow.cgColor, UIColor.white.cgColor]
        let gradientLayer = CAGradientLayer()
        gradientLayer.shadowPath = bezierPath.cgPath
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 160, height: 80)
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.colors = colors
        layer.addSublayer(gradientLayer)

        let colorsA = [UIColor.red.cgColor, UIColor.blue.cgColor, UIColor.lightGray.cgColor]
        let gradientLayerA = CAGradientLayer()
        gradientLayerA.shadowPath = bezierPath.cgPath
        gradientLayerA.frame = CGRect(x: 0, y: 80, width: 160, height: 80)
        gradientLayerA.startPoint = CGPoint(x: 1, y: 0)
        gradientLayerA.endPoint = CGPoint(x: 1, y: 1)
        gradientLayerA.colors = colorsA
        layer.addSublayer(gradientLayerA)

        let animation = CABasicAnimation.init(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = 2 * Double.pi
        animation.autoreverses = false
        animation.repeatCount = 1
        animation.duration = 2
        layer.add(animation, forKey: "groupAnnimation")
        
    }
    
}
