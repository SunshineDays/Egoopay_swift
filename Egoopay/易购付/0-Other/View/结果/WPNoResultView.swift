//
//  WPNoResultLabel.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/6.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit


class WPNoResultView: UIView {
    override func layoutSubviews() {
        superview?.layoutSubviews()
        self.backgroundColor = UIColor.white
    }
    
    func showResultView(view : UIView, loadAgain : @escaping (_ button : UIButton) -> ()) {
        showNoResultView(view: view, image: #imageLiteral(resourceName: "icon_noInternet"))
        loadAgain(self.load_button)
    }
    
    func showNoResultView(view: UIView, image: UIImage) {
        if !view.subviews.contains(self) {
            view.addSubview(self)
            self.frame = CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
            self.imageView.image = image
            self.addSubview(self.load_button)
        }
        self.isHidden = false
    }
    
    func showNoResultView(view: UIView, image: UIImage, title: String) {
        if !view.subviews.contains(self) {
            view.addSubview(self)
            self.frame = CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
            self.imageView.image = image
            self.title_label.text = title
            self.addSubview(self.load_button)
        }
        self.isHidden = false
    }
    
    func hiddenNoResultView() {
        
        self.isHidden = true
        self.removeFromSuperview()
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView.init(frame: CGRect.init(x: self.frame.size.width / 4, y: self.frame.size.height / 2 - self.frame.size.width / 4, width: self.frame.size.width / 2, height: self.frame.size.width / 2))
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
        return imageView
    }()
    
    lazy var title_label: UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: 0, y: self.imageView.frame.maxY + 10, width: self.frame.size.width, height: 20))
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.darkGray
        self.addSubview(label)
        return label
    }()
    
    lazy var load_button: UIButton = {
        let button = UIButton.init(frame: self.frame)
        return button
    }()
}


class WPNoResultTitleView: UIView {
    override func layoutSubviews() {
        superview?.layoutSubviews()
        self.backgroundColor = UIColor.white
    }
    
    func showResultView(view : UIView, loadAgain : @escaping (_ button : UIButton) -> ()) {
        showNoResultView(view: view, image: #imageLiteral(resourceName: "icon_noInternet"))
        loadAgain(self.load_button)
    }
    
    func showNoResultView(view: UIView, image: UIImage) {
        if !view.subviews.contains(self) {
            view.addSubview(self)
            self.frame = CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
            self.addSubview(self.imageView)
            self.imageView.image = image
            self.addSubview(self.load_button)
        }
        self.isHidden = false
    }
    
    func hiddenNoResultView() {
        self.isHidden = true
        self.removeFromSuperview()
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView.init(frame: CGRect.init(x: self.frame.size.width / 4, y: self.frame.size.height / 2 - self.frame.size.width / 4, width: self.frame.size.width / 2, height: self.frame.size.width / 2))
        return imageView
    }()
    
    lazy var load_button: UIButton = {
        let button = UIButton.init(frame: self.frame)
        return button
    }()
}

