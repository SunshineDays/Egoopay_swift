//
//  WPEShopMyEvalutateCell.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/11.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

let WPEShopMyEvalutateCellID = "WPEShopMyEvalutateCellID"

typealias WPEShopMyEvalutateCellType = (_ stars: Int, _ text: String) -> Void

class WPEShopMyEvalutateCell: UITableViewCell, UITextViewDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        content_textView.becomeFirstResponder()
        content_textView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var title_imageView: UIImageView!
    
    @IBOutlet weak var allStar_view: UIView!
    
    @IBOutlet weak var placeholder_label: UILabel!
    
    @IBOutlet weak var content_textView: UITextView!
    
    
    var list_model: WPEShopMyOrderListProductsModel! = nil {
        didSet {
            title_imageView.sd_setImage(with: URL.init(string: list_model.image), placeholderImage: #imageLiteral(resourceName: "icon_shopDefaultPic"))
        }
    }
    
    var detail_model: WPEShopMyOrderDetailProductModel! = nil {
        didSet {
            title_imageView.sd_setImage(with: URL.init(string: detail_model.image), placeholderImage: #imageLiteral(resourceName: "icon_shopDefaultPic"))
        }
    }
    
    var stars: WPEShopMyEvalutateModel! = nil {
        didSet {
            allStar_view.addSubview(allStarView)
            content_textView.text = stars.contentText
        }
    }
    
    
    var eShopMyEvalutateCellType: WPEShopMyEvalutateCellType?
        
    lazy var allStarView: WPEvalutateStarView = {
        let view = WPEvalutateStarView()
        view.starsNumber = stars.stars
        weak var weakSelf = self
        view.evalutateStarType = {(star) -> Void in
            weakSelf?.stars.stars = star
            weakSelf?.eShopMyEvalutateCellType?(star, weakSelf?.content_textView.text ?? "")
        }
        return view
    }()
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if range == NSRange.init(location: 0, length: 1) || (range == NSRange.init(location: 0, length: 0) && text == "" ) {
            placeholder_label.isHidden = false
        }
        else {
            placeholder_label.isHidden = true
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        eShopMyEvalutateCellType?(stars.stars, textView.text ?? "")
    }
    
}
