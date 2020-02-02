//
//  AddEventController.swift
//  techtogether
//
//  Created by Sofia Ongele on 2/1/20.
//  Copyright © 2020 Sofia Ongele. All rights reserved.
//

import Foundation
import Firebase


class AddEventController: UIViewController {
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var descriptionTextField: UITextView!
    
    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = false
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func addEventPressed(_ sender: UIButton) {
        
        let userID = Auth.auth().currentUser?.uid
            //finds the user's name, used to confirm existence of user, no null value
            let infoReference = Database.database().reference().child("users").child(userID!).child("personalInfo")
            
            let globalReportsReference = Database.database().reference().child("reports")
            
            let localReportsReference = Database.database().reference().child("users").child(userID!).child("reports")
            
            infoReference.observe(.value) { (snapshot) in
                //snapshot should be formatted
                let snapshot = snapshot.value as? [String : String] ?? [:]
                var nameOfMainUser = ""
                
                if snapshot["name"] != nil {
                    nameOfMainUser = String(snapshot["name"]!)
                }
                else {
                    nameOfMainUser = "Error loading name"
                }
                
                
                let localReportsIDReference = localReportsReference.childByAutoId()
                let randomIDKey = String(localReportsIDReference.key!)
                
                //this is the main information saved to both the user's local reference, and then globally
                let reportDictionary = ["mainUser": nameOfMainUser, "nameInNeed": self.nameTextField.text!, "location": self.locationTextField.text!, "description": self.descriptionTextField.text!, "senderID": userID, "reportID": randomIDKey]
                
                
                localReportsIDReference.setValue(reportDictionary) {
                    (error, reference) in
                    
                    if error != nil {
                        print(error!)
                    }
                    else {
                        print("Event saved successfully to local ref.")
                    }
                }
                globalReportsReference.child(randomIDKey).child("reportInfo").setValue(reportDictionary) {
                    (error, reference) in
                    if error != nil {
                        print(error!)
                    }
                    else {
                        print("Event saved successfully to global ref.")
                    }
                }
            }
            self.navigationController?.isNavigationBarHidden = true
            let _ = navigationController?.popViewController(animated: true)

        } 
    
}
