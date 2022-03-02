//
//  PreviousJourneyViewControllerTableViewController.swift
//  SKFProject
//
//  Created by 胡淨淳 on 2021/10/3.
//

import UIKit
import CoreData

class PreviousJourneyViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // array for journey
    var itemArray = [JourneyItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 120;
        self.tableView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)

        tableView.delegate = self
        tableView.dataSource = self
        
        print("entring record page!!!!!")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadJourneys()
    }
        
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

    func loadJourneys(with request: NSFetchRequest<JourneyItem> = JourneyItem.fetchRequest()) {
        
        // only the uncompleted journey will be displayed.
        request.predicate = NSPredicate(format: "status == %i", 0)
        // sorting journey by start time.
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(JourneyItem.startTime), ascending: true)]
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToPreviousLogbook", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"PreviousJourneyCell", for: indexPath) as! PreviousJourneyTableViewCellViewController

        // color for selected tableview cell
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        cell.selectedBackgroundView = backgroundView
        
        cell.PreviousJourneyView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        
        // setting journey tableview title's color and font.
        cell.departureTimeLabel.text = "Departure:"
        cell.departureTimeLabel.textColor = UIColor(red: 96/255, green: 123/255, blue: 139/255, alpha: 1)
        cell.departureTimeLabel.font = UIFont.boldSystemFont(ofSize: 14)
        
        cell.lineLabel.text = "..........................................................................................."
        
        cell.returnTimeLabel.text = "Return:"
        cell.returnTimeLabel.textColor = UIColor(red: 79/255, green: 79/255, blue: 79/255, alpha: 1)
        cell.returnTimeLabel.font = UIFont.boldSystemFont(ofSize: 12)
        
        cell.destinationLabel.text = "Destination:"
        cell.destinationLabel.textColor = UIColor(red: 79/255, green: 79/255, blue: 79/255, alpha: 1)
        cell.destinationLabel.font = UIFont.boldSystemFont(ofSize: 12)
        
        cell.carLabel.text = "Car:"
        cell.carLabel.textColor = UIColor(red: 79/255, green: 79/255, blue: 79/255, alpha: 1)
        cell.carLabel.font = UIFont.boldSystemFont(ofSize: 12)
        
        
        let item = itemArray[indexPath.row]
        
        // departure time
        cell.departureTimeInfo.text = item.startTime
        cell.departureTimeInfo.textColor = UIColor(red: 96/255, green: 123/255, blue: 139/255, alpha: 1)
        cell.departureTimeInfo.font = UIFont.boldSystemFont(ofSize: 14)
        
        // return time
        cell.returnTimeInfo?.text = item.returnTime
        cell.returnTimeInfo.textColor = UIColor(red: 79/255, green: 79/255, blue: 79/255, alpha: 1)
        cell.returnTimeInfo.font = UIFont.boldSystemFont(ofSize: 12)
        
        //destination
        cell.destinationInfo?.text = item.destination
        cell.destinationInfo.textColor = UIColor(red: 79/255, green: 79/255, blue: 79/255, alpha: 1)
        cell.destinationInfo.font = UIFont.boldSystemFont(ofSize: 12)
        
        // car
        cell.carInfo?.text = carName(number: item.car)
        cell.carInfo.textColor = UIColor(red: 79/255, green: 79/255, blue: 79/255, alpha: 1)
        cell.carInfo.font = UIFont.boldSystemFont(ofSize: 12)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // cell background color
        cell.backgroundColor = UIColor.clear
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let logbookVC = segue.destination as! PreviousLogbookViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            logbookVC.selectedJourney = itemArray[indexPath.row]
            print(itemArray[indexPath.row])
        }
        
    }
}
