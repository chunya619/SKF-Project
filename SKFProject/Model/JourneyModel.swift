//
//  JourneyModel.swift
//  SKFProject
//
//  Created by 胡淨淳 on 2021/6/15.
//

import Foundation
import SwiftyJSON

struct JourneyModel: Codable {
    var ID: Int32
    var START: String
    var RETURN: String
    var DESTINATION: String
    var CAR: Int32
    var STATUS: Int32
    
    enum CodingKeys: String, CodingKey {
        case ID
        case START
        case RETURN
        case DESTINATION
        case CAR
        case STATUS
    }
}
