//
//  AssistanceHomeViewController.swift
//  techtogether
//
//  Created by Sofia Ongele on 2/2/20.
//  Copyright © 2020 Sofia Ongele. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class AssistanceHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var reportArray : [Report] = [Report]()
    var isTableEmpty : Bool = true
    var name : String = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "customTableViewCell")
        let userID = Auth.auth().currentUser?.uid
        let userRef = Database.database().reference().child("assistingUsers").child(userID!).child("personalInfo")
        
        userRef.observe(.value, with: { (snapshot) in
            
            let snapshotValue = snapshot.value as? [String: String] ?? [:]
            
            if snapshotValue["name"] != nil {
                self.name = String(snapshotValue["name"]!)
                print(self.name)
            }
            else {
                print("Oops, something's wrong")
            }
        })
        
        retrieveEvents()
        hideKeyboardWhenTappedAround()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
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
        
        if isTableEmpty == true {
            
            cell.nameInNeedLabel.text = "No Current Opportunities"
            cell.locationLabel.isHidden = true
            cell.descriptionLabel.text = "Please check back later!"
            
        }
        else {
            
            cell.nameInNeedLabel.isHidden = false
            cell.locationLabel.isHidden = false
            cell.descriptionLabel.isHidden = false
            
            let report = reportArray[indexPath.row]
            
            cell.nameInNeedLabel.text = report.nameInNeed
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if isTableEmpty == true {
            //do nothing
        }
        else {
            let selectedCell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
            if selectedCell.descriptionLabel.text == "SELECTED" {
                //do nothing
            }
            else {
                //TODO: Sign-up for the opportunity selected
                let alert = UIAlertController(title: "Case Selected", message: "You have selected this case to assist, would you like to continue?", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Commit to case", style: .default) { (action) in
                    
                    selectedCell.descriptionLabel.text = "SELECTED"
                    
                    let userID = Auth.auth().currentUser?.uid
                    let ref = Database.database().reference().child("assistingUsers").child(userID!).child("SelectedEvents")
                    let selectedEvent = self.reportArray[indexPath.row]
                    let reportDictionary = ["nameInNeed": selectedEvent.nameInNeed, "location": selectedEvent.location, "description": selectedEvent.description, "reportID": selectedEvent.reportID, "senderID": selectedEvent.senderID]
                    
                    ref.childByAutoId().setValue(reportDictionary) {
                        (error, reference) in
                        if error != nil {
                            print(error!)
                        }
                        else {
                            print("Report saved successfully.")
                        }
                    }
                    
                    let addRef = Database.database().reference().child("reports").child(selectedEvent.reportID).child("CommittedUser")
                    
                    
                    let alertUserDictionary = ["AssistingName": self.name, "senderID": userID]
                    
                    addRef.child(self.name).setValue(alertUserDictionary) {
                        (error, reference) in
                        if error != nil {
                            print(error!)
                        }
                        else {
                            print("Saved committed report successfully")
                        }
                    }
                    
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                    print("Cancel Pressed")
                }
                alert.addAction(action)
                alert.addAction(cancelAction)
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    func retrieveEvents() {
        
        let ref = Database.database().reference().child("reports")
        
        ref.observe(.childAdded) { (snapshot) in
            
            let snapshotValue = snapshot.childSnapshot(forPath: "reportInfo")
            
            if snapshotValue.childSnapshot(forPath: "mainUser").value != nil {
                
                let mainUser = "\(snapshotValue.childSnapshot(forPath: "mainUser").value ?? "")"
                let location = "\(snapshotValue.childSnapshot(forPath: "location").value ?? "")"
                let description = "\(snapshotValue.childSnapshot(forPath: "description").value ?? "")"
                let reportID = "\(snapshotValue.childSnapshot(forPath: "reportID").value ?? "")"
                let senderID = "\(snapshotValue.childSnapshot(forPath: "senderID").value ?? "")"
               let nameInNeed = "\(snapshotValue.childSnapshot(forPath: "nameInNeed").value ?? "")"

                
                
                let report = Report()
                report.mainUser = mainUser
                report.location = location
                report.description = description
                report.reportID = reportID
                report.senderID = senderID
                report.nameInNeed = nameInNeed
                self.reportArray.append(report)
                self.tableView.reloadData()
            }
            else {
                print("Something isn't working")
            }
        }
        
    }

    

}
