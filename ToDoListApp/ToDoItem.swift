//
//  ToDoItem.swift
//  ToDoListApp
//
//  Created by Darya Kuliashova on 8/26/19.
//  Copyright © 2019 Darya Kuliashova. All rights reserved.
//

import Foundation

class ToDoItem {
    var title: String
    var isCompleted: Bool
    
    init(title: String) {
        self.title = title
        self.isCompleted = false
    }
    
    public class func getDefaultData() -> [ToDoItem] {
        return [
                ToDoItem(title: "Buy milk"),
                ToDoItem(title: "Clean up the flat"),
                ToDoItem(title: "Call a mum"),
                ToDoItem(title: "Create a todo list app")
        ]
    }
}
