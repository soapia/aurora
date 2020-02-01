//
//  LoginViewController.swift
//  techtogether
//
//  Created by Sofia Ongele on 2/1/20.
//  Copyright © 2020 Sofia Ongele. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        //TODO: Login the user
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            if error != nil {
                print(error!)
                
                let alert = UIAlertController(title: "Please Try Again", message: "Incorrect email or password.", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Okay", style: .cancel) { (action) in
                    print("Okay Pressed")
                }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
                
            }
            else {
                

                let userID = Auth.auth().currentUser?.uid
                let ref = Database.database().reference().child("users").child(userID!).child("personalInfo")
                
                ref.observe(.value) { (snapshot) in
                    let snapshotThing = snapshot.value as? [String : String] ?? [:]
                    if snapshotThing["name"] != nil {
                        print("Login Successful")
                        self.performSegue(withIdentifier: "goToHome", sender: self)
                    }
                    else {
                        print("This user exists, except they are not a volunteer.")
                    }
                }
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

// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
