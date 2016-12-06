//
//  SplashScreenController.swift
//  Pollo Ask Around
//
//  Created by Chiraag Kapadia on 12/6/16.
//  Copyright © 2016 CAKK. All rights reserved.
//

import UIKit

class SplashScreenController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(enterApp), userInfo: nil, repeats: false)
    }
    
    func enterApp() {
        self.performSegue(withIdentifier: "enterApp", sender: self)
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
