//
//  ClientsViewController.swift
//  TrainerBase
//
//  Created by Daniel Yang on 12/7/19.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit

class ClientsViewController: UIViewController {
    @IBOutlet weak var clientsTableView: UITableView!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    var clientsArray = [ClientInfo]()
    var clientInfo = ClientInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clientsTableView.delegate = self
        clientsTableView.dataSource = self
        
        loadFromUserDefaults()
    }
    
    @IBAction func unwindFromClientDetailViewController(segue: UIStoryboardSegue) {
        let source = segue.source as! ClientDetailViewController
        clientInfo = source.clientInfo
        if let selectedIndexPath = clientsTableView.indexPathForSelectedRow {
            clientsArray[selectedIndexPath.row] = clientInfo
            clientsTableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            clientsTableView.deselectRow(at: selectedIndexPath, animated: true)
        } else {
            let newIndexPath = IndexPath(row: clientsArray.count, section: 0)
            clientsArray.append(clientInfo)
            clientsTableView.insertRows(at: [newIndexPath], with: .bottom)
            clientsTableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        }
        let homeTab = tabBarController?.viewControllers![0].children[0] as! HomeViewController
        homeTab.clientsArray = clientsArray
        homeTab.reloadInputViews()
        saveToUserDefaults()
    }
    
    @IBAction func editBarButtonPressed(_ sender: UIBarButtonItem) {
        if clientsTableView.isEditing {
            clientsTableView.setEditing(false, animated: true)
            editBarButton.title = "Edit"
            addBarButton.isEnabled = true
        } else {
            clientsTableView.setEditing(true, animated: true)
            editBarButton.title = "Done"
            addBarButton.isEnabled = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ShowClient":
            let destination = segue.destination as! ClientDetailViewController
            let selectedIndex = clientsTableView.indexPathForSelectedRow!
            destination.clientInfo = clientsArray[selectedIndex.row]
        default:
            if let selectedPath = clientsTableView.indexPathForSelectedRow {
                clientsTableView.deselectRow(at: selectedPath, animated: true)
            }
        }
    }
    
    func saveToUserDefaults() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(clientsArray) {
            UserDefaults.standard.set(encoded, forKey: "clientsArray")
        } else {
            print("ERROR: Saving encoded didn't work")
        }
    }
    
    func loadFromUserDefaults() {
        guard let arrayEncoded = UserDefaults.standard.value(forKey: "clientsArray") as? Data else {
            return
        }
        let decoder = JSONDecoder()
        if let clientsArray = try? decoder.decode(Array.self, from: arrayEncoded) as [ClientInfo] {
            self.clientsArray = clientsArray
        } else {
            print("ERROR: Couldn't decode data read in from UserDefaults")
        }
    }
}

extension ClientsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clientsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = clientsTableView.dequeueReusableCell(withIdentifier: "ClientCell", for: indexPath)
        cell.textLabel?.text = clientsArray[indexPath.row].name
        if clientsArray[indexPath.row].age != "" {
            cell.detailTextLabel?.text = "Age: \(clientsArray[indexPath.row].age)"
        } else {
            cell.detailTextLabel?.text = ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            clientsArray.remove(at: indexPath.row)
            clientsTableView.deleteRows(at: [indexPath], with: .fade)
        }
        let homeTab = tabBarController?.viewControllers![0].children[0] as! HomeViewController
        homeTab.clientsArray = clientsArray
        homeTab.reloadInputViews()
        saveToUserDefaults()
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = clientsArray[sourceIndexPath.row]
        clientsArray.remove(at: sourceIndexPath.row)
        clientsArray.insert(itemToMove, at: destinationIndexPath.row)
        let homeTab = tabBarController?.viewControllers![0].children[0] as! HomeViewController
        homeTab.clientsArray = clientsArray
        homeTab.reloadInputViews()
        saveToUserDefaults()
    }
}
