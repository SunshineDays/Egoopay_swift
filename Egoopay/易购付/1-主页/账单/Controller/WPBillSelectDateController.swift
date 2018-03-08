//
//  WPBillSelectDateController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/10/20.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

/**  选择账单时间 */
typealias WPSelectedBillDateType = (_ year : String, _ month : String) -> Void

class WPBillSelectDateController: WPBaseViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(title_view)
        initDateData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var selectedBillDateType: WPSelectedBillDateType?
    
    lazy var title_view: WPTitleView = {
        let view = WPTitleView()
        weak var weakSelf = self
        view.leftAndRightButtonType = {(leftButton, rightButton) -> Void in
            weakSelf?.dismiss(animated: true, completion: nil)
            if rightButton != nil {
                weakSelf?.selectedBillDateType?((weakSelf?.year)!, (weakSelf?.month)!)
            }
        }
        return view
    }()
    
    lazy var selected_label: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: kScreenHeight / 6, width: kScreenWidth, height: 40))
        label.text = self.year + " - " + self.month
        label.textColor = UIColor.themeColor()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    lazy var line_view: UIView = {
        let view = UIView(frame: CGRect(x: WPLeftMargin, y: self.selected_label.frame.maxY, width: kScreenWidth - 2 * WPLeftMargin, height: 1))
        view.backgroundColor = UIColor.themeColor()
        return view
    }()
    
    var year = String()
    
    var month = String()
    
    var yearRow = NSInteger()
    
    var year_array = NSMutableArray()
    
    var month_array = NSMutableArray()
    
    func initDateData() {
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy"
        let nowYear: NSInteger = NSInteger(formatter.string(from: date))!
        self.year = String(format: "%ld", nowYear)
        
        formatter.dateFormat = "MM"
        let nowMonth: NSInteger = NSInteger(formatter.string(from: date))!
        self.month = (nowMonth < 10 ? "0" : "") + String(format: "%ld", nowMonth)
        
        let yearArrM = NSMutableArray()
        let monthArrM = NSMutableArray()
        
        let firstYear = 2015
        let firstMonth = 4
        
        //获取年份数组
        for i in firstYear ... nowYear {
            yearArrM.add(String(format: "%ld", i))
        }
        self.year_array = yearArrM
        
        //获取每一个年份对应月份的数组
        let firstArray = NSMutableArray()
        for i in firstMonth ... 12 {
            firstArray.add(String(format: "%ld", i))
        }
        
        let centerArray = NSMutableArray()
        for i in 1 ... 12 {
            centerArray.add(String(format: "%ld", i))
        }
        
        let lastArray = NSMutableArray()
        for i in 1 ... nowMonth {
            lastArray.add(String(format: "%ld", i))
        }
        
        //根据年份添加数组
        if nowYear == firstYear {
            let array = NSMutableArray()
            for i in firstMonth ... nowMonth {
                array.add(String(format: "%ld", i))
            }
            monthArrM.add(array)
        }
        if nowYear - firstYear == 1 {
            monthArrM.addObjects(from: [firstArray, lastArray])
        }
        if nowYear - firstYear > 1 {
            monthArrM.add(firstArray)
            for _ in 1 ..< nowYear - firstYear {
                monthArrM.add(centerArray)
            }
            monthArrM.add(lastArray)
        }
        
        self.month_array = monthArrM
        
        self.yearRow = self.year_array.count - 1
        
        self.view.addSubview(selected_label)
        self.view.addSubview(line_view)
        
        self.pickerView.selectRow(self.year_array.count - 1, inComponent: 0, animated: true)
        self.pickerView.selectRow((self.month_array.lastObject as! NSArray).count - 1, inComponent: 1, animated: true)
    }
    
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: kScreenHeight / 3, width: kScreenWidth, height: kScreenHeight / 3))
        pickerView.backgroundColor = UIColor.backgroundColor()
        pickerView.layer.borderColor = UIColor.lineColor().cgColor
        pickerView.layer.borderWidth = WPLineHeight
        pickerView.delegate = self
        pickerView.dataSource = self
        self.view.addSubview(pickerView)
        return pickerView
    }()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 32
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? self.year_array.count : (self.month_array[self.yearRow] as! NSArray).count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            self.year = self.year_array[row] as! String
        }
        else {
            self.month = (self.month_array[self.yearRow] as! NSArray)[row] as! String
            if Int(self.month)! < 10 {
                self.month = "0" + self.month
            }
        }
        self.selected_label.text = self.year + " - " + self.month

        return component == 0 ? (self.year_array[row] as! String + "年") : ((self.month_array[self.yearRow] as! NSArray)[row] as! String + "月")
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
        if component == 0 {
            self.yearRow = row
        }
        pickerView.reloadAllComponents()

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
