//
//  BillList+CoreDataProperties.swift
//  
//
//  Created by 易购付 on 2018/2/28.
//
//

import Foundation
import CoreData


extension BillList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BillList> {
        return NSFetchRequest<BillList>(entityName: "BillList")
    }

    @NSManaged public var orderno: String?
    @NSManaged public var tradeTypeName: String?
    @NSManaged public var amount: Float
    @NSManaged public var tradeType: NSObject?
    @NSManaged public var inPaystate: NSObject?
    @NSManaged public var createDate: String?
    @NSManaged public var payStateName: String?
    
}
