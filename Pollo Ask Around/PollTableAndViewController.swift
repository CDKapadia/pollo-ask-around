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

class PollTableAndViewController: UIViewController, UITableViewDataSource, CLLocationManagerDelegate, UITableViewDelegate {
    @IBOutlet weak var pollsTableView: UITableView!
    
    @IBOutlet weak var mapOnPollsView: MKMapView!

    var myArray = [String]()
    var saveJson: JSON = [:]
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //sets datasource for tableview and waits for api call before showing table
        pollsTableView.dataSource = self
        //pollsTableView.isHidden = true
        
        //disable user interaction with map
        self.mapOnPollsView.isZoomEnabled = false;
        self.mapOnPollsView.isScrollEnabled = false;
        self.mapOnPollsView.isUserInteractionEnabled = false;
        
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
        let uuid = "presentation"
        //let uuid = UIDevice.current.identifierForVendor!.uuidString
        
        //makes request for user with uuid of user does nothing if user exists creates if doesnt
        var request = URLRequest(url: URL(string: ("http://52.43.103.143:3456/users/"+uuid))!)
        request.httpMethod = "GET"
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
            self.connection(didReceiveResponse: response!, id: uuid)
        })
        task.resume()
 
        //makes request for posts by user, adds them to array, then updates and shows tableview
        var request2 = URLRequest(url: URL(string: ("http://52.43.103.143:3456/users/"+uuid+"/posts"))!)
        request2.httpMethod = "GET"
        let config2 = URLSessionConfiguration.default
        let session2 = URLSession(configuration: config2)
        let task2 = session2.dataTask(with: request2, completionHandler: {(data, response, error) in
            if(data != nil){
                let jsonResult: JSON = JSON(data: data!)
                self.saveJson = jsonResult
                //print(jsonResult)
                let numberPosts = jsonResult.count
                var i = 0
                while(i < numberPosts){
                    let istring = String(i)
                    self.myArray.append(jsonResult[istring]["q"].stringValue)
                    i += 1
                }
                //self.pollsTableView.isHidden = false;
                self.pollsTableView.reloadData()
                
                //print(self.saveJson)
            }
        })
        task2.resume() 
    }
    
    //centers map on current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        let currentLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        centerMapOnLocation(location: currentLocation)
        /* do we want a pin???
        let pin = MKPointAnnotation()
        let coordinates: CLLocationCoordinate2D = CLLocationCoordinate2DMake(locValue.latitude, locValue.longitude)
        pin.coordinate = coordinates
        self.mapOnPollsView.addAnnotation(pin)
        */
    }
    
    //called when first request is made for user and creates user in database if user is not found
    func connection(didReceiveResponse response: URLResponse!, id: String) {
        if let httpResponse = response as? HTTPURLResponse {
            print(httpResponse.statusCode)
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
        
        //print("in cellForRow at \(indexPath)")
        let myCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        myCell.textLabel!.text = myArray[indexPath.row]
        
        return myCell
        
    }
    var currentIndexPath: IndexPath?
   /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        currentIndexPath = indexPath
        self.performSegue(withIdentifier: "ShowVotes", sender: nil)
    }
  /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowVotes" {
            if let destination = segue.destination as? VotesViewController {
                destination.test = myArray[currentIndexPath!.row]
            }
        }
}
 */

  /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowVotes", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowVotes" {
            if let destination = segue.destination as? VotesViewController{
            destination.test = myArray[currentIndexPath!.row]
            }
        }
    }
 

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = pollsTableView.indexPathForSelectedRow{
            let selectedRow = indexPath.row
            let detailVC = segue.destination as! VotesViewController
            detailVC.test = myArray[selectedRow]
        }
    }
*/*/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
