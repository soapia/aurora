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
//    var isTableEmpty : Bool = true
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {

        self.navigationController?.isNavigationBarHidden = true
        
        retrieveEvents()

        tableView.delegate = self
         tableView.dataSource = self
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "customTableViewCell")


        hideKeyboardWhenTappedAround()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            print(reportArray.count)
            return reportArray.count
            
    //           if reportArray.count == 0 {
    //               isTableEmpty = true
    //               return 1
    //           }
    //           else {
    //               isTableEmpty = false
    //               return reportArray.count
    //           }
           }
    
           
           func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
               
               let cell = tableView.dequeueReusableCell(withIdentifier: "customTableViewCell", for: indexPath) as! CustomTableViewCell
               
            if reportArray.count == 0 {
                   cell.nameInNeedLabel.text = "No reports logged at the moment."
                   cell.locationLabel.isHidden = true
                   cell.descriptionLabel.text = "Click the button above to log a call for help. The event will be sent out to those nearby who can come and assist you."
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
                cell.locationLabel.text = report.location
                cell.descriptionLabel.text = report.description
                   
    //               let colorArray = ["Purple", "Blue", "Yellow", "Orange", "Pink"]
    //               let colorNumber = indexPath.row % 5
    //
    //               if colorArray[colorNumber] == "Purple" {
    //                   cell.backgroundColor = UIColor(red:0.88, green:0.81, blue:0.95, alpha:1.0)
    //               }
    //               else if colorArray[colorNumber] == "Blue" {
    //                   cell.backgroundColor = UIColor(red:0.84, green:0.84, blue:0.95, alpha:1.0)
    //               }
    //               else if colorArray[colorNumber] == "Yellow" {
    //                   cell.backgroundColor = UIColor(red:0.95, green:0.89, blue:0.70, alpha:1.0)
    //               }
    //               else if colorArray[colorNumber] == "Orange" {
    //                   cell.backgroundColor = UIColor(red:0.95, green:0.80, blue:0.67, alpha:1.0)
    //               }
    //               else {
    //                   cell.backgroundColor = UIColor(red:0.95, green:0.76, blue:0.71, alpha:1.0)
    //               }
               }
               print(cell)
               return cell
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
                
                print(report)
                self.reportArray.append(report)
                // print(self.reportArray.count)
            }
            else {
                print("Something isn't working")
            }
        }
        self.tableView.reloadData()
        print("reloaded table")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        retrieveEvents()
    }
    
    
    
}
