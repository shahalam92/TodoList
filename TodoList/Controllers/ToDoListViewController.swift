//
//  ViewController.swift
//  TodoList
//
//  Created by xdMM20181201 on 30/07/19.
//  Copyright © 2019 xdMM20181201. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework


class ToDoListViewController: SwipeTableViewController {
    let realm = try! Realm()
    var cellArray:Results<Item>?
    
    var selectedCategory:Category?{
        didSet{
            loadItems()
        }
    }
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name
        guard let selectedCategoryColor = selectedCategory?.color else {
            fatalError()
        }
        updateNavBar(with: selectedCategoryColor)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(with: "#d07AFF")
    }
    
    func updateNavBar(with colorHexCode:String){
        if let selectedCategoryColor = UIColor(hexString: colorHexCode) {
            guard let navBar = navigationController?.navigationBar else{
                fatalError()
            }
            
            navBar.barTintColor = selectedCategoryColor
            navBar.tintColor = ContrastColorOf(selectedCategoryColor, returnFlat: true)
            navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(selectedCategoryColor, returnFlat: true)]
            searchBar.barTintColor = selectedCategoryColor
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellArray?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = cellArray?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            if let color = UIColor(hexString: selectedCategory?.color ?? "#67ff98")?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(cellArray!.count)){
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
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
    
    override func updateModel(at indexPath: IndexPath) {
        if let cellToBeDeleted = cellArray?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(cellToBeDeleted)
                }
            }
            catch{
                print("error in updated model of todolistitem \(error)")
            }
        }
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

