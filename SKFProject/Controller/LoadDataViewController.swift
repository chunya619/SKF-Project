//
//  LoadDataViewController.swift
//  SKFProject
//
//  Created by 胡淨淳 on 2021/6/15.
//

import UIKit
import CoreData
import Alamofire
import SwiftyJSON
import SVProgressHUD

class LoadDataViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var JOURENY_URL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

    }
    
    override func viewWillAppear(_ animated: Bool) {
        getJourneys()
    }
    
//MARK: - journeyJSON decoding.
    
    func getJourneys() {

        AF.request(JOURENY_URL, method: .get).responseJSON { (response) in
            do {
                if let journeyJSON = response.data {
                    let decoder = JSONDecoder()
                    let journeys = try decoder.decode([JourneyModel].self, from: journeyJSON)
                    print(journeys)
                    print(type(of: journeys))
                    
                    self.saveJourneys(journeys: journeys)
                }
            } catch {
                print("Error getting journeys \(error)")
            }
        }
    }
        
//MARK: - Saving journeys data after journeyJSON decoding.
    
    func saveJourneys(journeys: Array<JourneyModel> ) {

        var listOfJourney = [JourneyItem]()
        
        let request: NSFetchRequest<JourneyItem> = JourneyItem.fetchRequest()

            do {
                let results = try self.context.fetch(request)
                
                for journey in journeys {
                    
                    if results.count == 0 {
                        if let newjourney : JourneyItem = NSEntityDescription.insertNewObject(forEntityName: "JourneyItem", into: self.context)
                            as? JourneyItem {
                            newjourney.id = journey.ID
                            newjourney.startTime = journey.START
                            newjourney.returnTime = journey.RETURN
                            newjourney.destination = journey.DESTINATION
                            newjourney.car = journey.CAR
                            listOfJourney.append(newjourney)
                            print(listOfJourney)
                        }
                        print("Inserting journeys success.")
                        
                    } else {
                        results[0].setValue(journey.START, forKey: "startTime")
                        print("Updating journeys success.")
                    }
                }
                
            } catch {
                print("Error saving journeys \(error)")
            }
        self.saveToSQLite()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.performSegue(withIdentifier: "goToJourney", sender: self)
            let sb : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(identifier: "navigationController")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
   
    
//MARK: -  Saving journeys data to SQLite.
    
    func saveToSQLite() {
        
        do{
            try context.save()
            
            print("success")
            
        } catch (let error) {
            print("Erroring saving context\(error)")
        }
    }
}

