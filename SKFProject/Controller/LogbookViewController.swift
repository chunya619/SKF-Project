//
//  LogbookViewController.swift
//  SKFProject
//
//  Created by 胡淨淳 on 2021/7/19.
//

import UIKit
import CoreData
import CoreLocation
import Alamofire
import SwiftyJSON
import SVProgressHUD
import MapKit
import SystemConfiguration.CaptiveNetwork

class LogbookViewController: UITableViewController, CLLocationManagerDelegate, ChangeCityDelegate {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Logbook URL
    let Logbook_URL = "https://3651-180-177-1-143.ngrok.io/logbooks"
    
    //user name for "updater" column
    var updater = ""
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "ae314b4b14d4deefe087feccd5cad922"
    
    //declare instance variables for Location Manager
    let locationManager = CLLocationManager()
    
    let weatherDataModel = WeatherDataModel()
    
    // accepting journey's indexPath from journey page
    var selectedJourney : JourneyItem?

    override func viewWillAppear(_ animated: Bool) {
        loadLogbookInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // keyboard controlling
        self.hideKeyboardWhenTappedAround()
        
        // ------------------------------------------------------------------------------
        // Notification controlling
        self.departureInfoTextField.delegate = self
        self.returnInfoTextField.delegate = self
        self.mBeginInfoTextField.delegate = self
        self.mEndInfoTextField.delegate = self
        self.routeInfoTextField.delegate = self
        self.passengerInfoTextField.delegate = self
        self.fuelInfoTextField.delegate = self
        self.engineOilInfoTextField.delegate = self
        self.commentInfoTextView.delegate = self
        
        // NotificationCenter - Monitor logbook content changes
        NotificationCenter.default.addObserver(self, selector: #selector(backButton(_notification:)), name: Notification.Name("logbookDidChange"), object: nil)
        print("Notification called")
        
        // ------------------------------------------------------------------------------
        //TODO:Set up the location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // ------------------------------------------------------------------------------
        // Current weather color
        temperatureLabel.textColor = UIColor(red: 74/255, green: 112/255, blue: 139/255, alpha: 1)
        cityLabel.textColor = UIColor(red: 74/255, green: 112/255, blue: 139/255, alpha: 1)
        
        // ------------------------------------------------------------------------------
        // Setting title of logbook info
        titleDepartureDate.text = "Departure:"
        titleDepartureDate.textColor = UIColor(red: 79/255, green: 79/255, blue: 79/255, alpha: 1)
        titleDepartureDate.font = UIFont.boldSystemFont(ofSize: 13.0)
        
        titleDepartureDateInfo?.text = titleDepartureDateString
        titleDepartureDateInfo.textColor = UIColor(red: 79/255, green: 79/255, blue: 79/255, alpha: 1)
        titleDepartureDateInfo.font = UIFont.boldSystemFont(ofSize: 13.0)
        
        
        titleReturnDate.text = "Return:"
        titleReturnDate.textColor = UIColor(red: 79/255, green: 79/255, blue: 79/255, alpha: 1)
        titleReturnDate.font = UIFont.boldSystemFont(ofSize: 13.0)
        
        titleReturnDateInfo?.text = titleReturnDateString
        titleReturnDateInfo.textColor = UIColor(red: 79/255, green: 79/255, blue: 79/255, alpha: 1)
        titleReturnDateInfo.font = UIFont.boldSystemFont(ofSize: 13.0)

        titleDestination.text = "Destination:"
        titleDestination.textColor = UIColor(red: 79/255, green: 79/255, blue: 79/255, alpha: 1)
        titleDestination.font = UIFont.boldSystemFont(ofSize: 13.0)
        
        titleDestinationInfo.text = titleDestinationString
        titleDestinationInfo.textColor = UIColor(red: 79/255, green: 79/255, blue: 79/255, alpha: 1)
        titleDestinationInfo.font = UIFont.boldSystemFont(ofSize: 13.0)
        
        // ------------------------------------------------------------------------------
        // Setting Logbook content(in the middle of tableview)
        // departure
        departureInfoLabel.text = "Departure:"
        departureInfoLabel.textColor = UIColor(red: 139/255, green: 119/255, blue: 101/255, alpha: 1)
        departureInfoLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        
        departureInfoTextField.textColor = UIColor(red: 205/255, green: 155/255, blue: 29/255, alpha: 1)
        
        getDepartureButton.setTitleColor(UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1), for: .normal)
        getDepartureButton.backgroundColor = UIColor(red: 139/255, green: 71/255, blue: 38/255, alpha: 1)
        
        //return
        returnInfoLabel.text = "Return:"
        returnInfoLabel.textColor = UIColor(red: 139/255, green: 119/255, blue: 101/255, alpha: 1)
        returnInfoLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        
        returnInfoTextField.textColor = UIColor(red: 205/255, green: 155/255, blue: 29/255, alpha: 1)
        
        getReturnButton.setTitleColor(UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1), for: .normal)
        getReturnButton.backgroundColor = UIColor(red: 139/255, green: 71/255, blue: 38/255, alpha: 1)
        
