//
import RealmSwift
//  CategoryViewController.swift
//  Todoey
//
//  Created by Andy on 30.10.18.
//  Copyright © 2018 Andy Schoenemann. All rights reserved.
//
import UIKit

class CategoryViewController: UITableViewController {
  let realm = try! Realm()
  var categories: Results<Category>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadCategories()
  }
  
  // MARK: - TableView Datasource Methods
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
    cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added yet"
    return cell
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categories?.count ?? 1
  }
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
    var textField = UITextField()
    
    alert.addTextField { alertTextField in
      alertTextField.placeholder = "Create new category"
      textField = alertTextField
    }
    
    let action = UIAlertAction(title: "Add Category", style: .default) { _ in
      if let text = textField.text {
        if text.trimmingCharacters(in: [" "]) != "" {
          let newCategory = Category()
          newCategory.name = text
          self.save(category: newCategory)
        }
      }
    }
    
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
  // MARK: - TableView Delegate Methods
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "goToItems", sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destinationVC = segue.destination as! TodoListViewController
    if let indexPath = tableView.indexPathForSelectedRow {
      destinationVC.selectedCategory = categories?[indexPath.row]
    }
  }
  
  // MARK: - Data Manipulation Methods
  
  func save(category: Category) {
    do {
      try realm.write {
        realm.add(category)
      }
    } catch {
      print("Error saving context \(error)")
    }
    tableView.reloadData()
  }
  
  // function with a default value
  func loadCategories() {
    categories = realm.objects(Category.self)
    tableView.reloadData()
  }
}
