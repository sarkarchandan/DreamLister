//
//  DreamItemCellTableViewCell.swift
//  DreamLister
//
//  Created by Chandan Sarkar on 26.06.17.
//  Copyright © 2017 Chandan. All rights reserved.
//

import UIKit

class DreamItemCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemImageThumbnailImage: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    
    //This is our primary configureCell() method that will actually update the TableViewCell
    func configureCell(dreamItem: Item){
        itemNameLabel.text = dreamItem.itemName
        itemPriceLabel.text = "$\(dreamItem.itemPrice)"
        itemDescriptionLabel.text = dreamItem.itemDescription
        itemImageThumbnailImage.image = dreamItem.toImage?.image as? UIImage
        //We will handle the Image later
    }
}