        //mileage begin
        mBeginInfoLabel.text = "Begin of Mileage:"
        mBeginInfoLabel.textColor = UIColor(red: 139/255, green: 119/255, blue: 101/255, alpha: 1)
        mBeginInfoLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        
        mBeginInfoTextField.textColor = UIColor(red: 205/255, green: 155/255, blue: 29/255, alpha: 1)
        
        //mileage end
        mEndInfoLabel.text = "End of Mileage:"
        mEndInfoLabel.textColor = UIColor(red: 139/255, green: 119/255, blue: 101/255, alpha: 1)
        mEndInfoLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        
        mEndInfoTextField.textColor = UIColor(red: 205/255, green: 155/255, blue: 29/255, alpha: 1)
        
        //route
        routeInfoLabel.text = "Route:"
        routeInfoLabel.textColor = UIColor(red: 139/255, green: 119/255, blue: 101/255, alpha: 1)
        routeInfoLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        
        routeInfoTextField.textColor = UIColor(red: 205/255, green: 155/255, blue: 29/255, alpha: 1)
        
        //passanger
        passengerInfoLabel.text = "Number of Passanger:"
        passengerInfoLabel.textColor = UIColor(red: 139/255, green: 119/255, blue: 101/255, alpha: 1)
        passengerInfoLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        
        passengerInfoTextField.textColor = UIColor(red: 205/255, green: 155/255, blue: 29/255, alpha: 1)
        
        //fuel
        fuelInfoLabel.text = "Fuel Usage:"
        fuelInfoLabel.textColor = UIColor(red: 139/255, green: 119/255, blue: 101/255, alpha: 1)
        fuelInfoLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        
        fuelInfoTextField.textColor = UIColor(red: 205/255, green: 155/255, blue: 29/255, alpha: 1)
        
        //engine oil
        engineOilInfoLabel.text = "Engine Oil Level:"
        engineOilInfoLabel.textColor = UIColor(red: 139/255, green: 119/255, blue: 101/255, alpha: 1)
        engineOilInfoLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        
        engineOilInfoTextField.textColor = UIColor(red: 205/255, green: 155/255, blue: 29/255, alpha: 1)
        
        //comments
        commentInfoTextView.textColor = UIColor(red: 205/255, green: 155/255, blue: 29/255, alpha: 1)
    }
    
