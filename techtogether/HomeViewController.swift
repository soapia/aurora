//
//  HomeViewController.swift
//  techtogether
//
//  Created by Sofia Ongele on 2/1/20.
//  Copyright © 2020 Sofia Ongele. All rights reserved.
//

import UIKit
import MapKit

class customPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(pinTitle:String, pinSubTitle:String, location: CLLocationCoordinate2D) {
        self.title = pinTitle
        self.subtitle = pinSubTitle
        self.coordinate = location
    }
}

class HomeViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    
    let data = DataStore().locations
//    var locData: [[String : Any]] = []
    var mapAnnotations = [customPin]()
    var imageChoice = "pin"
    
    
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var locationTitle: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func zoomLocation(_ sender: Any) {
        if CLLocationManager.locationServicesEnabled() == true {
            
            if CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied ||  CLLocationManager.authorizationStatus() == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
            }
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            let noLocation = CLLocationCoordinate2D()
            let viewRegion = MKCoordinateRegion(center: noLocation, latitudinalMeters: 200, longitudinalMeters: 200)
            mapView.setRegion(viewRegion, animated: false)
            mapView.showsUserLocation = true
        } else {
            print("PLease turn on location services or GPS")
        }
        
    }
    func addPlaces() {
        //self.mapView.removeAnnotations(mapAnnotations)
        //mapAnnotations.removeAll()
        for dictionary in data {
            // print(dictionary)
            let latitude = CLLocationDegrees(dictionary["latitude"] as! Double)
            let longitude = CLLocationDegrees(dictionary["longitude"] as! Double)
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let name = dictionary["name"] as! String
            // let mediaURL = dictionary["mediaURL"] as! String
            let pin = customPin(pinTitle: name, pinSubTitle: "", location: coordinate)
            //print(pin)
            mapAnnotations.append(pin)
            //print("LOOOOOOOOOK")
            self.mapView.addAnnotation(pin)
        }
        // print(mapAnnotations)
        self.mapView.addAnnotations(mapAnnotations)
        imageChoice = "pin"
    }
    var pinSelected = false
    var phoneNum = ""
    var mapUp = ""
    var learnMore = ""
    var coordinateArray = [Double]()
    
    @IBAction func learnMore(_ sender: Any) {
        if pinSelected == true {
            let alertPrompt = UIAlertController(title: "leave the app?", message: "open safari to learn more about \(locationTitle.text!)", preferredStyle: .actionSheet)
            let confirmAction = UIAlertAction(title: "okay, i'm ready", style: UIAlertAction.Style.default, handler: { (action) -> Void in
                
                if let url = URL(string: self.learnMore) {
                    UIApplication.shared.open(url, options: [:])
                }
            })
            
            let cancelAction = UIAlertAction(title: "nevermind", style: UIAlertAction.Style.cancel, handler: nil)
            
            alertPrompt.addAction(confirmAction)
            alertPrompt.addAction(cancelAction)
            
            present(alertPrompt, animated: true, completion: nil)
        } else {
            nothingSelected()
        }
    }
    @IBAction func callUs(_ sender: Any) {
        if pinSelected == true {
            makeACall(phoneNumber: phoneNum, nameOfService: locationTitle.text!)
        } else {
            nothingSelected()
        }
    }
    @IBAction func getDirections(_ sender: Any) {
        if pinSelected == true {
            // print("i was selected")
            var myArray = coordinateArray
            print(myArray)
            let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(myArray[0] as! Double) , longitude: CLLocationDegrees(myArray[1] as! Double))
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
            mapItem.name = locationTitle.text!
            // mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
            let alertPrompt = UIAlertController(title: "open maps", message: "you're going to get directions to \(locationTitle.text!)", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "okay, i'm ready", style: UIAlertAction.Style.default, handler: { (action) -> Void in
                
                mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
            })
            
            let cancelAction = UIAlertAction(title: "nevermind", style: UIAlertAction.Style.cancel, handler: nil)
            
            alertPrompt.addAction(confirmAction)
            alertPrompt.addAction(cancelAction)
            
            present(alertPrompt, animated: true, completion: nil)
        } else {
            nothingSelected()
        }
    }
    func getCoordinate(name: String) -> Array<Any> {
        var arr = [Double]()
        for dict in data {
            if dict["name"] as? String == name {
                arr = [dict["latitude"], dict["longitude"]] as! [Double]
            }
        }
        return arr
    }
    func getLink(name: String) -> String {
        var lin = ""
        for dict in data {
            if dict["name"] as? String == name {
                lin = dict["mediaURL"] as! String
            }
        }
        return lin
    }
    func getPhone(name: String) -> String {
        var num = ""
        for dict in data {
            if dict["name"] as? String == name {
                num = dict["phoneNumber"] as! String
            }
        }
        return num
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        mapView.layer.cornerRadius = 7.5
        mapView.showsUserLocation = true
        if CLLocationManager.locationServicesEnabled() == true {
            
            if CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied ||  CLLocationManager.authorizationStatus() == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
            }
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        } else {
            print("Please turn on location services or GPS")
            
        }
        self.mapView.delegate = self
        
//        let noLocation = CLLocationCoordinate2D()
//        let viewRegion = MKCoordinateRegion(center: noLocation, latitudinalMeters: 200, longitudinalMeters: 200)
//        mapView.setRegion(viewRegion, animated: false)
        
        mapView.showsUserLocation = true
        addPlaces()
        // Do any additional setup after loading the view.
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let place = view.annotation?.title!
        // view.annotation?.title!.lines
        print("annotation title == \(place!)")
        if place != "My Location" {
            pinSelected = true
            phoneNum = getPhone(name: place!)
            learnMore = getLink(name: place!)
            locationTitle.text = place!
            coordinateArray = getCoordinate(name: place!) as! [Double]
            // getTheThings(name: place!)
        }
        print(phoneNum + " " + learnMore + " \(coordinateArray)")
        // phoneNumber =
    }
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        pinSelected = false
        phoneNum = ""
        learnMore = ""
        coordinateArray.removeAll()
        print("I was deselected!")
        locationTitle.text = "Organizations Providing Assistance"
    }
    
    //MARK:- CLLocationManager Delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        self.mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Unable to access your current location")
    }
    
    func makeACall(phoneNumber: String, nameOfService: String) {
        let alertPrompt = UIAlertController(title: "make a call", message: "you're going to call \(nameOfService)", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "okay, i'm ready", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            
            if let url = URL(string: "tel://\(phoneNumber)") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: "nevermind", style: UIAlertAction.Style.cancel, handler: nil)
        
        alertPrompt.addAction(confirmAction)
        alertPrompt.addAction(cancelAction)
        
        present(alertPrompt, animated: true, completion: nil)
    }
    func nothingSelected() {
        let alertPrompt = UIAlertController(title: "oops!", message: "you didn't tap a pin", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "sorry pal", style: UIAlertAction.Style.cancel, handler: nil)
        
        alertPrompt.addAction(confirmAction)
        
        present(alertPrompt, animated: true, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }
    //        let rightButton = UIButton(type: .contactAdd)
    //        rightButton.tag = annotation.hash
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customannotation")
            annotationView.image = UIImage(named: imageChoice)
            annotationView.canShowCallout = true
            // annotationView.rightCalloutAccessoryView = rightButton
            return annotationView
        }
    
    override func viewDidAppear(_ animated: Bool) {
        if CLLocationManager.locationServicesEnabled() == true {
            
            if CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied ||  CLLocationManager.authorizationStatus() == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
            }
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        } else {
            print("Please turn on location services or GPS")
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
