//
//  PreviousLogbookViewController.swift
//  SKFProject
//
//  Created by 胡淨淳 on 2021/10/3.
//

import UIKit
import CoreData

class PreviousLogbookViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // accepting journey's indexPath from journey page
    var selectedJourney : JourneyItem?
    
    
    @IBOutlet weak var departureInfoLabel: UILabel!
    @IBOutlet weak var departureDetailLabel: UILabel!
    
    @IBOutlet weak var returnInfoLabel: UILabel!
    @IBOutlet weak var returnDetailLabel: UILabel!
    
    @IBOutlet weak var mBeginInfoLabel: UILabel!
    @IBOutlet weak var mBeginDetailLabel: UILabel!
    
    @IBOutlet weak var mEndInfoLabel: UILabel!
    @IBOutlet weak var mEndDetailLabel: UILabel!
    
    @IBOutlet weak var routeInfoLabel: UILabel!
    @IBOutlet weak var routeDetailLabel: UILabel!
  
    @IBOutlet weak var passengerInfoLabel: UILabel!
    @IBOutlet weak var passengerDetailLabel: UILabel!
    
    @IBOutlet weak var fuelInfoLabel: UILabel!
    @IBOutlet weak var fuelDetailLabel: UILabel!
    
    @IBOutlet weak var engineOilInfoLabel: UILabel!
    @IBOutlet weak var engineOilDetailLabel: UILabel!
    
    @IBOutlet weak var commentInfoTextView: UITextView!

    
    override func viewWillAppear(_ animated: Bool) {
        loadLogbookInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // keyboard controlling
        self.hideKeyboardWhenTappedAround()
        
        departureInfoLabel.text = "Departure:"
        departureInfoLabel.textColor = UIColor(red: 96/255, green: 123/255, blue: 139/255, alpha: 1)
        departureInfoLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        
        departureDetailLabel.textColor = UIColor(red: 79/255, green: 79/255, blue: 79/255, alpha: 1)
        
        //return
        returnInfoLabel.text = "Return:"
        returnInfoLabel.textColor = UIColor(red: 96/255, green: 123/255, blue: 139/255, alpha: 1)
        returnInfoLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        
        returnDetailLabel.textColor = UIColor(red: 79/255, green: 79/255, blue: 79/255, alpha: 1)
       
        //mileage begin
        mBeginInfoLabel.text = "Begin of Mileage:"
        mBeginInfoLabel.textColor = UIColor(red: 96/255, green: 123/255, blue: 139/255, alpha: 1)
        mBeginInfoLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        
        mBeginDetailLabel.textColor = UIColor(red: 79/255, green: 79/255, blue: 79/255, alpha: 1)
        
        //mileage end
        mEndInfoLabel.text = "End of Mileage:"
        mEndInfoLabel.textColor = UIColor(red: 96/255, green: 123/255, blue: 139/255, alpha: 1)
        mEndInfoLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        
        mEndDetailLabel.textColor = UIColor(red: 79/255, green: 79/255, blue: 79/255, alpha: 1)
        
        //route
        routeInfoLabel.text = "Route:"
        routeInfoLabel.textColor = UIColor(red: 96/255, green: 123/255, blue: 139/255, alpha: 1)
        routeInfoLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        
        routeDetailLabel.textColor = UIColor(red: 79/255, green: 79/255, blue: 79/255, alpha: 1)
        
        //passanger
        passengerInfoLabel.text = "Number of Passanger:"
        passengerInfoLabel.textColor = UIColor(red: 96/255, green: 123/255, blue: 139/255, alpha: 1)
        passengerInfoLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        
        passengerDetailLabel.textColor = UIColor(red: 79/255, green: 79/255, blue: 79/255, alpha: 1)
        
        //fuel
        fuelInfoLabel.text = "Fuel Usage:"
        fuelInfoLabel.textColor = UIColor(red: 96/255, green: 123/255, blue: 139/255, alpha: 1)
        fuelInfoLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        
        fuelDetailLabel.textColor = UIColor(red: 79/255, green: 79/255, blue: 79/255, alpha: 1)
        
        //engine oil
        engineOilInfoLabel.text = "Engine Oil Level:"
        engineOilInfoLabel.textColor = UIColor(red: 96/255, green: 123/255, blue: 139/255, alpha: 1)
        engineOilInfoLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        
        engineOilDetailLabel.textColor = UIColor(red: 79/255, green: 79/255, blue: 79/255, alpha: 1)
        
        //comments
        commentInfoTextView.textColor = UIColor(red: 79/255, green: 79/255, blue: 79/255, alpha: 1)
    }
    
//MARK: - Loading previous logbook
        
    // logbook info always appears on the screen when user tap into each journey.
    func loadLogbookInfo(with request: NSFetchRequest<LogbookItem> = LogbookItem.fetchRequest()) {
        
        // only the completed journey will be displayed.
        let statusPredicate = NSPredicate(format: "owner.status == %i", 0)
        let idPredicate = NSPredicate(format: "owner.id == %ld", selectedJourney!.id)
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates: [statusPredicate, idPredicate])
        request.predicate = compound
        
        do {
            let itemArray = try context.fetch(request)
            print(itemArray)
            
            if itemArray.count != 0 {
                for item in itemArray {
                    departureDetailLabel?.text = item.value(forKey: "departureTime") as? String
                    returnDetailLabel?.text = item.value(forKey: "returnTime") as? String
                    mBeginDetailLabel?.text = item.value(forKey: "mBegin") as? String
                    mEndDetailLabel?.text = item.value(forKey: "mEnd") as? String
                    routeDetailLabel?.text = item.value(forKey: "route") as? String
                    passengerDetailLabel?.text = item.value(forKey: "passengers") as? String
                    fuelDetailLabel?.text = item.value(forKey: "fuel") as? String
                    engineOilDetailLabel?.text = item.value(forKey: "enginOil") as? String
                    commentInfoTextView?.text = item.value(forKey: "comments") as? String
                }
            } else {
                print("No previous data")
            }
            
        } catch {
            print("Error fetching data from context \(error)")
        }
    }

}
//MARK: - Keyboard Controlling

extension PreviousLogbookViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(PreviousLogbookViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