//MARK: - Label and textField
    
    // Current weather
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    // Logbook title(top one of tableview): date of departure and return
    var titleDepartureDateString: String?
    var titleReturnDateString: String?
    var titleDestinationString: String?
    @IBOutlet weak var titleDepartureDate: UILabel!
    @IBOutlet weak var titleDepartureDateInfo: UILabel!
    @IBOutlet weak var titleReturnDate: UILabel!
    @IBOutlet weak var titleReturnDateInfo: UILabel!
    @IBOutlet weak var titleDestination: UILabel!
    @IBOutlet weak var titleDestinationInfo: UILabel!
    
    // Logbook info(in the middle of tableview)
    @IBOutlet weak var departureInfoLabel: UILabel!
    @IBOutlet weak var departureInfoTextField: UITextField!
    @IBOutlet weak var getDepartureButton: UIButton!
 
    @IBOutlet weak var returnInfoLabel: UILabel!
    @IBOutlet weak var returnInfoTextField: UITextField!
    @IBOutlet weak var getReturnButton: UIButton!
    
    @IBOutlet weak var mBeginInfoTextField: UITextField!
    @IBOutlet weak var mBeginInfoLabel: UILabel!

    @IBOutlet weak var mEndInfoLabel: UILabel!
    @IBOutlet weak var mEndInfoTextField: UITextField!
    
    @IBOutlet weak var routeInfoLabel: UILabel!
    @IBOutlet weak var routeInfoTextField: UITextField!
    
    @IBOutlet weak var passengerInfoLabel: UILabel!
    @IBOutlet weak var passengerInfoTextField: UITextField!
    
    @IBOutlet weak var fuelInfoLabel: UILabel!
    @IBOutlet weak var fuelInfoTextField: UITextField!
    
    @IBOutlet weak var engineOilInfoLabel: UILabel!
    @IBOutlet weak var engineOilInfoTextField: UITextField!
    
    @IBOutlet weak var commentInfoTextView: UITextView!
    
    // logbook's google map button
    @IBOutlet weak var googleMapButton: UIButton!
    
    // logbook's upload button
    @IBOutlet weak var uploadButton: UIButton!
    
    
//MARK: - Navigation Bar Back Button Action
    
    @objc func backButton(_notification: Notification) {
        let backButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(LogbookViewController.alert))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func doneButtonPressed(_notification: Notification) {
        uploadButton.isEnabled = true
    }
        
//MARK: - Alert for Notification that have not been saved via Done button
        
    @objc func alert() {
        let alert = UIAlertController(title: "Are your sure you want to discard your changes?", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Keep Editing", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Discard Changes", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true)
    }
    
//MARK: - Loading logbook record
        
    // logbook info always appears on the screen when user tap into each journey.
    func loadLogbookInfo(with request: NSFetchRequest<LogbookItem> = LogbookItem.fetchRequest()) {
        
        let predicate = NSPredicate(format: "owner.id == %@", selectedJourney!.id)
        request.predicate = predicate
        
        do {
            let itemArray = try context.fetch(request)
            
            if itemArray.count != 0 {
                for item in itemArray {
                    departureInfoTextField?.text = item.value(forKey: "departureTime") as? String
                    returnInfoTextField?.text = item.value(forKey: "returnTime") as? String
                    mBeginInfoTextField?.text = item.value(forKey: "mBegin") as? String
                    mEndInfoTextField?.text = item.value(forKey: "mEnd") as? String
                    routeInfoTextField?.text = item.value(forKey: "route") as? String
                    passengerInfoTextField?.text = item.value(forKey: "passengers") as? String
                    fuelInfoTextField?.text = item.value(forKey: "fuel") as? String
                    engineOilInfoTextField?.text = item.value(forKey: "enginOil") as? String
                    commentInfoTextView?.text = item.value(forKey: "comments") as? String
                }
            } else {
                print("No previous data")
            }
            
        } catch {
            print("Error fetching data frrom context \(error)")
        }
    }
        
