//
//  TableViewController.swift
//  CoreDataMealTime
//
//  Created by Admin on 11.12.2019.
//  Copyright © 2019 sergei. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {

    var context: NSManagedObjectContext?
    var person: Person?
    
    lazy var dateFormatter: DateFormatter = {
        var df = DateFormatter()
        df.timeStyle = .short
        df.dateStyle = .short
        return df
    }()
    
    @IBAction func addTimeAction(_ sender: UIBarButtonItem) {
        
        guard let context = context, let person = person else { return }
        
        let meal = Meal(context: context)
        meal.date = Date()
        
        let meals = person.meals?.mutableCopy() as! NSMutableOrderedSet
        meals.add(meal)
        
        person.meals = meals
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error), userInfo: \(error.userInfo)")
        }
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            context = delegate.coreDataStack.persistentContainer.viewContext
        }
        
        if let context = context {
            let personName = "Sergei"
            let request: NSFetchRequest<Person> = Person.fetchRequest()
            request.predicate = NSPredicate(format: "name = %@", personName)
            
            do {
                let results = try context.fetch(request)
                if !results.isEmpty {
                    person = results.first
                } else {
                    person = Person(context: context)
                    person?.name = personName
                    try context.save()
                }
            } catch let error as NSError {
                print("Error: \(error), userInfo: \(error.userInfo)")
            }
        }
    }
}

// MARK: - Table view data source
extension TableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let meals = person?.meals else { return 1}
        return meals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        guard let meal = person?.meals?[indexPath.row] as? Meal, let mealDate = meal.date else {
            return cell
        }
        
        cell.textLabel?.text = dateFormatter.string(from: mealDate)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "My happy meal time"
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let context = context, let person = person, editingStyle == .delete else { return }
        guard let meal = person.meals?[indexPath.row] as? NSManagedObject else { return }
        
        context.delete(meal)
        
        do {
            try context.save()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } catch let error as NSError {
            print("Error: \(error), userInfo: \(error.userInfo)")
        }
    }
}
