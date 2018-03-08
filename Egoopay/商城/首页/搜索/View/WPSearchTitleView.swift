//
//  WPSearchTitleView.swift
//  Egoopay
//
//  Created by 易购付 on 2017/12/27.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

typealias WPSearchTitleType = (_ search: String) -> Void

class WPSearchTitleView: UIView, UISearchBarDelegate {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: WPNavigationHeight)
        self.addSubview(goBack_button)
        self.addSubview(searchBar)
        self.addSubview(line_view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isPush = true
    
    var searchTitleType: WPSearchTitleType?
    
    lazy var goBack_button: UIButton = {
        let button = UIButton.init(frame: CGRect.init(x: 15, y: WPStatusBarHeight, width: 50, height: 44))
        button.setImage(#imageLiteral(resourceName: "icon_goBack_goBack"), for: .normal)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar.init(frame: CGRect.init(x: 50, y: WPStatusBarHeight + 5, width: kScreenWidth - 65, height: 34))
        searchBar.backgroundColor = UIColor.colorConvert(colorString: "ffffff", alpha: 0.2)
        searchBar.placeholder = "搜索商品"
        searchBar.subviews[0].subviews[0].removeFromSuperview()
        searchBar.layer.borderColor = UIColor.lineColor().cgColor
        searchBar.layer.borderWidth = WPLineHeight
        searchBar.layer.cornerRadius = 12
        searchBar.subviews[0].subviews[0].backgroundColor = UIColor.clear
        searchBar.delegate = self
        return searchBar
    }()
    
    lazy var line_view: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: self.frame.size.height - 0.5, width: kScreenWidth, height: 0.5))
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let vc = WPEShopSearchController()
        vc.isPush = isPush
        weak var weakSelf = self
        vc.eShopSearchType = {(search) -> Void in
            weakSelf?.searchTitleType?(search)
        }
        WPInterfaceTool.rootViewController().present(vc, animated: false, completion: nil)
    }
    
//    @objc func goBackAction() {
//
//        WPUserDefaults.userDefaultsSave(key: WPUserDefaults_isEShop, value: nil)
//
//        let animation = CATransition()
//        animation.duration = 0.25
//        animation.type = kCATransitionMoveIn
//
//        UIApplication.shared.keyWindow?.layer.add(animation, forKey: "animation")
//        UIApplication.shared.keyWindow?.rootViewController = WPTabBarController()
//        UserDefaults.standard.synchronize()
//
//    }
    

}
