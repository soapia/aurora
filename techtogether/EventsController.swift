//
//  EventsController.swift
//  techtogether
//
//  Created by Sofia Ongele on 2/1/20.
//  Copyright © 2020 Sofia Ongele. All rights reserved.
//

import Foundation
import Firebase

class EventsController: UIViewController {
    
    var reportArray : [Report] = [Report]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        retrieveEvents()
        print(reportArray.count)

    }
    
    func retrieveEvents() {
        
        let ref = Database.database().reference().child("reports")
        
        ref.observe(.childAdded) { (snapshot) in
            
            let snapshotValue = snapshot.childSnapshot(forPath: "reportInfo")
            
            if snapshotValue.childSnapshot(forPath: "mainUser").value != nil {
                
                let report = Report()
                report.mainUser = "\(snapshotValue.childSnapshot(forPath: "mainUser").value ?? "")"
                report.description = "\(snapshotValue.childSnapshot(forPath: "description").value ?? "")"
                report.location = "\(snapshotValue.childSnapshot(forPath: "location").value ?? "")"
                report.reportID = "\(snapshotValue.childSnapshot(forPath: "eventID").value ?? "")"
                report.senderID = "\(snapshotValue.childSnapshot(forPath: "senderID").value ?? "")"
                
                self.reportArray.append(report)
                print(report.mainUser)
            }
            else {
                print("Something isn't working")
            }
        }
    }
    
}
