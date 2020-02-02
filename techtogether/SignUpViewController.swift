//
//  SignUpViewController.swift
//  techtogether
//
//  Created by Sofia Ongele on 2/1/20.
//  Copyright © 2020 Sofia Ongele. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SignUpViewController: UIViewController {


    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Aurora.png")!)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: confirmPasswordTextField.text!) { (user, error) in
            
            if error != nil {
                print(error!)
                
            }
            else {
                //success
                print("Registration Successful")
                
                let userID = Auth.auth().currentUser?.uid
                var ref : DatabaseReference!
                ref = Database.database().reference().child("users").child(userID!).child("personalInfo")
                let infoDict : [String : Any] = ["name" : self.fullNameTextField.text!, "occupation" : "", "personalDescription" : ""]
                ref.setValue(infoDict)
                
                self.performSegue(withIdentifier: "goToHome", sender: self)
                
            }
            
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