//MARK: - Current Date Button Setting
    
    // button of departure and return date
    @IBAction func departureCurrentDateButton(_ sender: Any) {
        
        // Gets the current date and time
        let currentDateTime = Date()
        
        //Initializes the date formatter and set the style
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm "
        
        // Gets the date and time String from the date object
        let dateTimeString = formatter.string(from: currentDateTime)
        
        // Displays it on textField
        departureInfoTextField.text = dateTimeString
        
        // Monitoring if button is pressed or not
        NotificationCenter.default.post(name: Notification.Name("logbookDidChange"), object: nil)
        print("departureTime did change")
    }
    
    
    @IBAction func returnCurrentDateButton(_ sender: Any) {
        
        let currentDateTime = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm "
        
        let dateTimeString = formatter.string(from: currentDateTime)
        
        returnInfoTextField.text = dateTimeString
        
        NotificationCenter.default.post(name: Notification.Name("logbookDidChange"), object: nil)
        print("returnTime did change")
    }
    
//MARK: - Current Weather
    
    //getWeatherData method:
    func getWeatherData(url: String, parameters: [String : String]) {
        
        AF.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            if let result = response.value {
                print("Success! Got the weather data")
                
                let weatherJSON: JSON = JSON(result)
                self.updateWeatherData(json: weatherJSON)
                
            } else {
                print("Error \(String(describing: response.error))")
                self.cityLabel.text = "Connection Issues"
            }
        }
    }
    
    //updateWeatherData method:
    func updateWeatherData(json : JSON) {
        
        if let tempResult = json["main"]["temp"].double {
        
        weatherDataModel.temperature = Int(tempResult - 273.15)
        weatherDataModel.city = json["name"].stringValue
        weatherDataModel.condition = json["weather"][0]["id"].intValue
        weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
        
        updateUIWithWeatherData()
        }
        else {
            cityLabel.text = "Weather Unavailable"
        }
    }

    // UI updates: updateUIWithWeatherData method :
    func updateUIWithWeatherData() {
        
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = "\(weatherDataModel.temperature)°"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
    }
    
    //MARK: - Location Manager Delegate Methods
    
    //didUpdateLocations method:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters: params )
        }
    }
    
    //didFailWithError method:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    
//MARK: - Change City Delegate methods

//userEnteredANewCityName Delegate method :
    func userEnteredANewCityName(city: String) {
        
        let params : [String : String] = ["q" : city, "appid" : APP_ID]
        
        getWeatherData(url: WEATHER_URL, parameters: params)
    }

//PrepareForSegue Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "changeCityName" {
            
            let destinationVC = segue.destination as! ChangeCityViewController
            
            destinationVC.delegate = self
        }
    }
    
//MARK: - GoogleMaps
    
    var Latitude: CLLocationDegrees = 0.0
    var Longitude: CLLocationDegrees = 0.0
    
    func convertAddress() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(titleDestinationString!, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error\(String(describing: error))")
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                self.desCoordinate(startAddrLat: coordinates.latitude, startAddrLon: coordinates.longitude)
            }
        })
    }
    
    func desCoordinate(startAddrLat: CLLocationDegrees, startAddrLon: CLLocationDegrees){
        Latitude = startAddrLat
        Longitude = startAddrLon
    }
    
    @IBAction func googleMapButtonPressed(_ sender: Any) {
        convertAddress()
        
        DispatchQueue.main.async {
            SVProgressHUD.show()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            SVProgressHUD.dismiss()
            if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
              UIApplication.shared.open(URL(string:
                "comgooglemaps://?saddr=Pachergasse+10+4400+Steyr+Austria&daddr=Johannes+Kepler+University+Linz&directionsmode=driving")!)
            } else {
                let appStoreGoogleMapURL = URL(string: "itms-apps://itunes.apple.com/app/id585027354")!
                UIApplication.shared.open(appStoreGoogleMapURL, options: [:], completionHandler: nil)
            }
        }
    }
    
//MARK: - Setting tableView
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // cell background color
        cell.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
    }
    
//MARK: - Done button : saving logbook to SQLite

