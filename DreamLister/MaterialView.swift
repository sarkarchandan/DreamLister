//
//  MaterialView.swift
//  DreamLister
//
//  Created by Chandan Sarkar on 26.06.17.
//  Copyright © 2017 Chandan. All rights reserved.
//

import UIKit

//This variable denotes whether the material design is in action or not.
private var materilaKey = false

//This was a class but we now intend to make this an extension. That means that any class that will
//subcalss from the UIView will be able to use the customisation that we are going to add here.
extension UIView {
    
    //IBInspectable and IBDesignable are the ways to add customisations to our Views.
    //We have got to read the theory of how they work. In short it is the way to add the styling ability
    //into our view. The speciality however is it is an option that we can toggle on or off inside the storyboard
    //Thats why we are creating a getter/setter of type IbInspectable for the variable we have declared above.
    @IBInspectable var materialDesign: Bool{
        get{
            return materilaKey
        }
        set{
            //If someone adds a view that uses our extension, they need to able to select
            //whether or not they want the material design to be added to our view.
            materilaKey = newValue
            //Now we say that if the material design is selected than we are going to add some customisation
            //in the form of some shadow
            if materilaKey{
                self.layer.masksToBounds = false
                self.layer.cornerRadius = 3.0
                self.layer.shadowOpacity = 0.8
                self.layer.shadowRadius = 3.0
                self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                self.layer.shadowColor = UIColor(displayP3Red: 157/255, green: 157/255, blue: 157/255, alpha: 1.0).cgColor
            }else{
                self.layer.cornerRadius = 0
                self.layer.shadowRadius = 0
                self.layer.shadowOpacity = 0
                self.layer.shadowColor = nil
            }
        }
    }
}
