//
//  ViewController.swift
//  Todoey
//
//  Created by Andy on 28.10.18.
//  Copyright © 2018 Andy Schoenemann. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
  var itemArray = [Item]()
  let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

  override func viewDidLoad() {
    super.viewDidLoad()
    loadItems()
    // Do any additional setup after loading the view, typically from a nib.
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
    print(indexPath.row)

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
          let newItem = Item()
          newItem.title = text
          self.itemArray.append(newItem)
          self.saveItems()
        }
      }
    }

    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }

  func saveItems() {
    let encoder = PropertyListEncoder()
    do {
      let data = try encoder.encode(itemArray)
      try data.write(to: dataFilePath!)
    } catch {
      print("Error encoding item array, \(error)")
    }
    tableView.reloadData()
  }
  
  func loadItems() {
    if let data = try? Data(contentsOf: dataFilePath!){
      let decoder = PropertyListDecoder()
      do {
      itemArray = try decoder.decode([Item].self, from: data)
      } catch {
        print("Error decoding item array, \(error)")
      }
    }
  }
}
