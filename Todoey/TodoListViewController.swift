//
//  ViewController.swift
//  Todoey
//
//  Created by Andy on 28.10.18.
//  Copyright © 2018 Andy Schoenemann. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
  var itemArray = ["Find Mike", "Buy Eggs", "Destroy Something"]
  let userDefaults = UserDefaults.standard
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let items = userDefaults.array(forKey: "TodoListArray") as? [String] {
      itemArray = items
    }
    // Do any additional setup after loading the view, typically from a nib.
  }

  // MARK: - Tableview Datasource Methods

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
    cell.textLabel?.text = itemArray[indexPath.row]
    return cell
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemArray.count
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print(indexPath.row)
    tableView.deselectRow(at: indexPath, animated: true)

    if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
      tableView.cellForRow(at: indexPath)?.accessoryType = .none
    } else {
      tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
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
          self.itemArray.append(text)
          self.userDefaults.set(self.itemArray, forKey: "TodoListArray")
          self.tableView.reloadData()
        }
      }
    }

    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
}
