//
//  AssistanceRegisterController.swift
//  techtogether
//
//  Created by Sofia Ongele on 2/1/20.
//  Copyright © 2020 Sofia Ongele. All rights reserved.
//

import Foundation
import Firebase

class AssistanceRegisterController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var occupationTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Aurora.png")!)
        hideKeyboardWhenTappedAround()

    }
    
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
         Auth.auth().createUser(withEmail: emailTextField.text!, password: confirmPasswordTextField.text!) { (user, error) in
                    
                    if error != nil {
                        print(error!)
                        
                    }
                    else {
                        //success
                        print("Registration Successful")
                        
                        let userID = Auth.auth().currentUser?.uid
                        var ref : DatabaseReference!
                        ref = Database.database().reference().child("assistingUsers").child(userID!).child("personalInfo")
                        let infoDict : [String : Any] = ["name" : self.nameTextField.text!, "helpingOccupation" : self.occupationTextField.text!, "personalDescription" : ""]
                        ref.setValue(infoDict)
                        
                        self.performSegue(withIdentifier: "goToAssistanceHome", sender: self)
                    }
                    
                }
        




        
    }
    
}
