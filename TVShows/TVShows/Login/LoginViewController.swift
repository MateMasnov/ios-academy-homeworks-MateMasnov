//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 17/07/2018.
//  Copyright © 2018 Mate Masnov. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    //MARK: - Outlets -
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var checkmarkButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    //MARK: - Controller functions -
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Actions -
    @IBAction
    func createAccountAction(_ sender: UIButton) {
    }
    
    @IBAction
    func loginAction(_ sender: UIButton) {
    }
    
    @IBAction
    func checkmarkAction(_ sender: UIButton) {
        checkmarkButton.isSelected = !checkmarkButton.isSelected
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
