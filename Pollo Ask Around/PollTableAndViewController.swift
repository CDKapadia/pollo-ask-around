//
//  PollTableAndViewController.swift
//  Pollo Ask Around
//
//  Created by Chiraag Kapadia on 11/19/16.
//  Copyright © 2016 CAKK. All rights reserved.
//

import UIKit
import MapKit

class PollTableAndViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var pollsTableView: UITableView!
    
    @IBOutlet weak var mapOnPollsView: MKMapView!
    
    var myArray = ["Mary", "Jane", "Billy"]

    override func viewDidLoad() {
        super.viewDidLoad()
    
        //let locManager = CLLocationManager()
        //locManager.requestAlwaysAuthorization()
        //locManager.requestWhenInUseAuthorization()
        var currentLocation: CLLocation!
        currentLocation = CLLocation(latitude: 38.648114, longitude: -90.311554)
        //        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
        //            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
        //            currentLocation = locManager.location
        //            centerMapOnLocation(location: currentLocation)
        //            
        //        }
        centerMapOnLocation(location: currentLocation)
        pollsTableView.dataSource = self
        print("I am here")
        // Do any additional setup after loading the view.
    }
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapOnPollsView.setRegion(coordinateRegion, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("in cellForRow at \(indexPath)")
        let myCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        myCell.textLabel!.text = myArray[indexPath.row]
        
        return myCell
        
    }


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
