//
//  VotesViewController.swift
//  Pollo Ask Around
//
//  Created by Kevin Lee on 11/20/16.
//  Copyright © 2016 CAKK. All rights reserved.
//

import UIKit

class VotesViewController: UIViewController {
    
    @IBOutlet weak var titleOfPoll: UILabel!
    @IBOutlet weak var optionsStackView: UIStackView!
    
    //fill this with options.
    var myArray = [String]()
    var pollId = String()
    var isDone = false
    var indexid = [String()]
    var votesArray : [Int] = []
    var pollTitle = String()  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var request = URLRequest(url: URL(string: ("http://52.43.103.143:3456/posts/"+self.pollId+"/options"))!)
        request.httpMethod = "GET"
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
            if(data != nil){
                let jsonResult: JSON = JSON(data: data!)
                //self.saveJson = jsonResult
                for (id,dict) in jsonResult{
                    
                    let option = String(dict["text"].stringValue)
                    self.votesArray.append(Int(dict["votes"].stringValue)!)
                    self.myArray.append(option!)
                    self.indexid.append(id)
                }
                print(self.myArray)
                print(jsonResult)
                self.isDone = true
                //self.makeButtons()
            }
        })
        task.resume()
        while !isDone{
            
        }
        //optionsStackView.translatesAutoresizingMaskIntoConstraints = false;
        // Do any additional setup after loading the view.
        var tag = 1
        let sum = votesArray.reduce(0,+)
        for name in myArray{
            let button = UIButton()
            //button.backgroundColor = .orange
            button.setTitle(name, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel!.numberOfLines = 1

            var imageSize = CGSize()
            
            if(sum>0){
                imageSize = CGSize(width:Double(votesArray[tag-1])/Double(sum) * Double(optionsStackView.frame.size.width), height: 10)
            }else{
                imageSize = CGSize(width:1, height: 10)
            }
//            let imageSize = CGSize(width:Double(sum)/Double(votesArray[tag-1]) * Double(optionsStackView.frame.size.width), height: 10)
            let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: imageSize))
            imageView.backgroundColor = .green
            imageView.alpha = 0.25
            imageView.isUserInteractionEnabled = false;
            imageView.isExclusiveTouch = false;
            button.addSubview(imageView)
//            button.sendSubview(toBack: imageView) // goes behind the collection
            
            if tag == 3{
                button.backgroundColor = .orange
                
            }
           
            //maybe make a custon button
            button.tag = tag
            tag+=1
            button.addTarget(self, action: #selector(optionChosen), for: .touchUpInside)
            optionsStackView.addArrangedSubview(button)
        
            
        }

        //dummy for selecting voted
        

        
    
    }
    /*
    func makeButtons(){
        var tag = 1
        for name in myArray{
            let button = UIButton()
            //button.backgroundColor = .orange
            button.setTitle(name, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel!.numberOfLines = 1
            
            //maybe make a custon button
            button.tag = tag
            tag+=1
            button.addTarget(self, action: #selector(optionChosen), for: .touchUpInside)
            optionsStackView.addArrangedSubview(button)
        }
    }
 */
    override func viewWillAppear(_ animated: Bool) {
       titleOfPoll.text = pollTitle
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func optionChosen(sender: UIButton!) {
        var request = URLRequest(url: URL(string: "http://52.43.103.143:3456/options/"+indexid[sender.tag])!)
        request.httpMethod = "PATCH"
        let uuid = "\"uuid\":\""+UIDevice.current.identifierForVendor!.uuidString
        let op = "\"op\":\"add\""
        let postString = "{"+uuid+"\"," + op + "}"
        print(postString)
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
            print("responseString = \(responseString!)")
        }
        task.resume()
        print("option is ", indexid[sender.tag])
        print("Button ", sender.tag ," tapped")
    }

    @IBAction func addToFavoritesButton(_ sender: Any) {
        print ("oh baby", pollId)
        let defaults = UserDefaults.standard
        if defaults.array(forKey: "FavoritesArray") != nil {
            //if the user already exists.
            var faveArray = defaults.array(forKey: "FavoritesArray") as! [String]
            if(!faveArray.contains(pollTitle)){
                faveArray.append(pollTitle)
                defaults.set(faveArray, forKey: "FavoritesArray")
                
            }
        }else{
            //make for the user
            var faveArray: [String] = []
            faveArray.append(pollTitle)
            defaults.set(faveArray, forKey: "FavoritesArray")
            
        }
    
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
