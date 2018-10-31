//
//  ViewController.swift
//  Todoey
//
//  Created by Andy on 28.10.18.
//  Copyright © 2018 Andy Schoenemann. All rights reserved.
//

import RealmSwift
import UIKit

class TodoListViewController: UITableViewController {
  var items: Results<Item>?
  let realm = try! Realm()

  var selectedCategory: Category? {
    didSet {
      loadItems()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  // MARK: - Tableview Datasource Methods

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
    if let item = items?[indexPath.row] {
      cell.textLabel?.text = item.title
      cell.accessoryType = item.done ? .checkmark : .none
    } else {
      cell.textLabel?.text = "No items Added"
    }
    return cell
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items?.count ?? 1
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let item = items?[indexPath.row] {
      do {
        try realm.write {
          item.done = !item.done
        }
      } catch {
        print("Error saving done status \(error)")
      }
    }
    tableView.reloadData()
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
          if let currentCategory = self.selectedCategory {
            do {
              try self.realm.write {
                let newItem = Item()
                newItem.title = text
                newItem.dateCreated = Date()
                currentCategory.items.append(newItem)
              }
            } catch {
              print("Error saving new items, \(error)")
            }
          }
        }
      }
      self.tableView.reloadData()
    }

    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }

  // function with a default value
  func loadItems() {
    items = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
    tableView.reloadData()
  }
}

// MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    items = items?.filter("title CONTAINS[cd]  %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
    tableView.reloadData()
  }

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchBar.text?.count == 0 {
      loadItems()
      DispatchQueue.main.async {
        searchBar.resignFirstResponder()
      }
    } else {
      // instant search
      searchBarSearchButtonClicked(searchBar)
    }
  }
}
