//
//  SettingsViewController.swift
//  techtogether
//
//  Created by Sofia Ongele on 2/1/20.
//  Copyright © 2020 Sofia Ongele. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    
    var name = ""
    var occupation = ""
    var accountType = ""
    
    @IBOutlet weak var editInfoButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var occupationLabel: UILabel!

    
    
    override func viewDidLoad() {
           super.viewDidLoad()
                
        occupationLabel.isHidden = false
        
        let userID = Auth.auth().currentUser?.uid
        let userRef = Database.database().reference().child("users").child(userID!).child("personalInfo")
        
        userRef.observe(.value, with: { (snapshot) in
        
            let snapshotValue = snapshot.value as? [String: String] ?? [:]
        
            if snapshotValue["name"] != nil {
                self.nameLabel.text = "Hello " + String(snapshotValue["name"]! + "!")
                self.accountType = "primaryUser"
                print(self.name)
                if snapshotValue["occupation"] != nil && snapshotValue["occupation"] != ""{
                    self.occupationLabel.text = String(snapshotValue["occupation"]!)
                }
                else {
                    self.occupationLabel.isHidden = true
                }

            }
            
        })
        let assistingUserRef = Database.database().reference().child("assistingUsers").child(userID!).child("personalInfo")
                   
                   assistingUserRef.observe(.value) { (snapshot) in
                       let snapshotValue = snapshot.value as? [String: String] ?? [:]
                       
                       if snapshotValue["name"] != nil {
                           self.name = "Hello, " + String(snapshotValue["name"]! + "!")
                           self.accountType = "assistingUser"
                           self.occupationLabel.text = "Occupation: " + String(snapshotValue["helpingOccupation"]!)
                       }
                       else {
                           //an error has occurred
                       }
                   }
        
        
    }

    
  
    
    @IBAction func logOut(_ sender: Any) {
        do {
               try Auth.auth().signOut()
           }
        catch let signOutError as NSError {
               print ("Error signing out: %@", signOutError)
           }
           
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           let initial = storyboard.instantiateInitialViewController()
           UIApplication.shared.keyWindow?.rootViewController = initial
    }

}
