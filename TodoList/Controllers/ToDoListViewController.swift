//
//  ViewController.swift
//  TodoList
//
//  Created by xdMM20181201 on 30/07/19.
//  Copyright © 2019 xdMM20181201. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var cellArray = [Item]()
    var defaults = UserDefaults.standard
    
    var dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
            print("defaults user is empty")
            let item1 = Item()
            item1.done = true
            item1.title = "single"
            cellArray.append(item1)
            let item2 = Item()
            item2.title = "double"
            cellArray.append(item2)
            loadItems()
            
        
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
    }

    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        print("in addbutton pressed")
        var textField  = UITextField()
        let alertController = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "create new item", style: UIAlertAction.Style.default) { (action) in
            let item = Item()
            item.title = textField.text!
            self.cellArray.append(item)
//            self.defaults.setValue(self.cellArray, forKeyPath: "cellArray")
            self.saveItems()
            
        }
        
        alertController.addTextField { (UITextField) in
            UITextField.placeholder = "New item here"
            textField = UITextField
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        do{
            let data  = try encoder.encode(self.cellArray)
            try data.write(to: self.dataFilePath!)
        }
        catch{
            
        }
        self.tableView.reloadData()
    }
    
    func loadItems(){
        do{
            let data = try Data(contentsOf: self.dataFilePath!)
            let decoder = PropertyListDecoder()
            cellArray = try decoder.decode([Item].self, from: data)
            
        }
        catch{
            
        }
        
    }
    
}

