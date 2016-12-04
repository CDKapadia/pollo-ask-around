//
//  FavoritesTableController.swift
//  Pollo Ask Around
//
//  Created by Chiraag Kapadia on 12/3/16.
//  Copyright © 2016 CAKK. All rights reserved.
//

import UIKit
import MapKit

class FavoritesTableController: UIViewController,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noFaveMessage: UILabel!

    var myArray : [String] = []
    let defaults = UserDefaults.standard
    var favorites : [String:String] = [:]
    var favoritesLat : [String:String] = [:]
    var favoritesLong : [String:String] = [:]


    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self

        // Do any additional setup after loading the view, typically from a nib.
        if defaults.dictionary(forKey: "Fave") != nil {
            noFaveMessage.isHidden = true
            favorites = defaults.dictionary(forKey: "Fave") as! [String:String]
            favoritesLat = defaults.dictionary(forKey: "FaveLat") as! [String:String]
            favoritesLong = defaults.dictionary(forKey: "FaveLong") as! [String:String]
            if(favorites.count==0){
                noFaveMessage.isHidden = false
            }else{
                myArray = []
                for key in favorites.keys{
                    myArray.append(key)
                }
            }
        }else{
            //There are no favorites

            noFaveMessage.isHidden = false
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print("in cellForRow at \(indexPath)")
        let myCell = tableView.dequeueReusableCell(withIdentifier: "theCell")! as! FaveViewCell
//        let myCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let thisKey = myArray[indexPath.row]
        
        myCell.textLabel!.numberOfLines = 3
        myCell.textLabel!.lineBreakMode = .byWordWrapping

        
        myCell.textLabel!.text = favorites[thisKey]
        
        myCell.pollName = favorites[thisKey]!
        myCell.pollID = thisKey
        myCell.lat = CLLocationDegrees(favoritesLat[thisKey]!)!
        myCell.long = CLLocationDegrees(favoritesLong[thisKey]!)!
        
        return myCell
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let cell = tableView.cellForRow(at: indexPath) as! FaveViewCell

            myArray.remove(at: indexPath.row)
            favorites.removeValue(forKey: cell.pollID)
            favoritesLat.removeValue(forKey: cell.pollID)
            favoritesLong.removeValue(forKey: cell.pollID)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            defaults.set(favorites, forKey: "Fave")
            defaults.set(favoritesLat, forKey: "FaveLat")
            defaults.set(favoritesLong, forKey: "FaveLong")

            if(favorites.count==0){
                
                
                noFaveMessage.isHidden = false
            }
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
/*
        tableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
        if defaults.dictionary(forKey: "Fave") != nil {
            noFaveMessage.isHidden = true
            favorites = defaults.dictionary(forKey: "Fave") as! [String:(String,String,String)]
            if(favorites.count==0){
                noFaveMessage.isHidden = false
            }else{
                myArray = []
                for key in favorites.keys{
                    myArray.append(key)
                }
            }
        }else{
            //There are no favorites
            noFaveMessage.isHidden = false
        }
        tableView.reloadData()
 */
        tableView.dataSource = self
        
        // Do any additional setup after loading the view, typically from a nib.
        if defaults.dictionary(forKey: "Fave") != nil {
            noFaveMessage.isHidden = true
            favorites = defaults.dictionary(forKey: "Fave") as! [String:String]
            favoritesLat = defaults.dictionary(forKey: "FaveLat") as! [String:String]
            favoritesLong = defaults.dictionary(forKey: "FaveLong") as! [String:String]
            if(favorites.count==0){
                noFaveMessage.isHidden = false
            }else{
                myArray = []
                for key in favorites.keys{
                    myArray.append(key)
                }
            }
        }else{
            //There are no favorites
            
            noFaveMessage.isHidden = false
        }
        tableView.reloadData()

    }


    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        //we can make a custom class for each poll to store data. Or do another request.
        //this will allow us to pass the poll info to the next screen for another request.
        
        if let nextController = segue.destination as? VotesViewController{
            //If going to a CURRENT POLL
            let theSender = sender as! FaveViewCell
            nextController.pollId = theSender.pollID
            nextController.pollTitle = theSender.pollName
            nextController.latitude = theSender.lat
            nextController.longitude = theSender.long
        }
        else{
            //IF going make a new poll. The plus sign
            //do nothing right now.
        }
        
        
    }

}
