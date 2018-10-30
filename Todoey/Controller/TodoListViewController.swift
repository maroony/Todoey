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

  override func viewDidLoad() {
    super.viewDidLoad()
    // Here are the files of my program
    print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    loadItems()
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

  func loadItems() {
    let request: NSFetchRequest<Item> = Item.fetchRequest()
    do {
      itemArray = try context.fetch(request)
    } catch {
      print("Error fetching data from context \(error)")
    }
  }
}