// all of the logbook info save to SQLite through CoreData.

    @IBAction func doneButton(_ sender: Any) {
        
    let request: NSFetchRequest<LogbookItem> = LogbookItem.fetchRequest()
        
        let predicate = NSPredicate(format: "owner.id == %@", selectedJourney!.id)
        request.predicate = predicate
        
        do {
            let results = try self.context.fetch(request)
            
            if results.count == 0 {
                let newLogbook = LogbookItem(context: context)
                newLogbook.departureTime = departureInfoTextField.text!
                newLogbook.returnTime = returnInfoTextField.text!
                newLogbook.mBegin = mBeginInfoTextField.text!
                newLogbook.mEnd = mEndInfoTextField.text!
                newLogbook.route = routeInfoTextField.text!
                newLogbook.passengers = passengerInfoTextField.text!
                newLogbook.fuel = fuelInfoTextField.text!
                newLogbook.enginOil = engineOilInfoTextField.text!
                newLogbook.comments = commentInfoTextView.text!
                newLogbook.journeyID = selectedJourney!.id
                
                newLogbook.associateJourney = selectedJourney
                
                print("no this record in SQLite.")
                
            } else {
                results[0].setValue(departureInfoTextField.text!, forKey: "departureTime")
                results[0].setValue(returnInfoTextField.text!, forKey: "returnTime")
                results[0].setValue(mBeginInfoTextField.text!, forKey: "mBegin")
                results[0].setValue(mEndInfoTextField.text!, forKey: "mEnd")
                results[0].setValue(routeInfoTextField.text!, forKey: "route")
                results[0].setValue(passengerInfoTextField.text!, forKey: "passengers")
                results[0].setValue(fuelInfoTextField.text!, forKey: "fuel")
                results[0].setValue(engineOilInfoTextField.text!, forKey: "enginOil")
                results[0].setValue(commentInfoTextView.text!, forKey: "comments")
                
                print("record updated!")
            }
            
        } catch {
            print("Error saving the data \(error)")
        }
        self.saveLogbooks()
        
        print("Saving to SQLite successfully!")
        navigationController?.popViewController(animated: true)
    }

// MARK: - Model Manupulation Methods
    
    func saveLogbooks() {
        do{
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
//MARK: - Detecting Available wifi
    
    func currentSSID() -> String? {
        var ssid: String?
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
        for interface in interfaces {
        if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
            print(ssid as Any)
                    break
                }
            }
        }
        return ssid
    }
    
