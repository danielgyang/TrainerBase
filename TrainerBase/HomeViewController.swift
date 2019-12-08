//
//  HomeViewController.swift
//  TrainerBase
//
//  Created by Daniel Yang on 12/6/19.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HomeViewController: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var numberOfSessionsImageView: UIImageView!
    @IBOutlet weak var scheduledForTodayLabel: UILabel!
    let date = Date()
    let formatter = DateFormatter()
    var clientsArray = [ClientInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        
        let dateString = formatter.string(from: date)
        let dayOfWeek = getDayOfWeek(dateString)
        var day = ""
        switch dayOfWeek {
        case 1:
            day = "Sunday"
        case 2:
            day = "Monday"
        case 3:
            day = "Tuesday"
        case 4:
            day = "Wednesday"
        case 5:
            day = "Thursday"
        case 6:
            day = "Friday"
        case 7:
            day = "Saturday"
        default:
            print("ERROR: day of week not valid")
        }
        dateLabel.text = "\(day), \(dateString)"
        
        var sessionsToday = 0
        for client in clientsArray {
            for session in client.sessionsArray {
                if session.dayOfWeek == day {
                    sessionsToday += 1
                }
            }
        }
        if sessionsToday == 1 {
            scheduledForTodayLabel.text = "sessions scheduled for today!"
        } else {
            scheduledForTodayLabel.text = "sessions scheduled for today!"
        }
        numberOfSessionsImageView.image = UIImage(systemName: "\(sessionsToday).circle.fill")
    }

    func getDayOfWeek(_ today: String) -> Int! {
        let formatter  = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }

}

