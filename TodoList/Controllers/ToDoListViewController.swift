//
//  ViewController.swift
//  TodoList
//
//  Created by xdMM20181201 on 30/07/19.
//  Copyright © 2019 xdMM20181201. All rights reserved.
//

import UIKit
import RealmSwift


class ToDoListViewController: UITableViewController {
    let realm = try! Realm()
    var cellArray:Results<Item>?
    
    var selectedCategory:Category?{
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellArray?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        if let item = cellArray?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else{
            cell.textLabel?.text = "no item added yet"
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("in did select row")
        if let item = cellArray?[indexPath.row]{
            print("in did select row \(item)")
            do{
                try self.realm.write {
                     item.done = !item.done
//                    realm.delete(item)
                }
            }
            catch{
                print("error in updating \(error)")
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }

    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        print("in addbutton pressed")
        var textField  = UITextField()
        let alertController = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "create new item", style: UIAlertAction.Style.default) { (action) in

            
            if let currentCategory = self.selectedCategory {
                do{
                        try self.realm.write {
                            let item = Item()
                            item.title = textField.text!
                            item.dateCreated = Date()
                            currentCategory.items.append(item)
                        }
                      }
                catch{
                    print("error in add item in current category")
                }
                self.tableView.reloadData()
            }

        }

        alertController.addTextField { (UITextField) in
            UITextField.placeholder = "New item here"
            textField = UITextField
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)

    }
   
    
    func loadItems(){
        cellArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()

    }
    
}

extension ToDoListViewController:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("in searchBarSearchButtonClicked")
        cellArray = cellArray?.filter("title CONTAINS[cd] %@",searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
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

