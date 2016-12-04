//
//  FavoritesTableController.swift
//  Pollo Ask Around
//
//  Created by Chiraag Kapadia on 12/3/16.
//  Copyright © 2016 CAKK. All rights reserved.
//

import UIKit

class FavoritesTableController: UIViewController,UITableViewDataSource {

    var myArray : [String] = ["alice", "bob","charles"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print("in cellForRow at \(indexPath)")
        let myCell = tableView.dequeueReusableCell(withIdentifier: "theCell")! as! PollTableCell
        //let myCell = UITableViewCell(style: .default, reuseIdentifier: nil) as! PollTableCell
        myCell.textLabel!.numberOfLines = 3
        myCell.textLabel!.lineBreakMode = .byWordWrapping
        myCell.textLabel!.text = myArray[indexPath.row]
        
        
        myCell.pollName = myArray[indexPath.row]
        
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
