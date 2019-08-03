//
//  ViewController.swift
//  TodoList
//
//  Created by xdMM20181201 on 30/07/19.
//  Copyright © 2019 xdMM20181201. All rights reserved.
//

import UIKit
import CoreData


class ToDoListViewController: UITableViewController {

    var cellArray = [Item]()
    ///================   for userdefaults=============//////////
        var defaults = UserDefaults.standard
    
    ///================   for codable=============//////////
         var dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    //=====coredata=======//
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedCategory:Category?{
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        ///================   for userdefaults=============//////////
        // Do any additional setup after loading the view.
//        if let item = defaults.array(forKey: "cellArray") as? [Item]{
//            cellArray = item
//            print("defaults user")
//        }
//        else{
//            print("defaults user is empty")
//            let item1 = Item()
//            item1.done = true
//            item1.title = "single"
//            cellArray.append(item1)
//            let item2 = Item()
//            item2.title = "double"
//            cellArray.append(item2)
////
//
//        }
        ///===========end userdefaults=======///
        ///================   for codable=============//////////
//            print("defaults user is empty")
//            let item1 = Item()
//            item1.done = true
//            item1.title = "single"
//            cellArray.append(item1)
//            let item2 = Item()
//            item2.title = "double"
//            cellArray.append(item2)
//            loadItems()
        ///===========end codable=======///
        
//        loadItems()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(cellArray.count)
        return cellArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        cell.textLabel?.text = cellArray[indexPath.row].title
        if cellArray[indexPath.row].done == false {
            cell.accessoryType = .none
        }
        else{
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(cellArray[indexPath.row])
        cellArray[indexPath.row].done = !cellArray[indexPath.row].done
        tableView.deselectRow(at: indexPath, animated: true)
        saveItems()
        ////======for codable=====//
         //        saveItems()
        ////======for coredata=====//
         //=====delete data from persistence container in coredata
            //        context.delete(cellArray[indexPath.row])
            //        cellArray.remove(at: indexPath.row)
            //        saveItems()
        
    }

    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        print("in addbutton pressed")
        var textField  = UITextField()
        let alertController = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "create new item", style: UIAlertAction.Style.default) { (action) in
            
            //======core data========
                let item = Item(context: self.context)
                item.title = textField.text!
                item.done = false
                item.parentCategory = self.selectedCategory
                self.cellArray.append(item)
                self.saveItems()
            ///====for userdefaults======//
            //            let item = Item()
            //            item.title = textField.text!
            //            self.cellArray.append(item)
            //            self.defaults.setValue(self.cellArray, forKeyPath: "cellArray")
            
            ////======for codable=====//
                //            let item = Item()
                //            item.title = textField.text!
                //            self.cellArray.append(item)
              //            self.saveItems()
            
        }
        
        alertController.addTextField { (UITextField) in
            UITextField.placeholder = "New item here"
            textField = UITextField
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
        
    }
    //=====for codable===//
//    func saveItems(){
//        let encoder = PropertyListEncoder()
//        do{
//            let data  = try encoder.encode(self.cellArray)
//            try data.write(to: self.dataFilePath!)
//        }
//        catch{
//
//        }
//        self.tableView.reloadData()
//    }
//
//    func loadItems(){
//        do{
//            let data = try Data(contentsOf: self.dataFilePath!)
//            let decoder = PropertyListDecoder()
//            cellArray = try decoder.decode([Item].self, from: data)
//
//        }
//        catch{
//
//        }
//
//    }
    //=====end codable===//
    //=======for core data====//
        func saveItems(){
            do{
                try context.save()
            }
            catch{
                print("error in db storage = \(error)")
            }
            self.tableView.reloadData()
        }
    
//        func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest()){
//            do{
//                try cellArray = context.fetch(request)
//                print("in load items \(cellArray)")
//
//            }
//            catch{
//                print("error from  db load = \(error)")
//            }
//            tableView.reloadData()
//
//        }
    
    func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest(),with predicate:NSPredicate?=nil){
        do{
            let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
            if let itemPredicate = predicate{
                let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,itemPredicate])
                request.predicate = compoundPredicate
            }
            else{
                request.predicate = categoryPredicate
            }
            try cellArray = context.fetch(request)
            print("in load items \(cellArray)")
            
        }
        catch{
            print("error from  db load = \(error)")
        }
        tableView.reloadData()
        
    }
    //=======end core data====//
}

extension ToDoListViewController:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("in searchBarSearchButtonClicked")
        let request:NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with:request,with: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.count==0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}

