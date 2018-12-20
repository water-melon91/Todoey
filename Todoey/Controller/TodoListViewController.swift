//
//  ViewController.swift
//  Todoey
//
//  Created by water-melon on 12/11/18.
//  Copyright © 2018 water-melon. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    var selectCategory: Category? {
        didSet{
            loadItems()
        }
    }
    //    let defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory , in: .userDomainMask).first?.appendingPathComponent("Items")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //        let newItem = Item()
        //        newItem.title = "Apple"
        //        itemArray.append(newItem)
        //
        //        let newItem2 = Item()
        //        newItem2.title = "Ball"
        //        itemArray.append(newItem2)
        //
        //        let newItem3 = Item()
        //        newItem3.title = "Cat"
        //        itemArray.append(newItem3 )
        //
        
        //        if let items = (defaults.array(forKey: "ToDoListArray") as? [Item]){
        //            itemArray = items
        //        }
    }
    
    // MARK:  - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row];
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        //        if itemArray[indexPath.row].done  == true{
        //            cell.accessoryType = .checkmark
        //        }else{
        //            cell.accessoryType = .none
        //        }
        return cell
    }
    
    
    // MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //
        //        context.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        //        if itemArray[indexPath.row].done == false{
        //           itemArray[indexPath.row].done = true
        //        }else{
        //            itemArray[indexPath.row].done = false
        //        }
        
        //        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        //        }else{
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //        }
        save()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController.init(title: "Add New Todey Items", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction.init(title: "Add Items", style: .default) { (action) in
            
            if textField.text != "" {
                
                let newItem =  Item(context: self.context)
                newItem.title = textField.text!
                newItem.done = false
                newItem.parentCategory = self.selectCategory
                self.itemArray.append(newItem)
//                0x848f3144c4309bb3
                //self.defaults.setValue(self.itemArray, forKey: "ToDoListArray")
                
                self.save()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true , completion: nil)
    }
    
    func save(){
        //        let encoder = PropertyListEncoder()
        
        do {
            try context.save()
            //            let data = try encoder.encode(itemArray)
            //            try data.write(to: dataFilePath!)
            
        }catch{
            print("error in array\(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(),predicate: NSPredicate? = nil ){
        
        //            if let data = try? Data(contentsOf: dataFilePath!){
        //                let decoder = PropertyListDecoder()
        //                do{
        //                    itemArray = try decoder.decode([Item].self, from: data)
        //
        //                }catch{
        //                    print("encoding item array,\(error)")
        //                }
        //            }
        //            let request: NSFetchRequest<Item> = Item.fetchRequest()
        

        itemArray = [Item]()
        
        print(selectCategory?.name,"name") 
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectCategory!.name!)
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,predicate])
//                 request.predicate = compoundPredicate
        
        if  let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,addtionalPredicate])
        }else{
                request.predicate = categoryPredicate
        }
        do{
            itemArray = try context.fetch(request)
            print(itemArray,"itemArray")
        }catch{
            print("fetchrequest error\(error)")
        }
        tableView.reloadData()
        
    }
}

extension TodoListViewController:UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request,predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
            searchBar.resignFirstResponder()
            }
            
        }
    }
    
}
