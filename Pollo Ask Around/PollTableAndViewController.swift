//
//  PollTableAndViewController.swift
//  Pollo Ask Around
//
//  Created by Chiraag Kapadia on 11/19/16.
//  Copyright © 2016 CAKK. All rights reserved.
//

import UIKit
import MapKit
//import CoreLocation

class PollTableAndViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var pollsTableView: UITableView!
    
    @IBOutlet weak var mapOnPollsView: MKMapView!
    
    var myArray = ["Mary", "Jane", "MaryJane"]

    //var locManager: CLLocationManager!

    
    override func viewDidLoad() {
        super.viewDidLoad()
       // /user
    
        let uuid = UIDevice.current.identifierForVendor!.uuidString
        //let uuid = "1"
        var request = URLRequest(url: URL(string: ("http://52.43.103.143:3456/user/"+uuid))!)
        request.httpMethod = "GET"
        let queue:OperationQueue = OperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{ (response: URLResponse?, data: Data?, error: Error?) -> Void in
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? Dictionary<String,AnyObject> {
                    print("ASynchronous\(jsonResult)")
                    if ((jsonResult["error"]) != nil){
                        self.createUser(ID: uuid)
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
            
        })
        var request2 = URLRequest(url: URL(string: ("http://52.43.103.143:3456/user/"+uuid+"/post"))!)
        request2.httpMethod = "GET"
        let queue2:OperationQueue = OperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(request2, queue: queue2, completionHandler:{ (response: URLResponse?, data: Data?, error: Error?) -> Void in
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? Dictionary<String,AnyObject> {
                    print("ASynchronous\(jsonResult)")
                    //for key in jsonResult{
                        //let stringKey = String(describing: key)
                      //  let dict = jsonResult[stringKey]
                        //let post = dict?["q"] as! String
                        //self.myArray.append(post)
                    //}
                    //self.pollsTableView.dataSource = self
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
            
        })
    
        //     let locManager = CLLocationManager()
        //locManager.requestAlwaysAuthorization()
        //locManager.delegate = self
        
    //    locManager.requestAlwaysAuthorization()
    //    locManager.requestWhenInUseAuthorization()
        var currentLocation: CLLocation!
        currentLocation = CLLocation(latitude: 38.648114, longitude: -90.311554)
        //        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
          //          CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            //        currentLocation = locManager.location
              //      centerMapOnLocation(location: currentLocation)
        
                //}
        centerMapOnLocation(location: currentLocation)
        //pollsTableView.dataSource = self
        print("I am here")
        // Do any additional setup after loading the view.
    }
    
    //private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
     //   switch status {
    //    case .notDetermined:
  //          print("A")
            // If status has not yet been determied, ask for authorization
    //        manager.requestAlwaysAuthorization()
    //        break
    //    case .authorizedWhenInUse:
            // If authorized when in use
    //        print("B")
//manager.startUpdatingLocation()
     //       var currentLocation: CLLocation!
     //       currentLocation = manager.location
     //       centerMapOnLocation(location: currentLocation)
    //        break
   //     case .authorizedAlways:
    //        print("C")
            // If always authorized
   //         manager.startUpdatingLocation()
//var currentLocation: CLLocation!
   //         currentLocation = manager.location
    //        centerMapOnLocation(location: currentLocation)
//break
   //     case .restricted:
   //         print("D")
            // If restricted by e.g. parental controls. User can't enable Location Services
//
//        case .denied:
  //          // If user denied your app access to Location Services, but can grant access from Settings.app
            
  //          break
   //     }
    //}
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
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
    func createUser(ID: String){
        var request = URLRequest(url: URL(string: "http://52.43.103.143:3456/user")!)
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
