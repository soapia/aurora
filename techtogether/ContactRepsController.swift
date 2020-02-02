//
//  ContactRepsController.swift
//  techtogether
//
//  Created by Sofia Ongele on 2/1/20.
//  Copyright © 2020 Sofia Ongele. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ContactRepsController: UIViewController {
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var repNameLabel: UILabel!
    @IBOutlet weak var occupationLabel: UILabel!
    @IBOutlet weak var politicalPartyLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    let API_URL = "https://www.googleapis.com/civicinfo/v2/representatives"
    let API_KEY = "AIzaSyAAJbHAbRRaTMJV9565FNW4slA6AU6Q3vY"
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            repNameLabel.isHidden = true
            occupationLabel.isHidden = true
            politicalPartyLabel.isHidden = true
            emailLabel.isHidden = true
            phoneNumberLabel.isHidden = true
            imageView.isHidden = true
            // Do any additional setup after loading the view.
        }
        
        func getAPIData(url: String, parameters: [String : Any]) {
            
            Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
                
                response in
                if response.result.isSuccess {
                    print("Success! Got the API data.")
                    
                    let apiJSON : JSON = JSON(response.result.value!)
                    print(apiJSON)
                    self.updateInfo(json: apiJSON)
                }
                else {
                    print("Error \(response.result.error)")
                }
                
            }
            
        }
    
    @IBAction func findRepsButtonPressed(_ sender: UIButton) {
        
        let params : [String : Any] = ["address" : addressTextField.text!, "levels" : "administrativeArea1", "roles" : "legislatorLowerBody", "key" : API_KEY]
                
                getAPIData(url: API_URL, parameters : params)
                
        //        let params2 : [String : Any] = ["address" : addressTextField.text!, "levels" : "administrativeArea1", "roles" : "legislatorUpperBody", "key" : API_KEY]
        //
        //        getAPIData(url: API_URL, parameters: params2)

            
    }
        
        
        func updateInfo(json: JSON) {
            
            var keys = [String]();
            
//            for key in json {
//                keys.append(key);
//            }
    //        label.text = json["officials"][0]["channels"][1]["id"].stringValue
//            if keys[0] == "errors" {
                repNameLabel.isHidden = false
                occupationLabel.isHidden = false
                politicalPartyLabel.isHidden = false
                emailLabel.isHidden = false
                phoneNumberLabel.isHidden = false
                imageView.isHidden = false
                // // // // //
                repNameLabel.text = json["officials"][0]["name"].stringValue
                occupationLabel.text = json["offices"][0]["name"].stringValue
                politicalPartyLabel.text = json["officials"][0]["party"].stringValue
                emailLabel.text = json["officials"][0]["emails"][0].stringValue
                phoneNumberLabel.text = json["officials"][0]["phones"][0].stringValue
                
                setImage(from: json["officials"][0]["photoUrl"].stringValue)
//            } else {
//                let alert = UIAlertController(title: "Invalid Address", message: "Please enter a full, valid address before continuing", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "okay, let me fix it!", style: .default, handler: nil))
//                self.present(alert, animated: true)
//            }
            
        }
    
    func setImage(from url: String) {
        let http = URL(string: url)!
        var comps = URLComponents(url: http, resolvingAgainstBaseURL: false)!
        comps.scheme = "https"
        let https = comps.url!
        let imageURL = https

            // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
    
}

