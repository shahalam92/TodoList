//
//  TableViewController.swift
//  TodoList
//
//  Created by xdMM20181201 on 03/08/19.
//  Copyright © 2019 xdMM20181201. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CatagoryViewController: SwipeTableViewController {
 
    let realm = try! Realm()
    var category:Results<Category>?
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
            super.viewDidLoad()
            tableView.separatorStyle = .none
            guard let navBar = navigationController?.navigationBar else {
                fatalError()
            }
        
            if let titleColor = UIColor(hexString: "#d07AFF"){
                navBar.barTintColor = titleColor
                navBar.tintColor = ContrastColorOf(titleColor, returnFlat: true)
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(titleColor, returnFlat: true)]
            }
            loadCategory()
        
         }
//    override func viewWillAppear(_ animated: Bool) {
//        guard let navBar = navigationController?.navigationBar else {
//            fatalError()
//        }
//
////        if let titleColor = UIColor(hexString: "#d07AFF"){
////            navBar.barTintColor = titleColor
////            navBar.tintColor = ContrastColorOf(titleColor, returnFlat: true)
////            navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(titleColor, returnFlat: true)]
////        }
//
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let categoryCell = super.tableView(tableView, cellForRowAt: indexPath)
        categoryCell.textLabel?.text = category?[indexPath.row].name ?? "no category added yet"
        categoryCell.backgroundColor = category?[indexPath.row].color == "" ? UIColor.randomFlat : UIColor(hexString: (category?[indexPath.row].color)!)
        guard  let categoryColor = UIColor(hexString: ((category?[indexPath.row].color)!)) else {
            fatalError()
        }
        
        categoryCell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        
        return categoryCell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            let segueTDL = segue.destination as! ToDoListViewController
            if let selectedCategoryIndex = tableView.indexPathForSelectedRow{
                segueTDL.selectedCategory = category?[selectedCategoryIndex.row]
            }
        }
    }

    @IBAction func addCategoryButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alertController = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        alertController.addTextField { (UITextField) in
            textField = UITextField
            UITextField.placeholder = "enter category"
        }
        let alertAction = UIAlertAction(title: "create category", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat.hexValue()
            self.saveCategory(category:newCategory)
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func saveCategory(category:Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }
        catch{
            print("error in save category \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategory(){
        
        category = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryToBeDeleted = self.category?[indexPath.row]{
                do{
                    try self.realm.write {
                        self.realm.delete(categoryToBeDeleted)
                    }
                }
                catch{
                    print("error in deletion \(error)")
                }
            }
    }
}

//extension CatagoryViewController:SwipeTableViewCellDelegate{
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//        guard orientation == .right else { return nil }
//
//        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
//            if let categoryToBeDeleted = self.category?[indexPath.row]{
//                do{
//                    try self.realm.write {
//                        self.realm.delete(categoryToBeDeleted)
//                    }
//                }
//                catch{
//                    print("error in deletion \(error)")
//                }
////                self.tableView.reloadData()
//            }
//        }
//
//        // customize the action appearance
//        deleteAction.image = UIImage(named: "delete-icon")
//
//        return [deleteAction]
//
//    }
//
//    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
//        var options = SwipeOptions()
//        options.expansionStyle = .destructive
//        return options
//    }
//
//}
