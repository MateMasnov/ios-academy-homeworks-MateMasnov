//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 17/07/2018.
//  Copyright © 2018 Mate Masnov. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire
import SVProgressHUD

class LoginViewController: UIViewController, Progressable {

    //MARK: - Outlets -
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var checkmarkButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    //MARK: - Private -
    private var user: User?
    private var loginData: LoginData?
    
    //MARK: - Controller functions -
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Functions -
    func getParameters() -> [String: String]? {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            !email.isEmpty,
            !password.isEmpty
        else {
            return nil
        }
        
        return ["email": email,
                "password": password]
    }
    
    func handleError() {
        let alert = UIAlertController(title: "User input error",
                                      message: "Invalid email or password",
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: nil)
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    func loginAPIcall(parameters: [String: String]) {
        showSpinner()
        Alamofire
            .request("https://api.infinum.academy/api/users/sessions",
                     method: .post,
                     parameters: parameters,
                     encoding: JSONEncoding.default)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self]
                (response: DataResponse<LoginData>) in
                
                guard let `self` = self else {
                    return
                }
                
                self.hideSpinner()
                switch response.result {
                case .success(let responseData):
                    self.loginData = responseData
                    
                    let homeStoryboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
                    let homeViewController =
                        homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
                            as! HomeViewController
                    homeViewController.setLoginData(loginData: responseData)
                    self.navigationController?.setViewControllers([homeViewController], animated: true)
                case .failure(let error):
                    print("API failure: \(error)")
                    self.handleError()
                }
        }
    }
    
    //MARK: - Actions -
    @IBAction
    func createAccountAction(_ sender: UIButton) {
        guard let parameters = getParameters() else {
            handleError()
            return
        }
        
        showSpinner()
        Alamofire
            .request("https://api.infinum.academy/api/users",
                     method: .post,
                     parameters: parameters,
                     encoding: JSONEncoding.default)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self]
                (response: DataResponse<User>) in
                
                guard let `self` = self else {
                    return
                }
                
                self.hideSpinner()
                switch response.result {
                case .success(let userResult):
                    self.user = User(email: userResult.email, type: userResult.type, id: userResult.id)
                    
                    self.loginAPIcall(parameters: parameters)
                case .failure(let error):
                    print("API failure: \(error)")
                    self.handleError()
                }
        }
    }
    
    @IBAction
    func loginAction(_ sender: UIButton) {
        guard let parameters = getParameters() else {
            handleError()
            return
        }
        
        loginAPIcall(parameters: parameters)
    }
    
    @IBAction
    func checkmarkAction(_ sender: UIButton) {
        checkmarkButton.isSelected = !checkmarkButton.isSelected
    }
}
