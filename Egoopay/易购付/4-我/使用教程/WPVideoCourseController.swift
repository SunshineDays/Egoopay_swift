//
//  WPVideoCourseController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/12/22.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPVideoCourseController: WPBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "使用教程"
        scrollView.addSubview(panpel_imageView)
        initButtons()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let buttonImage_array = WPJudgeTool.isText() ? [#imageLiteral(resourceName: "icon_button_shiming"), #imageLiteral(resourceName: "icon_button_card")] : [#imageLiteral(resourceName: "icon_button_quxian"), #imageLiteral(resourceName: "icon_button_xinshou"), #imageLiteral(resourceName: "icon_button_shiming"), #imageLiteral(resourceName: "icon_button_card")]
    
    let title_array = WPJudgeTool.isText() ? ["实名认证", "绑定银行卡"] : ["取现流程", "新手指导", "实名认证", "绑定银行卡"]
    
    let contentImage_array = WPJudgeTool.isText() ? [#imageLiteral(resourceName: "icon_shimingrenzheng"), #imageLiteral(resourceName: "icon_button_bangdingyinhangka")] : [#imageLiteral(resourceName: "icon_quxianliucheng"), #imageLiteral(resourceName: "icon_xinshouyindao"), #imageLiteral(resourceName: "icon_shimingrenzheng"), #imageLiteral(resourceName: "icon_button_bangdingyinhangka")]

    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight))
        self.view.addSubview(scrollView)
        scrollView.addSubview(WPThemeColorView())
        return scrollView
    }()
    
    lazy var panpel_imageView: UIImageView = {
        let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth * 463 / 1080))
        imageView.image = #imageLiteral(resourceName: "oval_bg")
        self.view.addSubview(imageView)
        return imageView
    }()
    
    func initButtons() {
        let height = (kScreenWidth - 80) * 314 / 816
        for i in 0 ..< buttonImage_array.count {
            let button = UIButton.init(frame: CGRect.init(x: 40, y: 20 + CGFloat(i) * (height + 20), width: kScreenWidth - 80, height: height))
            button.setBackgroundImage(buttonImage_array[i], for: .normal)
            button.tag = i
            button.addTarget(self, action: #selector(self.selectAction(_:)), for: .touchUpInside)
            scrollView.addSubview(button)
            scrollView.contentSize = CGSize.init(width: kScreenWidth, height: button.frame.maxY + 20)
        }
    }
    
    @objc func selectAction(_ button: UIButton) {
        let vc = WPPictureIntroController()
        vc.navigationItem.title = title_array[button.tag]
        vc.intro_image = contentImage_array[button.tag]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
