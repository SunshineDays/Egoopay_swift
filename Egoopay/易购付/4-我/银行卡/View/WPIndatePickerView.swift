//
//  WPIndatePickerView.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/29.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

@objc protocol WPIndatePickerViewDelegate {
    func selectedIndatePicker(year: String, month: String) -> Void
}

class WPIndatePickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        self.backgroundColor = UIColor.colorConvert(colorString: "#000000", alpha: 0.4)
        self.isUserInteractionEnabled = true
        
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.dismissPickerView)))
        
        initDateData()
        self.addSubview(pickerView)
        weak var weakSelf = self
        UIView.animate(withDuration: 0.3) {
            weakSelf?.pickerView.frame = CGRect(x: 0, y: kScreenHeight * 5 / 8, width: kScreenWidth, height: kScreenHeight * 3 / 8)

        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var pickerViewDelegate: WPIndatePickerViewDelegate?
    
    var year = String()
    var month = String()
    
    var data_array = NSMutableArray()
    
    func initDateData() {
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy"
        var year: NSInteger = NSInteger(formatter.string(from: date))!
        
        formatter.dateFormat = "MM"
        var month: NSInteger = NSInteger(formatter.string(from: date))!
        
        let year_array = NSMutableArray()
        let month_array = NSMutableArray()
        
        for _ in 0 ..< 10 {
            year_array.add(String(format: "%d", year))
            year = year + 1
        }
        
        for _ in 0 ..< 12 {
            month = month > 12 ? month - 12 : month
            month_array.add(String(format: "%@%d", month < 10 ? "0" : "", month))
            month = month + 1
        }
        data_array.addObjects(from: [month_array, year_array])
        self.year = year_array[0] as! String
        self.month = month_array[0] as! String
    }

    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: kScreenHeight / 3))
        pickerView.backgroundColor = UIColor.tableViewColor()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return data_array.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ((data_array[component] as! NSArray).count)
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 32
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.pickerViewDelegate?.selectedIndatePicker(year: year, month: month)
        return ((data_array[component] as! NSArray)[row] as? String)! + (component == 0 ? "月" : "年")
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        for lineView in pickerView.subviews {
            if lineView.frame.size.height < 1 {
                lineView.backgroundColor = UIColor.lightGray
            }
        }
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = NSTextAlignment.center
        label.backgroundColor = UIColor.clear
        label.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
//            month = self.pickerView(pickerView, titleForRow: row, forComponent: 0)!
            month = (data_array[0] as! NSArray)[row] as! String
        case 1:
//            year = self.pickerView(pickerView, titleForRow: row, forComponent: 1)!
            year = (data_array[1] as! NSArray)[row] as! String

        default:
            break
        }
        self.pickerViewDelegate?.selectedIndatePicker(year: year, month: month)
    }
    
    @objc func dismissPickerView() {
        weak var weakSelf = self
        UIView.animate(withDuration: 0.3, animations: {
            weakSelf?.pickerView.frame = CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: 0)
            weakSelf?.alpha = 0
        }) { (finished) in
            weakSelf?.removeFromSuperview()
        }
    }
}
