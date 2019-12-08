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
    var classes = [Class]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        classesTableView.delegate = self
        classesTableView.dataSource = self
    }
}

extension ClassesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = classesTableView.dequeueReusableCell(withIdentifier: "ClassCell", for: indexPath)
        cell.textLabel?.text = classes[indexPath.row].name
        return cell
    }
    
    
}
