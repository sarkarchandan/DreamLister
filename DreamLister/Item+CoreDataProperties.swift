//
//  Item+CoreDataProperties.swift
//  DreamLister
//
//  Created by Chandan Sarkar on 25.06.17.
//  Copyright © 2017 Chandan. All rights reserved.
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var itemCreated: NSDate?
    @NSManaged public var itemDescription: String?
    @NSManaged public var itemName: String?
    @NSManaged public var itemPrice: Double
    @NSManaged public var toImage: Image?
    @NSManaged public var toItemType: ItemType?
    @NSManaged public var toStore: Store?

}
