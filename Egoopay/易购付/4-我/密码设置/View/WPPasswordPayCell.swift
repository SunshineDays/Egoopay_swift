//
//  WPPasswordPayCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/22.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPPasswordPayCellID = "WPPasswordPayCellID"

class WPPasswordPayCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        password_textField.autocapitalizationType = .none
        password_textField.becomeFirstResponder()
        password_textField.layer.borderWidth = 1
        password_textField.layer.borderColor = UIColor.themeColor().cgColor
        password_textField.layer.cornerRadius = WPCornerRadius
        password_textField.layer.masksToBounds = true
        password_textField.addTarget(self, action: #selector(self.textFieldAction), for: .editingChanged)
        initPasswordContentView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initPasswordContentView() {
        let spaceWidth = (kScreenWidth - 2 * 15 - 5) / 6
        //分割线
        for i in 1 ..< 6 {
            let line_view = UIView.init(frame: CGRect.init(x: 15 + spaceWidth * CGFloat(i), y: password_textField.frame.minY, width: 1, height: password_textField.frame.height))
            line_view.backgroundColor = UIColor.lightGray
            self.contentView.addSubview(line_view)
        }
        //黑点
        for i in 0 ..< 6 {
            let dot_view = UIView.init(frame: CGRect.init(x: 15 + (spaceWidth + 1) * CGFloat(i) + spaceWidth / 2 - 5, y: password_textField.center.y - 5, width: 10, height: 10))
            dot_view.backgroundColor = UIColor.black
            dot_view.layer.cornerRadius = 5
            dot_view.isHidden = true
            dot_view.clipsToBounds = true
            self.contentView.addSubview(dot_view)
            self.dot_array.add(dot_view)
        }
        
    }
    
    //存放黑点的数组
    var dot_array = NSMutableArray()
    
    @IBOutlet weak var title_label: UILabel!
    
    @IBOutlet weak var password_textField: UITextField!

    @IBOutlet weak var state_label: UILabel!
    
    @IBOutlet weak var confirm_button: UIButton!
    
    var isHiddenButton: Bool! = nil {
        didSet {
            confirm_button.isHidden = isHiddenButton
            confirm_button.isUserInteractionEnabled = !isHiddenButton
            state_label.isHidden = !isHiddenButton
            if isHiddenButton {
                title_label.text = "请为账号 " + WPPublicTool.stringStar(string: WPUserDefaults.userDefaultsRead(key: WPUserDefaults_phone)!, headerIndex: 3, footerIndex: 4) + "\n\n" + "设置6位数字支付密码"
            }
            else {
                title_label.text = "请再次输入"
            }
        }
    }
    
    @objc func textFieldAction() {
        WPInterfaceTool.adjustButtonColor(button: confirm_button, array: [password_textField.text!])
        for i in 0 ..< dot_array.count {
            if i < (password_textField.text?.count)! {
                (dot_array[i] as! UIView).isHidden = false
            }
            else {
                (dot_array[i] as! UIView).isHidden = true
            }
        }
        
    }
}
