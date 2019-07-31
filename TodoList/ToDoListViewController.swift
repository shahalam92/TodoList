//
//  ViewController.swift
//  TodoList
//
//  Created by xdMM20181201 on 30/07/19.
//  Copyright © 2019 xdMM20181201. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var cellArray = ["abc","def","fjhgkjh"]
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let item = defaults.array(forKey: "cellArray") as? [String]{
            cellArray = item
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        cell.textLabel?.text = cellArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(cellArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        print("in addbutton pressed")
        var textField  = UITextField()
        let alertController = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "create new item", style: UIAlertAction.Style.default) { (action) in
            self.cellArray.append(textField.text!)
            self.defaults.setValue(self.cellArray, forKeyPath: "cellArray")
            self.tableView.reloadData()
        }
        
        alertController.addTextField { (UITextField) in
            UITextField.placeholder = "New item here"
            textField = UITextField
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
}

