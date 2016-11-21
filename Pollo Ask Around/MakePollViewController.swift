//
//  MakePollViewController.swift
//  Pollo Ask Around
//
//  Created by Labuser on 11/19/16.
//  Copyright © 2016 CAKK. All rights reserved.
//

import UIKit

class MakePollViewController: UIViewController {

    @IBOutlet weak var pollQuestion: UITextField!
    @IBOutlet weak var pollOption1: UITextField!
    
    @IBOutlet weak var pollOption2: UITextField!
    @IBOutlet weak var pollOption3: UITextField!
    @IBOutlet weak var pollOption4: UITextField!
    @IBOutlet weak var pollOption5: UITextField!
    @IBOutlet weak var pollOption6: UITextField!
    @IBOutlet weak var pollOption7: UITextField!
    @IBOutlet weak var pollOption8: UITextField!
    @IBOutlet weak var pollOption9: UITextField!
    @IBOutlet weak var pollOption10: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

     @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true,completion: nil)
    }
    
    @IBOutlet weak var pollPost: UIBarButtonItem!

    @IBAction func postAction(_ sender: UIBarButtonItem) {
        let question = pollQuestion.text!
        let option1: String = pollOption1.text!
        let option2: String = pollOption2.text!
        let latitude = 38.648114
        let longitude = -90.311554
        let uuid = "kerryisshit"
        //let uuid = UIDevice.current.identifierForVendor!.uuidString
        //let uuid = "hri1o2jd-uto1-74jd-pqjfoe1g0317"
        let roption2 = option2.replacingOccurrences(of: "'", with: "\\'", options: .literal, range: nil)
        var request = URLRequest(url: URL(string: "http://52.43.103.143:3456/posts")!)
        request.httpMethod = "POST"
        let postString1 = "q="+question
        let postString2 = "&lat="+String(latitude)+"&lng="+String(longitude)
        let postString3 = "&uuid="+uuid
        let postString4 = "&options=['"+option1+"','"+roption2+"']"
        let postString = postString1 + postString2 + postString3 + postString4
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
        
        
    /*
    q - question
    lat - latitude
    lng - longitude
    uuid -
    options -
    */
    
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
