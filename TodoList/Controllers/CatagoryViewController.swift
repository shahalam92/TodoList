//
//  TableViewController.swift
//  TodoList
//
//  Created by xdMM20181201 on 03/08/19.
//  Copyright © 2019 xdMM20181201. All rights reserved.
//

import UIKit
import RealmSwift

class CatagoryViewController: UITableViewController {
 
    let realm = try! Realm()
    var category:Results<Category>?
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
        
         }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let categoryCell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
        categoryCell.textLabel?.text = category?[indexPath.row].name ?? "no category added yet"
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
    
}
