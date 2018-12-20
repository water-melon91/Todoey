 //
//  CategoryViewController.swift
//  Todoey
//
//  Created by water-melon on 12/17/18.
//  Copyright © 2018 water-melon. All rights reserved.
//

import UIKit
import CoreData
class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }

   
   
    func loadItems(with request : NSFetchRequest<Category> = Category.fetchRequest()){
        
        do{
            categoryArray = try context.fetch(request)
            print(categoryArray,"categoryArray")
        }catch{
            print("fetchrequest error\(error)")
        }
        tableView.reloadData()
        
    }
    
    //MARK: - Table View Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "ToDoCategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name;
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    //MARK: - Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathsForSelectedRows?.first {
            destinationVC.selectCategory = categoryArray[indexPath.row]
        }
    }
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController.init(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction.init(title: "Add", style: .default) { (action) in
            
            if textField.text != "" {
                let newCategory =  Category(context: self.context)
                newCategory.name = textField.text!
                self.categoryArray.append(newCategory)
                self.save()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true , completion: nil)
        
    }
    
    //MARK: - Data Manipulation
    func save(){
        do {
            try context.save()
        }catch{
            print("error in array\(error)")
        }
        self.tableView.reloadData()
    }
    
}
