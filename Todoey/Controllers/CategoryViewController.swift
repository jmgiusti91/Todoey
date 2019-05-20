//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Juan Martin Giusti on 5/14/19.
//  Copyright © 2019 Juan Martin Giusti. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
//import CoreData

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        tableView.rowHeight = super.rowHeight
        
        tableView.separatorStyle = .none
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added yet"
        if let category = categories?[indexPath.row] {
            
            guard let categoryColor = UIColor(hexString: category.color ?? "1D9B6F") else {
                fatalError()
            }
            
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
        return cell
    }
    
    
    //MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            let toDoListVC = segue.destination as! TodoListViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                toDoListVC.selectedCategory = categories?[indexPath.row]
            }
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    /*func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }*/
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category: \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        self.tableView.reloadData()
    }
    
    //MARK: - Delete Data fromn Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        do {
            if let category = self.categories?[indexPath.row] {
                try self.realm.write {
                    self.realm.delete(category)
                }
            }
        } catch {
            print("Error deleting category: \(error)")
        }
    }
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            //let category = Category(context: self.context)
            
            let category = Category()
            
            category.name = textField.text!
            
            category.color = UIColor.randomFlat.hexValue()
            
            self.save(category: category)
            
            //self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add New Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
}
