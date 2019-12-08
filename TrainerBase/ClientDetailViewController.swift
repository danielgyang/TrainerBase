//
//  ClientDetailViewController.swift
//  TrainerBase
//
//  Created by Daniel Yang on 12/7/19.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit

class ClientDetailViewController: UIViewController {
    @IBOutlet weak var clientScheduleTableView: UITableView!
    @IBOutlet weak var clientNameTextField: UITextField!
    @IBOutlet weak var clientAgeTextField: UITextField!
    @IBOutlet weak var clientSexTextField: UITextField!
    @IBOutlet weak var clientEmailTextField: UITextField!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    var clientInfo = ClientInfo()
    var dayOfWeek = ""
    var timeOfDay = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clientScheduleTableView.delegate = self
        clientScheduleTableView.dataSource = self
        
        clientNameTextField.text = clientInfo.name
        clientAgeTextField.text = clientInfo.age
        clientSexTextField.text = clientInfo.sex
        clientEmailTextField.text = clientInfo.email
        
        if clientNameTextField.text == "" {
            saveBarButton.isEnabled = false
        } else {
            saveBarButton.isEnabled = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ShowSession":
            let destination = segue.destination as! ClientSessionViewController
            let selectedIndex = clientScheduleTableView.indexPathForSelectedRow!
            destination.dayOfWeek = clientInfo.sessionsArray[selectedIndex.row].dayOfWeek
            destination.timeOfDay = clientInfo.sessionsArray[selectedIndex.row].timeOfDay
        case "UnwindFromDetailSave":
            clientInfo.name = clientNameTextField.text ?? ""
            clientInfo.age = clientAgeTextField.text ?? ""
            clientInfo.sex = clientSexTextField.text ?? ""
            clientInfo.email = clientEmailTextField.text ?? ""
        default:
            if let selectedPath = clientScheduleTableView.indexPathForSelectedRow {
                clientScheduleTableView.deselectRow(at: selectedPath, animated: true)
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UITabBarController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController!.popViewController(animated: true)
        }
    }
    
    @IBAction func unwindFromClientSessionViewController(segue: UIStoryboardSegue) {
        let source = segue.source as! ClientSessionViewController
        let session = Session()
        session.dayOfWeek = source.dayOfWeek
        session.timeOfDay = source.timeOfDay
        if let selectedIndexPath = clientScheduleTableView.indexPathForSelectedRow {
            clientInfo.sessionsArray[selectedIndexPath.row] = session
            clientScheduleTableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            clientScheduleTableView.deselectRow(at: selectedIndexPath, animated: true)
        } else {
            let newIndexPath = IndexPath(row: clientInfo.sessionsArray.count, section: 0)
            clientInfo.sessionsArray.append(session)
            clientScheduleTableView.insertRows(at: [newIndexPath], with: .bottom)
            clientScheduleTableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        }
    }
    
    @IBAction func clientNameTextFieldChanged(_ sender: UITextField) {
        if clientNameTextField.text == "" {
            saveBarButton.isEnabled = false
        } else {
            saveBarButton.isEnabled = true
        }
    }
    
    @IBAction func nameDoneKeyPressed(_ sender: UITextField) {
        clientNameTextField.resignFirstResponder()
    }
    
    @IBAction func ageDoneKeyPressed(_ sender: UITextField) {
        clientAgeTextField.resignFirstResponder()
    }
    
    @IBAction func sexDoneKeyPressed(_ sender: UITextField) {
        clientSexTextField.resignFirstResponder()
    }
    
    @IBAction func emailDoneKeyPressed(_ sender: UITextField) {
        clientEmailTextField.resignFirstResponder()
    }
    
    @IBAction func editBarButtonPressed(_ sender: UIBarButtonItem) {
        if clientScheduleTableView.isEditing {
            clientScheduleTableView.setEditing(false, animated: true)
            editBarButton.title = "Edit"
            addBarButton.isEnabled = true
        } else {
            clientScheduleTableView.setEditing(true, animated: true)
            editBarButton.title = "Done"
            addBarButton.isEnabled = false
        }
    }
}

extension ClientDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clientInfo.sessionsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = clientScheduleTableView.dequeueReusableCell(withIdentifier: "ScheduleCell", for: indexPath)
        cell.textLabel?.text = "\(clientInfo.sessionsArray[indexPath.row].dayOfWeek), \(clientInfo.sessionsArray[indexPath.row].timeOfDay)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            clientInfo.sessionsArray.remove(at: indexPath.row)
            clientScheduleTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = clientInfo.sessionsArray[sourceIndexPath.row]
        clientInfo.sessionsArray.remove(at: sourceIndexPath.row)
        clientInfo.sessionsArray.insert(itemToMove, at: destinationIndexPath.row)
    }
}
