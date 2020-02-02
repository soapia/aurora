//
//  ViewController.swift
//  techtogether
//
//  Created by Sofia Ongele on 2/1/20.
//  Copyright © 2020 Sofia Ongele. All rights reserved.
//

import UIKit
import Firebase

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Aurora.png")!)
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool){
     super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            var ref1 : DatabaseReference!
            ref1 = Database.database().reference()
            ref1.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.hasChild(Auth.auth().currentUser!.uid){
                    self.performSegue(withIdentifier: "alreadyLoggedIn", sender: nil)
                }
            })
            var ref2 : DatabaseReference!
            ref2 = Database.database().reference()
            ref2.child("assistingUsers").observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.hasChild(Auth.auth().currentUser!.uid){
                    self.performSegue(withIdentifier: "alreadyLoggedInAssist", sender: nil)
                }
            })
            // print(Auth.auth().currentUser?.uid)
        }
    }


}

