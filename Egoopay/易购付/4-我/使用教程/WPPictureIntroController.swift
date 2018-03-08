//
//  WPPictureIntroController.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/27.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

class WPPictureIntroController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.backgroundColor()
        scale = intro_image.size.height / intro_image.size.width
        scrollView.addSubview(imageView)
        scrollView.contentSize = CGSize.init(width: kScreenWidth, height: imageView.frame.height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var intro_image = UIImage()
    
    var scale = CGFloat()

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: WPTopY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight))
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        self.view.addSubview(scrollView)
        return scrollView
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth * scale))
        imageView.image = intro_image
        return imageView
    }()
    
    
    

}
