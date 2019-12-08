//
//  ClassDetailViewController.swift
//  TrainerBase
//
//  Created by Daniel Yang on 12/8/19.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit

class ClassDetailViewController: UIViewController {
    @IBOutlet weak var classScheduleTableView: UITableView!
    @IBOutlet weak var classNameTextField: UITextField!
    @IBOutlet weak var classTypeTextField: UITextField!
    @IBOutlet weak var classLevelTextField: UITextField!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    var classInfo = ClassInfo()
    var dayOfWeek = ""
    var timeOfDay = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        classScheduleTableView.delegate = self
        classScheduleTableView.dataSource = self
        
        classNameTextField.text = classInfo.name
        classTypeTextField.text = classInfo.type
        classLevelTextField.text = classInfo.level
        
        if classNameTextField.text == "" {
            saveBarButton.isEnabled = false
        } else {
            saveBarButton.isEnabled = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ShowClassSession":
            let destination = segue.destination as! SessionViewController
            let selectedIndex = classScheduleTableView.indexPathForSelectedRow!
            destination.dayOfWeek = classInfo.sessionsArray[selectedIndex.row].dayOfWeek
            destination.timeOfDay = classInfo.sessionsArray[selectedIndex.row].timeOfDay
        case "UnwindFromClassDetailSave":
            classInfo.name = classNameTextField.text ?? ""
            classInfo.type = classTypeTextField.text ?? ""
            classInfo.level = classLevelTextField.text ?? ""
        default:
            if let selectedPath = classScheduleTableView.indexPathForSelectedRow {
                classScheduleTableView.deselectRow(at: selectedPath, animated: true)
            }
        }
    }
    
    @IBAction func cancelBarButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UITabBarController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController!.popViewController(animated: true)
        }
    }
    
    
    @IBAction func unwindFromClassSessionViewController(segue: UIStoryboardSegue) {
        let source = segue.source as! SessionViewController
        let session = Session()
        session.dayOfWeek = source.dayOfWeek
        session.timeOfDay = source.timeOfDay
        if let selectedIndexPath = classScheduleTableView.indexPathForSelectedRow {
            classInfo.sessionsArray[selectedIndexPath.row] = session
            classScheduleTableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            classScheduleTableView.deselectRow(at: selectedIndexPath, animated: true)
        } else {
            let newIndexPath = IndexPath(row: classInfo.sessionsArray.count, section: 0)
            classInfo.sessionsArray.append(session)
            classScheduleTableView.insertRows(at: [newIndexPath], with: .bottom)
            classScheduleTableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        }
    }
    
    @IBAction func classNameTextFieldChanged(_ sender: UITextField) {
        if classNameTextField.text == "" {
            saveBarButton.isEnabled = false
        } else {
            saveBarButton.isEnabled = true
        }
    }
    
    
    @IBAction func editBarButtonPressed(_ sender: UIBarButtonItem) {
        if classScheduleTableView.isEditing {
            classScheduleTableView.setEditing(false, animated: true)
            editBarButton.title = "Edit"
            addBarButton.isEnabled = true
        } else {
            classScheduleTableView.setEditing(true, animated: true)
            editBarButton.title = "Done"
            addBarButton.isEnabled = false
        }
    }
}

extension ClassDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classInfo.sessionsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = classScheduleTableView.dequeueReusableCell(withIdentifier: "ClassSessionCell", for: indexPath)
        cell.textLabel?.text = "\(classInfo.sessionsArray[indexPath.row].dayOfWeek), \(classInfo.sessionsArray[indexPath.row].timeOfDay)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            classInfo.sessionsArray.remove(at: indexPath.row)
            classScheduleTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = classInfo.sessionsArray[sourceIndexPath.row]
        classInfo.sessionsArray.remove(at: sourceIndexPath.row)
        classInfo.sessionsArray.insert(itemToMove, at: destinationIndexPath.row)
    }
}
