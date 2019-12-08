//
//  SessionsTodayViewController.swift
//  TrainerBase
//
//  Created by Daniel Yang on 12/8/19.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit

class SessionsTodayViewController: UIViewController {
    @IBOutlet weak var clientsTodayTableView: UITableView!
    @IBOutlet weak var classesTodayTableView: UITableView!
    var clientsTodayArray = [ClientInfo]()
    var classesTodayArray = [ClassInfo]()
    var clientsTimeArray = [String]()
    var classesTimeArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        clientsTodayTableView.delegate = self
        clientsTodayTableView.dataSource = self
        classesTodayTableView.delegate = self
        classesTodayTableView.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController!.popViewController(animated: true)
    }
}

extension SessionsTodayViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case clientsTodayTableView:
            return clientsTodayArray.count
        case classesTodayTableView:
            return classesTodayArray.count
        default:
            print("Error while populating tableViews")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case clientsTodayTableView:
            let cell = clientsTodayTableView.dequeueReusableCell(withIdentifier: "TodayClientCell", for: indexPath)
            cell.textLabel?.text = clientsTodayArray[indexPath.row].name
            cell.detailTextLabel?.text = clientsTimeArray[indexPath.row]
            return cell
        case classesTodayTableView:
            let cell = classesTodayTableView.dequeueReusableCell(withIdentifier: "TodayClassCell", for: indexPath)
            cell.textLabel?.text = classesTodayArray[indexPath.row].name
            cell.detailTextLabel?.text = classesTimeArray[indexPath.row]
            return cell
        default:
            let cell = classesTodayTableView.dequeueReusableCell(withIdentifier: "TodayClassCell", for: indexPath)
            return cell
        }
    }
}
