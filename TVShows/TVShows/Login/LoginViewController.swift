//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 09/07/2018.
//  Copyright © 2018 Mate Masnov. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var numberOfClicks: Int = 0;
    let sleepTime: Int = 3;
    
    @IBOutlet weak var mySwitch: UISwitch!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var incrementButton: UIButton!
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        incrementButton.titleLabel?.adjustsFontSizeToFitWidth = true;
        incrementButton.layer.cornerRadius = 20;
        incrementButton.clipsToBounds = true;
       
        initializeAnimation(sleepTime: sleepTime);
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func touchUpInsideSwitchEvent(_ sender: UISwitch) {
        switchControl();
    }

    func switchControl() -> Void {
        if myActivityIndicator.isAnimating {
            myActivityIndicator.stopAnimating()
        } else {
            myActivityIndicator.startAnimating();
        }
    }
    
    @IBAction func TouchUpInsideButtonEvent(_ sender: Any) {
        numberOfClicks += 1;
        print("Value of the label is \(numberOfClicks)");
        counterLabel.text = "Times clicked: \(numberOfClicks)";
    }
    
    func initializeAnimation(sleepTime: Int) -> Void {
        myActivityIndicator.startAnimating();
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(sleepTime), execute: {
            if self.myActivityIndicator.isAnimating {
                self.myActivityIndicator.stopAnimating();
            }
            self.mySwitch.setOn(false, animated: true);
        })
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
