//
//  EventsController.swift
//  techtogether
//
//  Created by Sofia Ongele on 2/1/20.
//  Copyright © 2020 Sofia Ongele. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class EventsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var reportArray : [Report] = [Report]()
    var isTableEmpty : Bool = false
    var name = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {

        self.navigationController?.isNavigationBarHidden = true
        
        retrieveEvents()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "customTableViewCell")
        print(reportArray.count)

//        let userID = Auth.auth().currentUser?.uid
//                let userRef = Database.database().reference().child("users").child(userID!).child("personalInfo")
//
//                userRef.observe(.value, with: { (snapshot) in
//
//                    let snapshotValue = snapshot.value as? [String: String] ?? [:]
//
//                    if snapshotValue["name"] != nil {
//                        self.name = String(snapshotValue["name"]!)
//                        print(self.name)
//                    }
//                    else {
//                        print("Oops, something's wrong")
//                    }
//                })
        
        tableView.reloadData()
        hideKeyboardWhenTappedAround()

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return reportArray.count

               if reportArray.count == 0 {
                   isTableEmpty = true
                   return 1
               }
               else {
                   isTableEmpty = false
                   return reportArray.count
               }
           }
    
           
           func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
               
               let cell = tableView.dequeueReusableCell(withIdentifier: "customTableViewCell", for: indexPath) as! CustomTableViewCell
               
            if reportArray.count == 0 {
                   cell.nameInNeedLabel.text = "No reports logged at the moment."
                   cell.locationLabel.isHidden = true
                   cell.descriptionLabel.text = "Click the button above to log a call for help."
               }
               else {
                   cell.locationLabel.isHidden = false
                    cell.nameInNeedLabel.isHidden = false
                    cell.descriptionLabel.isHidden = false
                   
                   let report = reportArray[indexPath.row]
                   
//                   let reportRef = Database.database().reference().child("reports").child(report.reportID).child("CommittedUsers")
                   
    //               reportRef.observeSingleEvent(of: .value) { (snapshot) in
    //                   print("Children count: \(snapshot.childrenCount)")
    //                   cell.interestedVolunteersNumber.text = String(snapshot.childrenCount)
    //               }
                   
                   
                cell.nameInNeedLabel.text = report.nameInNeed
                print(report.nameInNeed)
                cell.locationLabel.text = report.location
                cell.descriptionLabel.text = report.description
                   
                   let colorArray = ["Purple", "Blue", "Yellow", "Orange", "Pink"]
                   let colorNumber = indexPath.row % 5
    
                   if colorArray[colorNumber] == "Purple" {
                       cell.backgroundColor = UIColor(red:0.88, green:0.81, blue:0.95, alpha:1.0)
                   }
                   else if colorArray[colorNumber] == "Blue" {
                       cell.backgroundColor = UIColor(red:0.84, green:0.84, blue:0.95, alpha:1.0)
                   }
                   else if colorArray[colorNumber] == "Yellow" {
                       cell.backgroundColor = UIColor(red:0.95, green:0.89, blue:0.70, alpha:1.0)
                   }
                   else if colorArray[colorNumber] == "Orange" {
                       cell.backgroundColor = UIColor(red:0.95, green:0.80, blue:0.67, alpha:1.0)
                   }
                   else {
                       cell.backgroundColor = UIColor(red:0.95, green:0.76, blue:0.71, alpha:1.0)
                   }
               }
               return cell
           }
        
    
    func retrieveEvents() {
        
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users").child(userID!).child("reports")
        
        ref.observe(.childAdded) { (snapshot) in
            
            let snapshotValue = snapshot.value as? [String: String] ?? [:]
            
            if snapshotValue["mainUser"] != nil {
                
                let mainUser = String(snapshotValue["mainUser"]!)
                let description = String(snapshotValue["description"]!)
                let location = String(snapshotValue["location"]!)
                let reportID = String(snapshotValue["reportID"]!)
                let senderID = String(snapshotValue["senderID"]!)
                
            
                let report = Report()
                report.mainUser = mainUser
                report.description = description
                report.location = location
                report.reportID = reportID
                report.senderID = senderID

                self.reportArray.append(report)
                self.tableView.reloadData()
            }
            else {
                print("Something isn't working")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        retrieveEvents()
        tableView.reloadData()
    }
    
}
