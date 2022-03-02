//
//  JourneyViewController.swift
//  SKFProject
//
//  Created by 胡淨淳 on 2021/6/23.
//

import UIKit
import Foundation
import CoreData

class JourneyViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // array for journey
    var itemArray = [JourneyItem]()
    var updater = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 120;
        self.tableView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        
        let recordButton = UIBarButtonItem(title: "Record", style: .plain, target: self, action: #selector(recordButtonPressed))
        self.navigationItem.rightBarButtonItem = recordButton
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("now in journey tableview page")
        loadJourneys()
}


//MARK: - Setting Car Name According to Car Number
    
    func carName(number: Int32) -> String {
        
        switch (number) {
        case 1 :
            return "SR480CX"
            
        case 2 :
            return "SR49HM"
            
        case 3 :
            return "SR231DL"
        
        case 4 :
            return "L3074T"
            
        case 5 :
            return "L7100H"
        
        case 6 :
            return "L7071H"
            
        default:
            return "No car available."
        }
    }
    
//MARK: - Previous Journey
    
    @objc public func recordButtonPressed() {
    if let presentVC = self.storyboard?.instantiateViewController(withIdentifier: "PreviousJourneyViewController") as? PreviousJourneyViewController {
        self.navigationController?.pushViewController(presentVC, animated: true)
        }
    }
    
//MARK: - Loading Data From SQLite
    
    func loadJourneys(with request: NSFetchRequest<JourneyItem> = JourneyItem.fetchRequest()) {
        
        // only the uncompleted journey will be displayed.
        request.predicate = NSPredicate(format: "status == %i", 1)
        // sorting journey by start time.
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(JourneyItem.startTime), ascending: true)]
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        self.tableView.reloadData()
    }

//MARK: - TableView Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToLogbook", sender: self)
        
        print("selected!!!!!")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"JourneyItemCell", for: indexPath) as! JourneyTableViewCellViewController
        
        // color for selected tableview cell
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        cell.selectedBackgroundView = backgroundView
        
        cell.journeyContentView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        
        // ----------------------------------------------------------------------------------------------
        // setting journey tableview title's color and font.
        cell.departureTitleLabel.text = "Departure:"
        cell.departureTitleLabel.textColor = UIColor(red: 96/255, green: 123/255, blue: 139/255, alpha: 1)
        cell.departureTitleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        
        cell.lineLabel.text = "..........................................................................................."
        
        cell.returnTitleLabel.text = "Return:"
        cell.returnTitleLabel.textColor = UIColor(red: 139/255, green: 90/255, blue: 43/255, alpha: 1)
        cell.returnTitleLabel.font = UIFont.boldSystemFont(ofSize: 12)
        
        cell.destinationTitleLabel.text = "Destination:"
        cell.destinationTitleLabel.textColor = UIColor(red: 139/255, green: 90/255, blue: 43/255, alpha: 1)
        cell.destinationTitleLabel.font = UIFont.boldSystemFont(ofSize: 12)
        
        cell.carTitleLabel.text = "Car:"
        cell.carTitleLabel.textColor = UIColor(red: 139/255, green: 90/255, blue: 43/255, alpha: 1)
        cell.carTitleLabel.font = UIFont.boldSystemFont(ofSize: 12)
        
        // ----------------------------------------------------------------------------------------------
        // journey's content in SQlite.
        let item = itemArray[indexPath.row]
        //departure time
        cell.departureLabel.text = item.startTime
        cell.departureLabel.textColor = UIColor(red: 96/255, green: 123/255, blue: 139/255, alpha: 1)
        cell.departureLabel.font = UIFont.boldSystemFont(ofSize: 14)
        
        // return time
        cell.returnLabel?.text = item.returnTime
        cell.returnLabel.textColor = UIColor(red: 139/255, green: 90/255, blue: 43/255, alpha: 1)
        cell.returnLabel.font = UIFont.boldSystemFont(ofSize: 12)
        
        //destination
        cell.destinationLabel?.text = item.destination
        cell.destinationLabel.textColor = UIColor(red: 139/255, green: 90/255, blue: 43/255, alpha: 1)
        cell.destinationLabel.font = UIFont.boldSystemFont(ofSize: 12)
        
        // car
        cell.carLabel?.text = carName(number: item.car)
        cell.carLabel.textColor = UIColor(red: 139/255, green: 90/255, blue: 43/255, alpha: 1)
        cell.carLabel.font = UIFont.boldSystemFont(ofSize: 12)
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // cell background color
        cell.backgroundColor = UIColor.clear
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let logbookVC = segue.destination as! LogbookViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            let item = itemArray[indexPath.row]
            
            // each journey will pass departure and return time to associate logbook.
            logbookVC.titleDepartureDateString = item.startTime
            logbookVC.titleReturnDateString = item.returnTime
            logbookVC.titleDestinationString = item.destination
            logbookVC.updater = updater
            
            // passing journey's indexPath to logbook and logbook know which journey was triggered by user.
            logbookVC.selectedJourney = itemArray[indexPath.row]
            print(item)
        }
    }
}
