//
//  WPEvalutateStarView.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/11.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

typealias WPEvaluateStarType = (_ stars: Int) -> Void

class WPEvalutateStarView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect.init(x: 0, y: 0, width: 170, height: 40)
//        initStarButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var evalutateStarType: WPEvaluateStarType?
    
    var starsNumber: Int! = nil {
        didSet {
            initStarButton()
        }
    }
    
    func initStarButton() {
        let interval: CGFloat = 10
        let starWidth: CGFloat = 22
        for i in 0 ..< 5 {
            let button = UIButton.init(frame: CGRect.init(x: (interval + starWidth) * CGFloat(i), y: 0, width: starWidth, height: self.frame.size.height))
            button.imageView?.contentMode = .scaleAspectFit
            button.setImage(i < starsNumber ? #imageLiteral(resourceName: "icon_eShop_evaluate_starSelected") : #imageLiteral(resourceName: "icon_eShop_evaluate_starDefault"), for: .normal)
            button.tag = i
            button.addTarget(self, action: #selector(self.starAction(_:)), for: .touchUpInside)
            self.addSubview(button)
        }
    }
    
    
    @objc func starAction(_ button: UIButton) {
        for i in 0 ..< self.subviews.count {
            if i <= button.tag {
                (self.subviews[i] as? UIButton)?.setImage(#imageLiteral(resourceName: "icon_eShop_evaluate_starSelected"), for: .normal)
            }
            else {
                (self.subviews[i] as? UIButton)?.setImage(#imageLiteral(resourceName: "icon_eShop_evaluate_starDefault"), for: .normal)
            }
        }
        evalutateStarType!(button.tag + 1)
    }
}

class WPEvalutateStarShowView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect.init(x: 0, y: 0, width: 75, height: 10)
        //        initStarButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var starsNumber: Int! = nil {
        didSet {
            initStarImageView()
        }
    }
    
    func initStarImageView() {
        let interval: CGFloat = 3
        let starWidth: CGFloat = 12
        for i in 0 ..< 5 {
            let imageView = UIImageView.init(frame: CGRect.init(x: (interval + starWidth) * CGFloat(i), y: 0, width: starWidth, height: self.frame.size.height))
            imageView.contentMode = .scaleAspectFit
            imageView.image = i < starsNumber ? #imageLiteral(resourceName: "icon_eShop_evaluate_starSelected") : #imageLiteral(resourceName: "icon_eShop_evaluate_starDefault")
            self.addSubview(imageView)
        }
    }
    
    
}
