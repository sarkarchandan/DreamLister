//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Chandan Sarkar on 25.06.17.
//  Copyright © 2017 Chandan. All rights reserved.
//

import Foundation
import CoreData


public class Item: NSManagedObject {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.itemCreated = NSDate()
    }
}
