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
    var myArray = [String()]
    var pollTitle = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //optionsStackView.translatesAutoresizingMaskIntoConstraints = false;
        // Do any additional setup after loading the view.
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
    override func viewWillAppear(_ animated: Bool) {
       titleOfPoll.text = pollTitle
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func optionChosen(sender: UIButton!) {
        
        print("Button ", sender.tag ," tapped")
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
