//
//  WPBillDatePicker.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/13.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

@objc protocol WPBillDataPickerViewDelegate {
    func selectedIndatePicker(year: String, month: String) -> Void
}

class WPBillDatePicker: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor.colorConvert(colorString: "#000000", alpha: 0.3)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.dismissPickerView)))

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    @objc func dismissPickerView() {
        
    }
    
}
