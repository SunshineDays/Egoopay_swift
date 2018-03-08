//
//  UIColor+Extension.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/6.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import Foundation

extension UIColor {
    
    /** 透明度可变 */
    class func colorConvert(colorString: String, alpha: CGFloat) -> UIColor {
        
        var  Str :NSString = colorString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased() as NSString
        if colorString.hasPrefix("#"){
            Str = (colorString as NSString).substring(from: 1) as NSString
        }
        
        let redStr = (Str as NSString ).substring(to: 2)
        let greenStr = ((Str as NSString).substring(from: 2) as NSString).substring(to: 2)
        let blueStr = ((Str as NSString).substring(from: 4) as NSString).substring(to: 2)
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        
        Scanner(string:redStr).scanHexInt32(&r)
        Scanner(string: greenStr).scanHexInt32(&g)
        Scanner(string: blueStr).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
    }
    
    /** 透明度为1 */
    class func colorConvert(colorString: String) -> UIColor {
        return self.colorConvert(colorString: colorString, alpha: 1)
    }
    
    /** 主题／导航栏颜色 */
    class func themeColor() -> UIColor {
        return self.colorConvert(colorString: "#0378DB", alpha: 1)
    }
    
    class func themeEShopColor() -> UIColor {
        return self.colorConvert(colorString: "32A77A", alpha: 1)
    }
        
    class func backgroundColor() -> UIColor {
        return self.colorConvert(colorString: "#FDFDFD", alpha: 1)
    }
    
    /**  TableView背景颜色 */
    class func tableViewColor() -> UIColor {
        return self.colorConvert(colorString: "#F5F4F9", alpha: 1)
    }
    
    /** 分割线颜色 */
    class func lineColor() -> UIColor {
        return self.colorConvert(colorString: "#e6e6e6", alpha: 1)
    }
    
    /** 占位字符颜色 */
    class func placeholderColor() -> UIColor {
        return self.colorConvert(colorString: "#C7C7CD", alpha: 1)
    }
    
    /** 按钮文字颜色 */
    class func buttonTitleColor() -> UIColor {
        return UIColor.white
    }
    
    /**  红色字 */
    class func priceTextColor() -> UIColor {
        return self.colorConvert(colorString: "F30000", alpha: 1)
    }
}
