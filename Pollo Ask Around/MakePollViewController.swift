//
//  MakePollViewController.swift
//  Pollo Ask Around
//
//  Created by Labuser on 11/19/16.
//  Copyright © 2016 CAKK. All rights reserved.
//

import UIKit
import CoreLocation

class MakePollViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var pollQuestion: UITextField!
    @IBOutlet weak var pollOption1: UITextField!
    @IBOutlet weak var pollOption2: UITextField!
    @IBOutlet weak var addOption3: UIButton!
    @IBOutlet weak var deleteOption3: UIButton!
    @IBOutlet weak var pollOption3: UITextField!
    @IBOutlet weak var addOption4: UIButton!
    @IBOutlet weak var deleteOption4: UIButton!
    @IBOutlet weak var pollOption4: UITextField!
    @IBOutlet weak var addOption5: UIButton!
    @IBOutlet weak var deleteOption5: UIButton!
    @IBOutlet weak var pollOption5: UITextField!
    @IBOutlet weak var addOption6: UIButton!
    @IBOutlet weak var deleteOption6: UIButton!
    @IBOutlet weak var pollOption6: UITextField!
    @IBOutlet weak var addOption7: UIButton!
    @IBOutlet weak var deleteOption7: UIButton!
    @IBOutlet weak var pollOption7: UITextField!
    @IBOutlet weak var addOption8: UIButton!
    @IBOutlet weak var deleteOption8: UIButton!
    @IBOutlet weak var pollOption8: UITextField!
    @IBOutlet weak var addOption9: UIButton!
    @IBOutlet weak var deleteOption9: UIButton!
    @IBOutlet weak var pollOption9: UITextField!
    @IBOutlet weak var addOption10: UIButton!
    @IBOutlet weak var deleteOption10: UIButton!
    @IBOutlet weak var pollOption10: UITextField!
    @IBOutlet var pollOptions: [UITextField]!
    
    var options = [String]()
    var locationManager = CLLocationManager()
    var latitude: CLLocationDegrees = 0.0
    var longitude: CLLocationDegrees = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addOption4.isHidden = true
        addOption5.isHidden = true
        addOption6.isHidden = true
        addOption7.isHidden = true
        addOption8.isHidden = true
        addOption9.isHidden = true
        addOption10.isHidden = true
        deleteOption3.isHidden = true
        deleteOption4.isHidden = true
        deleteOption5.isHidden = true
        deleteOption6.isHidden = true
        deleteOption7.isHidden = true
        deleteOption8.isHidden = true
        deleteOption9.isHidden = true
        deleteOption10.isHidden = true
        pollOption3.isHidden = true
        pollOption4.isHidden = true
        pollOption5.isHidden = true
        pollOption6.isHidden = true
        pollOption7.isHidden = true
        pollOption8.isHidden = true
        pollOption9.isHidden = true
        pollOption10.isHidden = true
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true,completion: nil)
    }
    
    @IBOutlet weak var pollPost: UIBarButtonItem!
    
    func checkOptions(){
        for textField in self.pollOptions{
            if textField.text != ""{
                options.append(textField.text!.replacingOccurrences(of: "'", with: "\\'", options: .literal, range: nil))
            }
        }
    }
    @IBAction func postAction(_ sender: UIBarButtonItem) {
        checkOptions()
        var optionsString = "&options=['"
        var index = 0
        while index < options.count - 1{
            let tempString = options[index] + "','"
            optionsString += tempString
            index += 1
        }
        optionsString = optionsString + options[options.count-1]+"']"
        if pollQuestion.text! != "" {
            let question = "q="+pollQuestion.text!.replacingOccurrences(of: "'", with: "\\'", options: .literal, range: nil)
            let lat = "&lat="+String(self.latitude)
            let long = "&lng="+String(self.longitude)
            let uuid = "&uuid="+UIDevice.current.identifierForVendor!.uuidString
            var request = URLRequest(url: URL(string: "http://52.43.103.143:3456/posts")!)
            request.httpMethod = "POST"
            let postString = question + lat + long + uuid + optionsString
            request.httpBody = postString.data(using: .utf8)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    // check for fundamental networking error
                    //print("error=\(error)")
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
            dismiss(animated: true, completion: nil)
        }
        else{
            let alertController = UIAlertController(title: "Alert", message:
                "Question field cannot be blank", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    @IBAction func option3Added(_ sender: Any) {
        pollOption3.isHidden = false
        addOption4.isHidden = false
        deleteOption3.isHidden = false
        addOption3.isHidden = true
    }
    @IBAction func option3Deleted(_ sender: Any) {
        pollOption3.isHidden = true
        pollOption3.text = nil
        addOption4.isHidden = true
        deleteOption3.isHidden = true
        addOption3.isHidden = false
    }
    @IBAction func option4Added(_ sender: Any) {
        pollOption4.isHidden = false
        addOption5.isHidden = false
        deleteOption4.isHidden = false
        addOption4.isHidden = true
        deleteOption3.isHidden = true
        
    }
    @IBAction func option4Deleted(_ sender: Any) {
        pollOption4.isHidden = true
        pollOption4.text = nil
        addOption5.isHidden = true
        deleteOption4.isHidden = true
        addOption4.isHidden = false
        deleteOption3.isHidden = false
    }
    @IBAction func option5Added(_ sender: Any) {
        pollOption5.isHidden = false
        addOption6.isHidden = false
        deleteOption5.isHidden = false
        addOption5.isHidden = true
        deleteOption4.isHidden = true
    }
    @IBAction func option5Deleted(_ sender: Any) {
        pollOption5.isHidden = true
        pollOption5.text = nil
        addOption6.isHidden = true
        deleteOption5.isHidden = true
        addOption5.isHidden = false
        deleteOption4.isHidden = false
    }
    @IBAction func option6Added(_ sender: Any) {
        pollOption6.isHidden = false
        addOption7.isHidden = false
        deleteOption6.isHidden = false
        addOption6.isHidden = true
        deleteOption5.isHidden = true
    }
    @IBAction func option6Deleted(_ sender: Any) {
        pollOption6.isHidden = true
        pollOption6.text = nil
        addOption7.isHidden = true
        deleteOption6.isHidden = true
        addOption6.isHidden = false
        deleteOption5.isHidden = false
    }
    @IBAction func option7Added(_ sender: Any) {
        pollOption7.isHidden = false
        addOption8.isHidden = false
        deleteOption7.isHidden = false
        addOption7.isHidden = true
        deleteOption6.isHidden = true
    }
    @IBAction func option7Deleted(_ sender: Any) {
        pollOption7.isHidden = true
        pollOption7.text = nil
        addOption8.isHidden = true
        deleteOption7.isHidden = true
        addOption7.isHidden = false
        deleteOption6.isHidden = false
    }
    @IBAction func option8Added(_ sender: Any) {
        pollOption8.isHidden = false
        addOption9.isHidden = false
        deleteOption8.isHidden = false
        addOption8.isHidden = true
        deleteOption7.isHidden = true
    }
    @IBAction func option8Deleted(_ sender: Any) {
        pollOption8.isHidden = true
        pollOption8.text = nil
        addOption9.isHidden = true
        deleteOption8.isHidden = true
        addOption8.isHidden = false
        deleteOption7.isHidden = false
    }
    @IBAction func option9Added(_ sender: Any) {
        pollOption9.isHidden = false
        addOption10.isHidden = false
        deleteOption9.isHidden = false
        addOption9.isHidden = true
        deleteOption8.isHidden = true
    }
    @IBAction func option9Deleted(_ sender: Any) {
        pollOption9.isHidden = true
        pollOption9.text = nil
        addOption10.isHidden = true
        deleteOption9.isHidden = true
        addOption9.isHidden = false
        deleteOption8.isHidden = false
    }
    @IBAction func option10Added(_ sender: Any) {
        pollOption10.isHidden = false
        deleteOption10.isHidden = false
        addOption10.isHidden = true
        deleteOption9.isHidden = true
    }
    @IBAction func option10Deleted(_ sender: Any) {
        pollOption10.isHidden = true
        pollOption10.text = nil
        deleteOption10.isHidden = true
        addOption10.isHidden = false
        deleteOption9.isHidden = false
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        latitude = locValue.latitude
        longitude = locValue.longitude
    }
    
    
    
    
    
    
    // MARK: - Navigation
    
    /*
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
