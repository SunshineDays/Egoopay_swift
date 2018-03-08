//
//  WPPublicTool.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/6.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPPublicTool: NSObject {
    
    /**  String -> base64 */
    class func base64EncodeString(string: String) -> String {
        let data = string.data(using: String.Encoding.utf8)
        
        let resultString = data?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: UInt(0)))
        
        return resultString!
    }
    
    /**  base64 -> String */
    class func base64DecodeString(string: String) -> String {
        let data = NSData(base64Encoded:string, options:NSData.Base64DecodingOptions(rawValue: 0))
        
        let resultString = String(data:data! as Data, encoding:String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        
        return resultString!
    }
    
    /**  json -> String */
    class func jsonToString(any: Any) -> String {
        let data = try?JSONSerialization.data(withJSONObject: any, options: .prettyPrinted)
        let json = String.init(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        return json ?? ""
    }
    
    /**  image -> String */
    class func imageToString(image: UIImage) -> String {
        var data = UIImageJPEGRepresentation(image, 1.0)
        
        let scale: Float = Float(180 / (Float((data?.count)! / 1024)))
        data = UIImageJPEGRepresentation(image, scale < 1 ? CGFloat(scale) : 1)
        
        let image_string = data?.base64EncodedString(options: .lineLength64Characters)
        return image_string!
    }
    
    /**  带*的字符串 */
    class func stringStar(string: String, headerIndex: Int, footerIndex: Int) -> String {
        let data_string: NSString = string as NSString
        
        let header_string = headerIndex == 0 ? "" : data_string.substring(to: headerIndex)
        let footer_string = footerIndex == 0 ? "" : data_string.substring(with: NSMakeRange(data_string.length - footerIndex, footerIndex))
        
        let starNumber_int = data_string.length - headerIndex - footerIndex
        var star_string = ""
        for i in 0 ..< starNumber_int {
            star_string = star_string + (i % 4 == 0 ? " *" : "*")
        }
        let result_string = header_string + star_string + " " + footer_string
        return result_string
    }
    
    /**  获取文本高度 */
    class func getTextHeigh(textStr: String, fontSize: CGFloat, width: CGFloat) -> CGFloat {
        let normalText: NSString = textStr as NSString
        let size = CGSize(width: width, height: 1000)
        let dic = NSDictionary(object: UIFont.systemFont(ofSize: fontSize), forKey: NSAttributedStringKey.font as NSCopying)
        let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey : Any], context:nil).size
        return stringSize.height > WPRowHeight ? stringSize.height : WPRowHeight
    }
    
    /**  获取文本宽度 */
    class func getTexWidth(textStr: String, fontSize: CGFloat, height: CGFloat) -> CGFloat {
        
        let normalText: NSString = textStr as NSString
        
        let size = CGSize(width: 1000, height: height)
        
        let dic = NSDictionary(object: UIFont.systemFont(ofSize: fontSize), forKey: NSAttributedStringKey.font as NSCopying)
        
        let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey : Any], context:nil).size
        
        return stringSize.width
        
    }
    
    /**  String -> 自定义日期 */
    @objc class func stringCustom(date: String) -> String {
        return self.stringFromDate(dateString: self.stringToDate(date: date))
    }
    
    /**  Sring -> 日期 */
    class func stringToDate(date: String) -> String {
        
        if date.contains("AM") || date.contains("PM") {
            let inputFormatter = DateFormatter()
            inputFormatter.locale = Locale.init(identifier: "en_US");
            inputFormatter.dateFormat = "MMM d, yyyy h:mm:ss aa"
            let inputDate: Date = inputFormatter.date(from: date)!
            
            let zone: NSTimeZone = NSTimeZone.system as NSTimeZone
            let interval: NSInteger = zone.secondsFromGMT(for: inputDate)
            let localDate: Date = inputDate.addingTimeInterval(TimeInterval(interval))
            
            var dateString: NSString = NSString.init(string: String(describing: localDate))
            if dateString.length > 9 {
                dateString = dateString.substring(to: dateString.length - 9) as NSString
            }
            return dateString as String
        }
        else {
            return date
        }
    }
    
    /**  日期 -> 自定义日期 */
    class func stringFromDate(dateString: String) -> String {
//        if dateString.count > 0 {
            var resultString = String()
            
            let date = Date()
            let formatter = DateFormatter()
            
            formatter.dateFormat = "yyyy"
            let nowYear: NSInteger = NSInteger(formatter.string(from: date))!
            
            formatter.dateFormat = "MM"
            let nowMonth: NSInteger = NSInteger(formatter.string(from: date))!
            
            formatter.dateFormat = "dd"
            let nowDay: NSInteger = NSInteger(formatter.string(from: date))!
            
            let year: NSInteger = NSInteger((dateString as NSString).substring(to: 4))!
            
            let month: NSInteger = NSInteger((dateString as NSString).substring(with: NSMakeRange(5, 2)))!
            
            let day: NSInteger = NSInteger((dateString as NSString).substring(with: NSMakeRange(8, 2)))!
            
            if nowYear == year {
                if nowMonth == month {
                    if nowDay == day {
                        resultString = "今天  " + (dateString as NSString).substring(from: 11)
                    }
                    else if nowDay - day == 1 {
                        resultString = "昨天  " + (dateString as NSString).substring(from: 11)
                    }
                    else {
                        resultString = (dateString as NSString).substring(from: 5)
                    }
                }
                else {
                    resultString = (dateString as NSString).substring(from: 5)
                }
            }
            else {
                resultString = dateString
            }
            
            return resultString
//        }
//        else {
//            return dateString
//        }
    }
    
    /**  日期 -> 月份 */
    class func StringMonthDate(dateString: String) -> String {
        var resultString = String()
        
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy"
        let nowYear: NSInteger = NSInteger(formatter.string(from: date))!
        
        formatter.dateFormat = "MM"
        let nowMonth: NSInteger = NSInteger(formatter.string(from: date))!
        
        let year: NSInteger = NSInteger((dateString as NSString).substring(to: 4))!
        
        let month: NSInteger = NSInteger((dateString as NSString).substring(with: NSMakeRange(5, 2)))!
        
        if nowYear == year {
            if nowMonth == month {
                resultString = "本月"
            }
            else {
                resultString = String(month) + "月"
            }
        }
        else {
            resultString = String(year) + "年" + String(month) + "月"
        }
        
        return resultString
    }
    
    /**  清除WebView缓存 */
    class func celanCacheAndCookie() {
        //清除cookies
        var storage = HTTPCookieStorage.shared.cookies
        let count = storage?.count ?? 0
        if count > 0 {
            for i in 0 ..< count {
                storage?.remove(at: i)
            }
        }
        
        //清除UIWebView的缓存
        URLCache.shared.removeAllCachedResponses()
        let cache = URLCache.shared
        cache.removeAllCachedResponses()
        cache.diskCapacity = 0
        cache.memoryCapacity = 0
    }
    
    /**  打印请求到的数据 */
    class func printResultModel(result: NSDictionary, key: String?) {
        var dic = NSDictionary()
        if key != nil {
            if (result[key!] as AnyObject).isKind(of: NSClassFromString("NSDictionary")!) {
                dic = result[key!] as! NSDictionary
            }
            if (result[key!] as AnyObject).isKind(of: NSClassFromString("NSArray")!) {
                dic = (result[key!] as! NSArray)[0] as! NSDictionary
            }
        }
        else {
            dic = result
        }
        
        for kv in dic {
            print("\n")
            let value = kv.value as AnyObject
            if value.isKind(of: NSClassFromString("__NSCFString")!) {
                print(String(format: "@objc var %@ = String()", kv.key as! CVarArg))
            }
            else if value.isKind(of: NSClassFromString("__NSCFNumber")!) {
                print(String(format: "@objc var %@ = <#NSInteger/Float#>()", kv.key as! CVarArg))
            }
            else if value.isKind(of: NSClassFromString("__NSCFBoolean")!) {
                print(String(format: "@objc var %@ = Bool()", kv.key as! CVarArg))
            }
            else if value.isKind(of: NSClassFromString("NSDictionary")!) {
                print(String(format: "@objc var %@ = NSDictionary()", kv.key as! CVarArg))
            }
            else if value.isKind(of: NSClassFromString("NSArray")!) {
                print(String(format: "@objc var %@ = NSArray()", kv.key as! CVarArg))
            }
            else {
                print(String(format: "@objc var %@ = <#category#>()", kv.key as! CVarArg))
            }
        }
    }
 
    
    class func attributedString(text: String, font: CGFloat, color: UIColor) -> NSAttributedString {
        let attributes = NSMutableDictionary()
        attributes[NSAttributedStringKey.font] = UIFont.systemFont(ofSize: font)
        attributes[NSAttributedStringKey.foregroundColor] = color
        return NSAttributedString.init(string: text, attributes: attributes as? [NSAttributedStringKey : Any])
    }
    
}
