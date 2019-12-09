//
//  ClassesViewController.swift
//  TrainerBase
//
//  Created by Daniel Yang on 12/8/19.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit

class ClassesViewController: UIViewController {
    @IBOutlet weak var classesTableView: UITableView!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    var classesArray = [ClassInfo]()
    var classInfo = ClassInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        classesTableView.delegate = self
        classesTableView.dataSource = self
        
        loadFromUserDefaults()
    }
    
    @IBAction func unwindFromClassDetailViewController(segue: UIStoryboardSegue) {
        let source = segue.source as! ClassDetailViewController
        classInfo = source.classInfo
        if let selectedIndexPath = classesTableView.indexPathForSelectedRow {
            classesArray[selectedIndexPath.row] = classInfo
            classesTableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            classesTableView.deselectRow(at: selectedIndexPath, animated: true)
        } else {
            let newIndexPath = IndexPath(row: classesArray.count, section: 0)
            classesArray.append(classInfo)
            classesTableView.insertRows(at: [newIndexPath], with: .bottom)
            classesTableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        }
        let homeTab = tabBarController?.viewControllers![0].children[0] as! HomeViewController
        homeTab.classesArray = classesArray
        homeTab.reloadInputViews()
        saveToUserDefaults()
    }
    
    @IBAction func editBarButtonPressed(_ sender: UIBarButtonItem) {
        if classesTableView.isEditing {
            classesTableView.setEditing(false, animated: true)
            editBarButton.title = "Edit"
            addBarButton.isEnabled = true
        } else {
            classesTableView.setEditing(true, animated: true)
            editBarButton.title = "Done"
            addBarButton.isEnabled = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ShowClass":
            let destination = segue.destination as! ClassDetailViewController
            let selectedIndex = classesTableView.indexPathForSelectedRow!
            destination.classInfo = classesArray[selectedIndex.row]
        default:
            if let selectedPath = classesTableView.indexPathForSelectedRow {
                classesTableView.deselectRow(at: selectedPath, animated: true)
            }
        }
    }
    
    func saveToUserDefaults() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(classesArray) {
            UserDefaults.standard.set(encoded, forKey: "classesArray")
        } else {
            print("ERROR: Saving encoded didn't work")
        }
    }
    
    func loadFromUserDefaults() {
        guard let arrayEncoded = UserDefaults.standard.value(forKey: "classesArray") as? Data else {
            return
        }
        let decoder = JSONDecoder()
        if let classesArray = try? decoder.decode(Array.self, from: arrayEncoded) as [ClassInfo] {
            self.classesArray = classesArray
        } else {
            print("ERROR: Couldn't decode data read in from UserDefaults")
        }
    }
}

extension ClassesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = classesTableView.dequeueReusableCell(withIdentifier: "ClassCell", for: indexPath)
        cell.textLabel?.text = classesArray[indexPath.row].name
        if classesArray[indexPath.row].type != "" {
            cell.detailTextLabel?.text = classesArray[indexPath.row].type
        } else {
            cell.detailTextLabel?.text = ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            classesArray.remove(at: indexPath.row)
            classesTableView.deleteRows(at: [indexPath], with: .fade)
        }
        let homeTab = tabBarController?.viewControllers![0].children[0] as! HomeViewController
        homeTab.classesArray = classesArray
        homeTab.reloadInputViews()
        saveToUserDefaults()
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = classesArray[sourceIndexPath.row]
        classesArray.remove(at: sourceIndexPath.row)
        classesArray.insert(itemToMove, at: destinationIndexPath.row)
        let homeTab = tabBarController?.viewControllers![0].children[0] as! HomeViewController
        homeTab.classesArray = classesArray
        homeTab.reloadInputViews()
        saveToUserDefaults()
    }
}
