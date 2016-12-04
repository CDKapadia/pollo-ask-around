//
//  PollTableAndViewController.swift
//  Pollo Ask Around
//
//  Created by Chiraag Kapadia on 11/19/16.
//  Copyright © 2016 CAKK. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PollTableAndViewController: UIViewController, UITableViewDataSource, CLLocationManagerDelegate, UITableViewDelegate, MKMapViewDelegate {
    @IBOutlet weak var pollsTableView: UITableView!
    
    @IBOutlet weak var mapOnPollsView: MKMapView!

    var myArray: [String] = []
    //var saveJson: JSON = [:]
    var locationManager = CLLocationManager()
    var latitude: String = ""
    var longitude: String = ""
    var ids: [String:String] = [:]
    var lats: [String:CLLocationDegrees] = [:]
    var longs: [String:CLLocationDegrees] = [:]

    var hasLoaded = false
    var refreshControl = UIRefreshControl()
    /*
    var pinAnnotation: MKPointAnnotation!
    var pinAnnotationView: MKPinAnnotationView!
 */

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapOnPollsView.delegate = self
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        self.pollsTableView.addSubview(refreshControl)
        
        //sets datasource for tableview and waits for api call before showing table
        pollsTableView.dataSource = self
        
        //disable user interaction with map
        self.mapOnPollsView.isZoomEnabled = false
        self.mapOnPollsView.isScrollEnabled = false
        self.mapOnPollsView.isUserInteractionEnabled = false
        
        //request for authorization
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        //start updating location once authorized
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        //get users uuid
        //let uuid = "presentation"
        let uuid = UIDevice.current.identifierForVendor!.uuidString
        
        //makes request for user with uuid of user does nothing if user exists creates if doesnt
        var request = URLRequest(url: URL(string: ("http://52.43.103.143:3456/users/"+uuid))!)
        request.httpMethod = "GET"
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
            if (response != nil){
            self.connection(didReceiveResponse: response!, id: uuid)
            }
            else{
                print ("response is nil")
            }
        })
        task.resume()
    }
    //refreshes table whenever user sees page again
    override func viewDidAppear(_ animated: Bool) {
        populateTableView()
    }
   
    //refresh function used by refreshcontroller for pull down to refresh
    func refresh(sender:AnyObject) {
        populateTableView()
        refreshControl.endRefreshing()
    }
 
    //makes request to api and populates tableview
    func populateTableView(){
        var request2 = URLRequest(url: URL(string: ("http://52.43.103.143:3456/posts/@"+self.latitude+","+self.longitude))!)
        request2.httpMethod = "GET"
        let config2 = URLSessionConfiguration.default
        let session2 = URLSession(configuration: config2)
        let task2 = session2.dataTask(with: request2, completionHandler: {(data, response, error) in
            if(data != nil){
                let jsonResult: JSON = JSON(data: data!)
                var temp: [String] = []
                for (id,dict) in jsonResult{
                    let question = String(dict["q"].stringValue)
                    temp.append(question!) //add question to table
                    self.ids[question!] = id //keeps track of id and question in dictionary
                    self.lats[question!] = CLLocationDegrees(dict["lat"].doubleValue)
                    self.longs[question!] = CLLocationDegrees(dict["lng"].doubleValue)
                }
                DispatchQueue.main.async {
                    self.myArray = temp
                    self.pollsTableView.reloadData() //loads table view
                }
            }
        })
        task2.resume()
    }
    //centers map on current location and populates tableview with questions
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        self.latitude = String(locValue.latitude)
        self.longitude = String(locValue.longitude)
        let currentLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        centerMapOnLocation(location: currentLocation)
        /*
        self.pinAnnotation = MKPointAnnotation()
        let coordinates: CLLocationCoordinate2D = CLLocationCoordinate2DMake(locValue.latitude, locValue.longitude)
        self.pinAnnotation.coordinate = coordinates
        
        self.pinAnnotationView = MKPinAnnotationView(annotation: self.pinAnnotation, reuseIdentifier: "pin")
        self.mapOnPollsView.addAnnotation(self.pinAnnotationView.annotation!)
        */
        if (self.hasLoaded == false){
        populateTableView()
        self.hasLoaded = true
        }
    }
    
    //called when first request is made for user and creates user in database if user is not found
    func connection(didReceiveResponse response: URLResponse!, id: String) {
        if let httpResponse = response as? HTTPURLResponse {
            //print(httpResponse.statusCode)
            if (httpResponse.statusCode == 404){
                createUser(ID: id)
            }
        } else {
            assertionFailure("unexpected response")
        }
    }
    
    //does the creating of user by sending post to server
    func createUser(ID: String){
        var request = URLRequest(url: URL(string: "http://52.43.103.143:3456/users")!)
        request.httpMethod = "POST"
        let postString = "uuid="+ID
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
        }
        task.resume()
    }
    
    //actual function for centering map
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapOnPollsView.setRegion(coordinateRegion, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myCell = tableView.dequeueReusableCell(withIdentifier: "theCell")! as! PollTableCell
        myCell.textLabel!.numberOfLines = 3
        myCell.textLabel!.lineBreakMode = .byWordWrapping
        myCell.textLabel!.text = myArray[indexPath.row]
        
        myCell.pollName = myArray[indexPath.row]
        
        return myCell
        
    }
    
    var currentIndexPath: IndexPath?
       override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: custom annotation
    /*
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(named: "pin.png")
        
        
        return annotationView
    }
 */
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        //we can make a custom class for each poll to store data. Or do another request.
        //this will allow us to pass the poll info to the next screen for another request.
        
        if let nextController = segue.destination as? VotesViewController{
            //If going to a CURRENT POLL
            let theSender = sender as! PollTableCell
            nextController.pollId = ids[theSender.pollName]!
            nextController.pollQuestion = theSender.pollName
            //nextController.pollTitle = ids[myArray[3]]!
            nextController.pollTitle = theSender.pollName
            nextController.latitude = lats[theSender.pollName]!
            nextController.longitude = longs[theSender.pollName]!
        }
        else{
            //IF going make a new poll. The plus sign
            //do nothing right now.
        }

        
    }
    

}
