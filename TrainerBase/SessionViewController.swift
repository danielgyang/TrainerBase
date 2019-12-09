//
//  SessionViewController.swift
//  TrainerBase
//
//  Created by Daniel Yang on 12/7/19.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit

class SessionViewController: UIViewController {
    @IBOutlet weak var dayPickerView: UIPickerView!
    @IBOutlet weak var timePickerView: UIDatePicker!
    var dayOfWeek = ""
    var timeOfDay = ""
    let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dayPickerView.delegate = self
        dayPickerView.dataSource = self
        
        if dayOfWeek != "" {
            let row = daysOfWeek.firstIndex(of: dayOfWeek)!
            dayPickerView.selectRow(row, inComponent: 0, animated: true)
        } else {
            dayOfWeek = daysOfWeek[0]
        }
        
        timeOfDay = DateFormatter.localizedString(from: timePickerView.date, dateStyle: DateFormatter.Style.none, timeStyle: DateFormatter.Style.short)
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        timeOfDay = DateFormatter.localizedString(from: timePickerView.date, dateStyle: DateFormatter.Style.none, timeStyle: DateFormatter.Style.short)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        if presentingViewController is UINavigationController {
            let isPresentingInAddMode = presentingViewController is UINavigationController
            if isPresentingInAddMode {
                dismiss(animated: true, completion: nil)
            } else {
                navigationController!.popViewController(animated: true)
            }
        } else if presentingViewController is UITabBarController {
            let isPresentingInAddMode = presentingViewController is UITabBarController
            if isPresentingInAddMode {
                dismiss(animated: true, completion: nil)
            } else {
                navigationController!.popViewController(animated: true)
            }
        }
    }
}

extension SessionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return daysOfWeek.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dayOfWeek = daysOfWeek[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return daysOfWeek[row]
    }
}
