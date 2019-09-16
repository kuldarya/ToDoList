//
//  ViewController.swift
//  ToDoListApp
//
//  Created by Darya Kuliashova on 8/26/19.
//  Copyright © 2019 Darya Kuliashova. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var items = ToDoItem.getDefaultData()
    var selectedRowForEditing: IndexPath?
    var selectedRowEditingSuccess: ((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        self.title = "To Do List"
        createAddButton()
    }
    
    private func createAddButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapOnAddButton))
    }
    
    @objc func didTapOnAddButton() {
        showAddNewItemAlert(title: "Add a new todo item", message: "Enter new todo")
    }
    
    private func showAddNewItemAlert(title: String, message: String) {
        let addDialog = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        addDialog.addTextField(configurationHandler: nil)
        addDialog.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        addDialog.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
            let title = addDialog.textFields?[0].text?.capitalized
            if let title = title {
                let newItem = ToDoItem(title: title)
                self.items.append(newItem)
                
                let path = IndexPath(row: self.items.count - 1, section: 0)
                self.tableView.insertRows(at: [path], with: .fade)
            }
        }))
        self.present(addDialog, animated: true)
    }
    
    private func showEditItemAlert(indexPath: IndexPath) {
        let editDialog = UIAlertController(title: "Edit", message: "Edit your todo", preferredStyle: .alert)
        editDialog.addTextField { _ in
            editDialog.textFields?[0].text = self.items[indexPath.row].title
        }
        editDialog.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        editDialog.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
            let title = editDialog.textFields?[0].text
            if let title = title,
                let row = self.selectedRowForEditing?.row,
                let indexPath = self.selectedRowForEditing {
                self.items[row].title = title
                self.selectedRowEditingSuccess?(true)
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }
        }))
        self.present(editDialog, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todo_cell", for: indexPath)
        
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        
        let accessoryType: UITableViewCell.AccessoryType = item.isCompleted ? .checkmark : .none
        cell.accessoryType = accessoryType
        
        return cell
    }
    
    //MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        item.isCompleted = !item.isCompleted
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Edit") { (action, view, success: @escaping (Bool) -> Void) in
            self.selectedRowForEditing = indexPath
            self.selectedRowEditingSuccess = success
            
            self.showEditItemAlert(indexPath: indexPath)
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
}

