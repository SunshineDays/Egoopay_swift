//
//  WPPasswordIDApproveCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/22.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPPasswordIDApproveCellID = "WPPasswordIDApproveCellID"

class WPPasswordIDApproveCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 15, height: 0))
        number_textField.leftView = view
        number_textField.leftViewMode = .always
        number_textField.becomeFirstResponder()
        number_textField.addTarget(self, action: #selector(self.textFieldAction), for: .editingChanged)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var title_label: UILabel!
    
    @IBOutlet weak var number_textField: UITextField!
    
    @IBOutlet weak var next_button: UIButton!
    
    var model: WPUserApproveModel! = nil {
        didSet {
            title_label.text = "填写 " + WPPublicTool.stringStar(string: model.fullName, headerIndex: 0, footerIndex: 2) + "的身份证号码 验证身份"
        }
    }
    
    @objc func textFieldAction() {
        WPInterfaceTool.adjustButtonColor(button: next_button, array: [number_textField.text!])
    }
}
