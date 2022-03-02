//
//  PreviousJourneyTableViewCellViewController.swift
//  SKFProject
//
//  Created by 胡淨淳 on 2021/10/3.
//

import Foundation
import UIKit


class PreviousJourneyTableViewCellViewController: UITableViewCell {
    
    @IBOutlet weak var departureTimeLabel: UILabel!
    @IBOutlet weak var departureTimeInfo: UILabel!
    @IBOutlet weak var returnTimeLabel: UILabel!
    @IBOutlet weak var returnTimeInfo: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var destinationInfo: UILabel!
    @IBOutlet weak var carLabel: UILabel!
    @IBOutlet weak var carInfo: UILabel!
    
    @IBOutlet weak var lineLabel: UILabel!
    
    @IBOutlet weak var PreviousJourneyView: UIView!
}
