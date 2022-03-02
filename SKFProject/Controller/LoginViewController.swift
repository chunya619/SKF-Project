//
//  ViewController.swift
//  SKFProject
//#imageLiteral(resourceName: "tstorm3.png")
//  Created by 胡淨淳 on 2021/6/13.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var annotateLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let USER_URL = "https://3651-180-177-1-143.ngrok.io/users"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        loginLabel.textColor = UIColor(red: 139/255, green: 71/255, blue: 38/255, alpha: 1)
        loginLabel.font = UIFont.boldSystemFont(ofSize: 35.0)
        annotateLabel.textColor = UIColor(red: 205/255, green: 133/255, blue: 63/255, alpha: 1)
        loginButton.setTitleColor(UIColor(red: 255/255, green: 250/255, blue: 240/255, alpha: 1), for: .normal)
        loginButton.backgroundColor = UIColor(red: 139/255, green: 115/255, blue: 85/255, alpha: 1)
      
    }
    
    
    @IBAction func loginButton(_ sender: Any) {
        SVProgressHUD.show(withStatus: "Loading...")
        
        let account = accountTextField.text!
        let password = passwordTextField.text!

        let params : [String : String] = ["RNAME" : account, "PHONE" : password]

        getValidUser(url: USER_URL, parameters: params)
        
        print("hereeeeeeee")
        
    }
    
    
    func getValidUser(url: String, parameters : [String : String]){
        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
            .response
            { response in
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        // response from API.
                        if let message = response.data {
                            let messageJSON = String(data: message, encoding: String.Encoding.utf8)
                            print("Success Response: \(String(describing: messageJSON))")
                        }
                        // switch to loading page for loading journey records.
                        if let controller = self.storyboard?.instantiateViewController(identifier: "LoadDataViewController") as? LoadDataViewController {
                            
                            controller.modalPresentationStyle = .fullScreen
                            controller.JOURENY_URL = "https://3651-180-177-1-143.ngrok.io/journeys/\(self.accountTextField.text!)"
                            
                            self.present(controller, animated: true, completion: nil)
                        }
                        SVProgressHUD.dismiss()
                            
                    case 400:
                        print("Bad Request")
                        
                        if let message = response.data {
                            let messageJSON = String(data: message, encoding: String.Encoding.utf8)
                            print("Failure Response: \(String(describing: messageJSON))")
                        }
                        
                        let alert = UIAlertController(title: "Login Failed", message: "Invalid username or password please try again.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            self.accountTextField.text?.removeAll()
                            self.passwordTextField.text?.removeAll()
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
                        SVProgressHUD.dismiss()
                        
                    case 404:
                        print("Not Found")
                        
                        if let message = response.data {
                            let messageJSON = String(data: message, encoding: String.Encoding.utf8)
                            print("Failure Response: \(String(describing: messageJSON))")
                        }
                        
                        let alert = UIAlertController(title: "Login Failed", message: "please check your connection and try again.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                        SVProgressHUD.dismiss()
                        
                    default:
                        print("Method Not Allowed")
                        if let message = response.data {
                            let messageJSON = String(data: message, encoding: String.Encoding.utf8)
                            print("Failure Response: \(String(describing: messageJSON))")
                        }
                        SVProgressHUD.dismiss()
                    }
                }
                else {
                    let alert = UIAlertController(title: "Login Failed", message: "Invalid username or password please try again.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    
                    SVProgressHUD.dismiss()
                }
            }
    }
    
}
