//
//  PollsViewController.swift
//  Pollo Ask Around
//
//  Created by Chiraag Kapadia on 11/15/16.
//  Copyright © 2016 CAKK. All rights reserved.
//

import UIKit

class PollsViewController: UIViewController {

    //  DO NOT WRITE ANY LOGIC HERE. -- CHIRAAG
    override func viewDidLoad() {
        super.viewDidLoad()

        let storyboard = UIStoryboard(name: "Polls", bundle: nil)
        let controller = storyboard.instantiateInitialViewController()! as UIViewController
        addChildViewController(controller)
        view.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
        
        
        
        // Do any additional setup after loading the view.
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
