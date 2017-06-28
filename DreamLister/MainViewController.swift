//
//  MainViewController.swift
//  DreamLister
//
//  Created by Chandan Sarkar on 25.06.17.
//  Copyright © 2017 Chandan. All rights reserved.
//

import UIKit
import CoreData

class MainViewController:UIViewController
,UITableViewDataSource
,UITableViewDelegate
,NSFetchedResultsControllerDelegate{
    
    @IBOutlet weak var mainSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var mainTableView: UITableView!
    
    //Declaring NSFetchedController varaible.
    var fetchedResultController: NSFetchedResultsController<Item>!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        //Generating some test items
        //generateTestItems()
        //Here inside viewDidLoad, we are calling the attempFetch() method and it will basically
        //initialise our NSFetchedResultController
        attemptFetch()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //As we have studied that the UIViews like UITableView or UICollectionView 
        //expect the CoreData to return the data as collection of sections made of rows
        if let sections = fetchedResultController.sections{
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0 //otherwise
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //Similar to above here we are returning the no of sections returned from CoreData.
        if let sections = fetchedResultController.sections{
            return sections.count
        }
        return 0 //otherwise
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = mainTableView.dequeueReusableCell(withIdentifier: "dreamItemCell") as? DreamItemCellTableViewCell{
            //Calling configureCell() method to update the cell
            configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            return cell
        }else{
            return DreamItemCellTableViewCell()
        }
    }
    
    //This is our secondary configureCell() method that will call the primary configureCell()
    //method of the custom class DreamItemCellTableViewCell
    func configureCell(cell: DreamItemCellTableViewCell,indexPath: NSIndexPath){
        let dreamItem = fetchedResultController.object(at: indexPath as IndexPath)
        cell.configureCell(dreamItem: dreamItem)
    }
    
    //This function will make sure that rows will always be of a predefined height at runtime.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(140)
    }
    
    /**
     Declaring function that will try to fetch the result.
     First method in which we start the persistence related stuff
     */
    func attemptFetch(){
        //Creating actual FetchRequest
        //We tell that what will be fetching to the NSFetchRequest type variable and
        //finally we initialise the same with fetchRequest() method on the Item.
        //This is just one of the parameters that we will pass to the NSFethcResultController method eventually.
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        //NSFetchedResultController method needs to know what fetch needs to be performed and also how to sort the data
        //that needs to be fetched.
        //We are going to create a SortDescriptor to say that how we are going to sort the result while displaying
        //Key for sorting is the attribute itemCreated of the Entity Item because we want to sort accoridng to the
        //create time of the item is descending order. That means most recently created item should appear first.
        let dateSort = NSSortDescriptor(key: "itemCreated", ascending: false)
        
        /**
         Here we are going to focus on our different sorting criterias and how to handle them.
         We have to create two new  NSSortDescriptors.
        */
        
        let priceSort = NSSortDescriptor(key: "itemPrice", ascending: true)
        let titleSort = NSSortDescriptor(key: "itemName", ascending: true)
        let typeSort = NSSortDescriptor(key: "toItemType.itemType", ascending: true)
        
        //Now we are going yo see which segmented control is now selected
        if mainSegmentedControl.selectedSegmentIndex == 0{
            //So we are including the SortDescriptor for our FetchResult. We need an array here because it expects an
            //array. We might have more than one SortDescriptor
            fetchRequest.sortDescriptors = [dateSort]
        }else if mainSegmentedControl.selectedSegmentIndex == 1{
            fetchRequest.sortDescriptors = [priceSort]
        }else if mainSegmentedControl.selectedSegmentIndex == 2{
            fetchRequest.sortDescriptors = [titleSort]
        }else if mainSegmentedControl.selectedSegmentIndex == 3{
            fetchRequest.sortDescriptors = [typeSort]
        }
        
        //We now instantiate the the NSFetchedResultController with the following parameter.
        //We have already created a shortcut for accessing the NSManagedObjectContext in the AppDelegate.swift so
        //we can pass the context reference here.
        //We pass sectionNameKeyPath as nil because we want to return all of the results
        //We don't need the cacheName at this point so we just pass nil for now.
        self.fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        //This enables the controllerWill/DidChnageContent() methods to listen for the changes.
        fetchedResultController.delegate = self
        
        //Now we are ready to make an actual fetch request.
        //And since the fetch request may fail or take arbitrary time, we make this inside a do and catch block
        do{
            try self.fetchedResultController.performFetch()
        }catch{
            let error = error as NSError
            print("\(error)")
        }
    }
    
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        attemptFetch()
        mainTableView.reloadData()
    }
    
    //Second method where we continue the persistence related stuff
    //Whenever the TableView is about to update this method will start listening for the changes and handle
    //that accordingly
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //We call this method usually when we need to make subsequent updates to the dataset.
        mainTableView.beginUpdates()
    }
    
    //Third method where we continue the persistence related stuff
    //When the content of the UIView has been changed the statements of this method will be executed
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //Conclude the series of the updates on the dataset
        mainTableView.endUpdates()
    }
    
    
    //Fourth method where we continue the persistence related stuff
    //This method sniffs for changes whether it is insertion deletion or modification and help the UIView
    //to change the display accordingly
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            //Handles the insertion of a new data
        case.insert:
            //newIndexPath is the new sequence no for the newly inserted data
            if let indexPath = newIndexPath{
                //inserting an object to display at the  appropriate index path in our TableView 
                //with the fade type animation
                mainTableView.insertRows(at: [indexPath], with: .fade)
            }
        case.update:
            //Now we want to click on an exisitng Item and we want to update the same
            //We will grab the object at an existing index path and not a new one
            //
            if let indexPath = indexPath{
                if let cell = mainTableView.cellForRow(at: indexPath) as? DreamItemCellTableViewCell{
                    //Now that we have defined our secondary configureCell() method inside ViewController,
                    //we can actually call that method to update our Cell
                    configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
                }
            }
            break
        case.move:
            if let indexPath = indexPath{
                mainTableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath{
                mainTableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.delete:
            //This time we are deleting an object from display from an index position in our TableView
            //with the fade type animation.
            //This time we will grab an existing index path and not a new one
            if let indexPath = indexPath{
                mainTableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        }
    }
    
    //generate some test items
//    func generateTestItems(){
//        //Instantiating the the Item with reference of the NSManagedObjectContext
//        let dreamItem1 = Item(context: context)
//        dreamItem1.itemName = "PlayStation 5"
//        dreamItem1.itemDescription = "Will be waiting for the release next year. Will be a royal comeback. I will won all the games that is availeb in the PSN and I will go crazy."
//        dreamItem1.itemPrice = 568
//        
//        let dreamItem2 = Item(context: context)
//        dreamItem2.itemName = "Yeti"
//        dreamItem2.itemDescription = "Costly for now. Will not be costly forever."
//        dreamItem2.itemPrice = 1200
//        
//        let dreamItem3 = Item(context: context)
//        dreamItem3.itemName = "iPad Pro 12"
//        dreamItem3.itemDescription = "This I am going to own before I die."
//        dreamItem3.itemPrice = 999
//        
//        let dreamItem4 = Item(context: context)
//        dreamItem4.itemName = "Geeforce Titan X"
//        dreamItem4.itemDescription = "This is a beast among the GPUs"
//        dreamItem4.itemPrice = 1244
//        
//        appDelegate.saveContext()
//    }
    
    //Here we are going to ptovide the implementation for the behavior when we select an Item
    //in the MainViewController
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRow Function called")
        if let objs = fetchedResultController.fetchedObjects , objs.count > 0 {
            
            let item = objs[indexPath.row]
            performSegue(withIdentifier: "showItemDetail", sender: item)
        }
    }
    
    //Prepare for the Item Selection behavior
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showItemDetail" {
            if let destination = segue.destination as? ItemAddViewController {
                if let item = sender as? Item {
                    destination.itemToEdit = item
                }
            }
        }
        
    }
    
    
    
    

}
