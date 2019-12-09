//
//  ClientInfo.swift
//  TrainerBase
//
//  Created by Daniel Yang on 12/7/19.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import Foundation

class ClientInfo: Codable {
    var name = ""
    var age = ""
    var sex = ""
    var email = ""
    var sessionsArray = [Session]()
}