//MARK: - Upload Logbook Function
    
    func uploadLogbook(url: String, parameters : [String : String]){
        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
            .response
            { response in
                if let status = response.response?.statusCode {
                    switch (status) {
                    case 200:
                        print("Upload Successfully!")
                        
                        SVProgressHUD.dismiss()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            let alert = UIAlertController(title: "Upload successfully!", message: "logbook is uploaded to central database.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                self.navigationController?.popViewController(animated: true)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                        DispatchQueue.global().async {
                            
                            let request: NSFetchRequest<JourneyItem> = JourneyItem.fetchRequest()
                            
                            let predicate = NSPredicate(format: "id == %@", self.selectedJourney!.id)
                            request.predicate = predicate
                            
                            do {
                                let results = try self.context.fetch(request)
                                if results.count != 0 {
                                    results[0].setValue(0, forKey: "status")
                                    print("status updating")
                                }
                            } catch {
                                print("Error updating journey status \(error)")
                            }
                            self.saveLogbooks()
                        }
                    default:
                        print("Upload Failed.")
                        
                        let alert = UIAlertController(title: "Upload Failed", message: "the web server is not connected yet.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
    }
                
//MARK: - Upload Button

    @IBAction func uploadButtonPressed(_ sender: Any) {
        
        let firstAlert = UIAlertController(title: "Please make sure all logbook content was saved.", message: "press the Done button to save your logbook.", preferredStyle: .alert)
        firstAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            let alert = UIAlertController(title: "Are your sure you want to upload your logbook?", message: nil, preferredStyle: .actionSheet)

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Upload", style: .default, handler: { action in
                
                SVProgressHUD.show(withStatus: "uploading")
                SVProgressHUD.setForegroundColor(UIColor(red: 255/255, green: 193/255, blue: 37/255, alpha: 1))
               
                if (self.currentSSID() != "淳") {
                    
                    let connectAlert = UIAlertController(title: "Please connect to the company's intranet to complete the upload", message: "", preferredStyle: .alert)
                    connectAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    print("7777777777")
                   
                } else {
                    print("88888888888")
                    let journeyID = String(self.selectedJourney!.id)
                    let departureTime = self.departureInfoTextField.text!
                    let returnTime = self.returnInfoTextField.text!
                    let mBegin = self.mBeginInfoTextField.text!
                    let mEnd = self.mEndInfoTextField.text!
                    let route = self.routeInfoTextField.text!
                    let passengers = self.passengerInfoTextField.text!
                    let fuel = self.fuelInfoTextField.text!
                    let engineOil = self.engineOilInfoTextField.text!
                    let remark = self.commentInfoTextView.text!
                    let updater = self.updater
                    let params : [String : String] = ["JOURNEYID" : journeyID, "DEPARTURE" : departureTime, "RETURN" : returnTime, "MBEGIN" : mBegin, "MEND" : mEnd, "ROUTE" : route, "PASSENGERS" : passengers, "FUEL" : fuel, "ENGINEOIL" : engineOil, "REMARK" : remark, "UPDATER" : updater]

                    self.uploadLogbook(url: self.Logbook_URL, parameters: params)
                }
            }))
            self.present(alert, animated: true)
        }))
        self.present(firstAlert, animated: true)
    }
}

// MARK: - Monitoring Logbook Info Did Change

extension LogbookViewController: UITextFieldDelegate {

    //Monitering if textField change or not
    @IBAction func departureDidChange(_ sender: UITextField) {
    NotificationCenter.default.post(name: Notification.Name("logbookDidChange"), object: nil)
        print("departure time did changed.")
    }
    
    @IBAction func returnDidChange(_ sender: UITextField) {
    NotificationCenter.default.post(name: Notification.Name("logbookDidChange"), object: nil)
        print("return time did changed.")
    }
    
    @IBAction func mBeginDidChange(_ sender: UITextField) {
        NotificationCenter.default.post(name: Notification.Name("logbookDidChange"), object: nil)
        print("begin of mileage did changed.")
    }
    
    @IBAction func mEndDidChange(_ sender: UITextField) {
        NotificationCenter.default.post(name: Notification.Name("logbookDidChange"), object: nil)
        print("end of mileage did changed.")
    }

    @IBAction func routeDidChange(_ sender: UITextField) {
    NotificationCenter.default.post(name: Notification.Name("logbookDidChange"), object: nil)
        print("route did changed.")
    }
    
    @IBAction func passengerDidChange(_ sender: UITextField) {
    NotificationCenter.default.post(name: Notification.Name("logbookDidChange"), object: nil)
        print("passenger did changed.")
    }
    
    @IBAction func fuelDidChange(_ sender: UITextField) {
    NotificationCenter.default.post(name: Notification.Name("logbookDidChange"), object: nil)
        print("fuel did changed.")
    }
    
    @IBAction func engineOilDidChange(_ sender: UITextField) {
    NotificationCenter.default.post(name: Notification.Name("logbookDidChange"), object: nil)
        print("engine oil did changed.")
    }
}

extension LogbookViewController : UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        print(commentInfoTextView.text!)
        
        NotificationCenter.default.post(name: Notification.Name("logbookDidChange"), object: nil)
        print("comments did changed.")
    }
}

//MARK: - Keyboard Controlling

extension LogbookViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(LogbookViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
