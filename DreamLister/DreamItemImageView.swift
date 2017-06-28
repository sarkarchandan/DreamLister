//
//  DreamItemImageView.swift
//  DreamLister
//
//  Created by Chandan Sarkar on 26.06.17.
//  Copyright © 2017 Chandan. All rights reserved.
//

import UIKit

class DreamItemImageView: UIImageView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 3.0
        self.clipsToBounds = true
    }

}
