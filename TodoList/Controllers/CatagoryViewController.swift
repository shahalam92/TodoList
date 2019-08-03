//
//  TableViewController.swift
//  TodoList
//
//  Created by xdMM20181201 on 03/08/19.
//  Copyright © 2019 xdMM20181201. All rights reserved.
//

import UIKit
import CoreData

class CatagoryViewController: UITableViewController {

    var itemArray:[Category] = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
        
         }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let categoryCell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
        categoryCell.textLabel?.text = itemArray[indexPath.row].name
        return categoryCell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            var segueTDL = segue.destination as! ToDoListViewController
            if let selectedCategoryIndex = tableView.indexPathForSelectedRow{
                segueTDL.selectedCategory = itemArray[selectedCategoryIndex.row]
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
            let category = Category(context: self.context)
            category.name = textField.text!
            self.itemArray.append(category)
            self.saveCategory()
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func saveCategory(){
        do{
            try context.save()
        }
        catch{
            print("error in save category \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategory(with request:NSFetchRequest<Category>=Category.fetchRequest()){
        do{
            try itemArray = context.fetch(request)
        }
        catch{
            print("error in load category \(error)")
        }
        tableView.reloadData()
    }
    
}
