//
//  ItemType+CoreDataProperties.swift
//  DreamLister
//
//  Created by Chandan Sarkar on 25.06.17.
//  Copyright © 2017 Chandan. All rights reserved.
//

import Foundation
import CoreData


extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType")
    }

    @NSManaged public var itemType: String?
    @NSManaged public var toItem: Item?

}
