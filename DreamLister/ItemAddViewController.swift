//
//  ItemAddViewController.swift
//  DreamLister
//
//  Created by Chandan Sarkar on 27.06.17.
//  Copyright © 2017 Chandan. All rights reserved.
//

import UIKit
import CoreData

class ItemAddViewController: UIViewController,
UIPickerViewDataSource,
UIPickerViewDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    
    @IBOutlet weak var storePickerView : UIPickerView!
    @IBOutlet weak var itemTitleLabel: UITextField!
    @IBOutlet weak var itemPrice: UITextField!
    @IBOutlet weak var itemDescription: UITextField!
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var typePickerView: UIPickerView!
    
    
    //For fetching and storing the Stores into a collection
    var storesArray = [Store]()
    
    //For fetching and storing the ItemTypes into collection
    var itemTypesArray = [ItemType]()
    
    //And optional which will contain the Item that we want to edit and will be used to
    //load the Item into this ViewController so that we could edit the same.
    var itemToEdit: Item?
    
    //Declaring the variable of type UIImagePickerController.
    //This is required for implementing the ImagePicker in ItemAddScreen for choosing an Image
    //for the item that we are adding
    var itemImagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        storePickerView.delegate = self
        storePickerView.dataSource = self
        
        typePickerView.dataSource = self
        typePickerView.delegate = self
        
        //This below statement was necessary to get rid of the extra title coming after the bakc button in this
        //ViewController. So we have got the reference of the back button from the navigation controller and 
        //disabled the title.
        if let topItem = self.navigationController?.navigationBar.topItem{
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        //createDummyType()
        fetchItemTypes()
        //createDummyStore()
        fetchStore()
        
        //When the itemToEdit is not nil that means we want to load the Item here to edit.
        if itemToEdit != nil{
            loadItemData()
        }
        
        //Instantiating the UIImagePicker
        itemImagePicker = UIImagePickerController()
        //Telling that this ViewController would be the delegate for the UIImagePickerController
        itemImagePicker.delegate = self
        
        
    }
    
    //This is a function to create some dummy store data
//    func createDummyStore(){
//        let store1 = Store(context: context)
//        store1.storeName = "WallMart"
//        
//        let store2 = Store(context: context)
//        store2.storeName = "Amazon"
//        
//        let store3 = Store(context: context)
//        store3.storeName = "Google PlayStore"
//        
//        let store4 = Store(context: context)
//        store4.storeName = "Apple Store"
//        
//        let store5 = Store(context: context)
//        store5.storeName = "MediaMarkt"
//        
//        appDelegate.saveContext()
//    }
    
    //Creating Dummy Item Types
    //One time function
//    func createDummyType(){
//        let type1 = ItemType(context: context)
//        type1.itemType = "Console"
//        
//        let type2 = ItemType(context: context)
//        type2.itemType = "Game"
//        
//        let type3 = ItemType(context: context)
//        type3.itemType = "Work Staton"
//        
//        let type4 = ItemType(context: context)
//        type4.itemType = "Ride"
//        
//        appDelegate.saveContext()
//    }
    
    func fetchItemTypes(){
        let itemTypeFetchRequest: NSFetchRequest<ItemType> = ItemType.fetchRequest()
        do{
            self.itemTypesArray = try context.fetch(itemTypeFetchRequest)
            self.typePickerView.reloadAllComponents()
        }catch{
            let error = error as NSError
            print("\(error)")
        }
        print("ItemTypeArray Count: \(self.itemTypesArray.count)")
    }
    
    
    
    func fetchStore(){
        let storeFetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        do{
            self.storesArray = try context.fetch(storeFetchRequest)
            self.storePickerView.reloadAllComponents()
        }catch{
            let error = error as NSError
            print("\(error)")
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1{
            let type = itemTypesArray[row]
            return type.itemType
        }else{
            let store = storesArray[row]
            return store.storeName
        }
    }
    
    //This is obvious that how many rows are there in the PickerView
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1{
            return itemTypesArray.count
        }else{
            return storesArray.count
        }
    }
    
    //This denotes how many columns there are. We are only going to have one
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //
    }
    
    @IBAction func createItemPressed(_ sender: Any) {
        
        var newItem: Item!
        
        //Instantisting the Image Entity with context
        let picture = Image(context: context)
        //Assigning the image attribute of the Entity as the Image that we have selected
        picture.image = thumbImage.image
        //Building the relation between the ItemEntity and the ImageEnity
        
        
        if itemToEdit != nil{
            newItem = itemToEdit
        }else{
            newItem = Item(context: context)
        }
        
        if let title = itemTitleLabel.text{
            newItem.itemName = title
        }
        if let price = itemPrice.text{
            newItem.itemPrice = (price as NSString).doubleValue
        }
        if let description = itemDescription.text{
            newItem.itemDescription = description
        }
        
        newItem.toImage = picture
        
        //We are trying to select the currently picked store from the UIPickerView
        //We are passing the inComponent parameter as 0 because we just have one column in the UIPickerView
        newItem.toStore = storesArray[storePickerView.selectedRow(inComponent: 0)]
        
        //Similarly trying to select the currently picked ItemType from the UIPickerView for the Type
        //Passing inComponent parameter as 0 because we just have one column here as well
        newItem.toItemType = itemTypesArray[typePickerView.selectedRow(inComponent: 0)]
        
        //persisting the Itemt Entity
        appDelegate.saveContext()
        
        navigationController?.popViewController(animated: true)
    }
    
    //First method for updating the Data
    func loadItemData(){
        if let item = itemToEdit{
            //Setting the basic properties of an Item while loading
            itemTitleLabel.text = item.itemName
            itemPrice.text = "\(item.itemPrice)"
            itemDescription.text = item.itemDescription
            
            //Loading the Image from database while loading the Item
            thumbImage.image = item.toImage?.image as? UIImage
            
            //But we also need to set the UIPickerView with correct Store info and this is tricky
            //Because all we are getting when we are clicking on an Item is a String but the PickerView needs
            //an array
            //So what we can do is we can loop through the array while checking for the matching String and
            //assign the current selection of the PickerView with the same element from the array.
            //We also need to check if the Item has a Store
            if let store = item.toStore{
                var index = 0
                repeat{
                    if store.storeName == storesArray[index].storeName{
                        storePickerView.selectRow(index, inComponent: 0, animated: false)
                    }
                    index += 1
                    
                }while(index < storesArray.count)
            }
            
            //Doing the same for the ItemType as well
            if let type = item.toItemType{
                var typeIndex = 0
                repeat{
                    print("Type Index: \(typeIndex)")
                    if type.itemType == itemTypesArray[typeIndex].itemType{
                        typePickerView.selectRow(typeIndex, inComponent: 0, animated: false)
                    }
                    typeIndex += 1
                    
                }while(typeIndex < itemTypesArray.count)
            }
        }
    }
    
    //Adding functionality for deleting an element
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        //We want to delete only an existing Item. So we need to make the ItemCheck
        if itemToEdit != nil{
            context.delete(itemToEdit!)
            appDelegate.saveContext()
        }
        navigationController?.popViewController(animated: true)
    }
    
    //Implementation for adding an Image
    @IBAction func addImage(_ sender: UIButton) {
        //Now that we have defined the following method we can present the ViewController
        present(itemImagePicker, animated: true, completion: nil)
    }
    
    //This function needs to be implemented for picking any media from the device
    //This function however, returns a Dictionary of String and Any object instead of an Image
    //So we need to handle that accordingly
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            thumbImage.image = image
        }
        itemImagePicker.dismiss(animated: true, completion: nil)
    }
}
