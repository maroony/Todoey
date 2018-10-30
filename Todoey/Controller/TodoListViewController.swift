//
//  ViewController.swift
//  Todoey
//
//  Created by Andy on 28.10.18.
//  Copyright © 2018 Andy Schoenemann. All rights reserved.
//

import CoreData
import UIKit

class TodoListViewController: UITableViewController {
  var itemArray = [Item]()
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  var selectedCategory: Category? {
    didSet{
      loadItems()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Here are the files of my program
//    print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
  }

  // MARK: - Tableview Datasource Methods

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)

    let item = itemArray[indexPath.row]
    cell.textLabel?.text = item.title

    cell.accessoryType = item.done ? .checkmark : .none
    return cell
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemArray.count
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    saveItems()
    tableView.deselectRow(at: indexPath, animated: true)
  }

  // Mark: - Add new item

  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
    var textField = UITextField()

    alert.addTextField { alertTextField in
      alertTextField.placeholder = "Create new item"
      textField = alertTextField
    }

    let action = UIAlertAction(title: "Add Item", style: .default) { _ in
      if let text = textField.text {
        if text.trimmingCharacters(in: [" "]) != "" {
          let newItem = Item(context: self.context)
          newItem.title = text
          newItem.done = false
          newItem.parentCategory = self.selectedCategory
          self.itemArray.append(newItem)
          self.saveItems()
        }
      }
    }

    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }

  func saveItems() {
    do {
      try context.save()
    } catch {
      print("Error saving context \(error)")
    }
    tableView.reloadData()
  }

  // function with a default value
  func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
    let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
  
    if let optionalPredicate = predicate {
      request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, optionalPredicate])
    } else {
      request.predicate = categoryPredicate
      
    }
    
    do {
      itemArray = try context.fetch(request)
    } catch {
      print("Error fetching data from context \(error)")
    }
    tableView.reloadData()
  }
}

// MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    let request: NSFetchRequest<Item> = Item.fetchRequest()

    let predicate = NSPredicate(format: "title CONTAINS[cd]  %@", searchBar.text!)
    request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

    loadItems(with: request, predicate: predicate)
  }

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchBar.text?.count == 0 {
      loadItems()
      DispatchQueue.main.async {
        searchBar.resignFirstResponder()
      }
    }
    // instant search
//    else {
//      searchBarSearchButtonClicked(searchBar)
//    }
  }
}
