//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Andy on 30.10.18.
//  Copyright © 2018 Andy Schoenemann. All rights reserved.
//

import CoreData
import UIKit

class CategoryViewController: UITableViewController {
  var categoryArray = [Category]()
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadCategories()
  }
  
  // MARK: - TableView Datasource Methods
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
    cell.textLabel?.text = categoryArray[indexPath.row].name
    return cell
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categoryArray.count
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
          let newCategory = Category(context: self.context)
          newCategory.name = text
          self.categoryArray.append(newCategory)
          self.saveCategories()
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
      destinationVC.selectedCategory = categoryArray[indexPath.row]
    }
    
  }
  
  // MARK: - Data Manipulation Methods
  
  func saveCategories() {
    do {
      try context.save()
    } catch {
      print("Error saving context \(error)")
    }
    tableView.reloadData()
  }
  
  // function with a default value
  func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
    do {
      categoryArray = try context.fetch(request)
    } catch {
      print("Error fetching data from context \(error)")
    }
    tableView.reloadData()
  }
}
