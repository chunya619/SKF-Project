//
//  ChangeCityViewController.swift
//  SKFProject
//
//  Created by 胡淨淳 on 2021/7/30.
//

import Foundation
import UIKit

// protocol declaration
protocol ChangeCityDelegate {
    func userEnteredANewCityName(city: String)
}

class ChangeCityViewController: UIViewController {
        
    //Declare the delegate variable
    var delegate : ChangeCityDelegate?
    
    @IBOutlet weak var changeCityTextField: UITextField!
    @IBOutlet weak var getWeatherPressed: UIButton!
    @IBOutlet weak var getWeatherView: UIView!
    
    @IBAction func getWeatherPressed(_ sender: Any) {
        
        //1 Get the city name the user entered in the text field
        let cityName = changeCityTextField.text!
        
        //2 If we have a delegate set, call the method userEnteredANewCityName
        delegate?.userEnteredANewCityName(city: cityName)
        
        //3 dismiss the Change City View Controller to go back to the WeatherViewController
//        self.dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        getWeatherView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        getWeatherPressed.setTitleColor(UIColor(red: 139/255, green: 71/255, blue: 38/255, alpha: 1), for: .normal)
    }
    
    
}
