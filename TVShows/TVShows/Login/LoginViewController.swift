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
import PromiseKit

class LoginViewController: UIViewController, Progressable {
    
    //MARK: - Outlets -
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var checkmarkButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //MARK: - Private -
    private var user: User?
    private var loginData: LoginData?
    
    //MARK: - Controller functions -
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupKeyboardNotifications()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: - Notification functions -
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
   
    @objc func keyboardWillShow(_ notification: Notification) {
        adjustKeyboard(true, notification: notification, scrollView: scrollView)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        adjustKeyboard(false, notification: notification, scrollView: scrollView)
    }
    
    private func setupKeyboardNotifications() {
        NotificationCenter
            .default
            .addObserver(
                self,
                selector: #selector(LoginViewController.keyboardWillShow(_:)),
                name: Notification.Name.UIKeyboardWillShow,
                object: nil)
        
        NotificationCenter
            .default
            .addObserver(
                self,
                selector: #selector(LoginViewController.keyboardWillHide(_:)),
                name: Notification.Name.UIKeyboardWillHide,
                object: nil)
    }
    
    //MARK: - Strategic functions -
    private func getParameters() -> [String: String]? {
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
    
    private func handleError(title: String, message: String) {
        self.presentAlert(title: title, message: message)
        
        emailTextField.text = nil
        passwordTextField.text = nil
    }
    
    private func navigateToHomeViewController(loginData: LoginData) {
        let homeStoryboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let homeViewController =
            homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
                as! HomeViewController
        
        homeViewController.setToken(token: loginData.token)
        homeViewController.title = "TV Shows"
        
        navigationController?.setViewControllers([homeViewController], animated: true)
    }
    
    //MARK: - API call functions -
    private func loginAPICall(parameters: [String: String]) -> Promise<LoginData> {
        return Promise {
            seal in
            
            Alamofire
                .request("https://api.infinum.academy/api/users/sessions",
                         method: .post,
                         parameters: parameters,
                         encoding: JSONEncoding.default)
                .validate()
                .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {
                    (response: DataResponse<LoginData>) in
                    
                    switch response.result {
                    case .success(let loginDataResult):
                        seal.fulfill(loginDataResult)
                    case .failure(let error):
                        seal.reject(error)
                    }
            }
        }
    }
    
    private func registerAPICall(parameters: [String: String]) -> Promise<User> {
        return Promise {
            seal in
            
            Alamofire
                .request("https://api.infinum.academy/api/users",
                         method: .post,
                         parameters: parameters,
                         encoding: JSONEncoding.default)
                .validate()
                .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {
                    (response: DataResponse<User>) in
                    
                    switch response.result {
                    case .success(let userResult):
                        seal.fulfill(userResult)
                    case .failure(let error):
                        seal.reject(error)
                    }
            }
        }
    }
    
    private func register(parameters: [String: String]) {
        showSpinner()
        registerAPICall(parameters: parameters)
            .done { [weak self] (user) in
                guard let `self` = self else { return }
                
                self.user = user
                self.login(parameters: parameters)
            }
            .catch { [weak self] (error) in
                guard let `self` = self else { return }
                
                print("API failure: \(error)")
                self.handleError(title: "API error", message: "Something went wrong")
            }
            .finally { [weak self] in
                self?.hideSpinner()
        }
    }
    
    private func login(parameters: [String: String]) {
        showSpinner()
        loginAPICall(parameters: parameters)
            .done { [weak self] (loginData) in
                guard let `self` = self else { return }
                
                self.loginData = loginData
                self.navigateToHomeViewController(loginData: loginData)
            }
            .catch { [weak self] (error) in
                guard let `self` = self else { return }
                
                print("API failure: \(error)")
                self.handleError(title: "API error", message: "Something went wrong")
            }.finally { [weak self] in
                self?.hideSpinner()
        }
    }
    
    //MARK: - Actions -
    @IBAction
    func createAccountAction(_ sender: UIButton) {
        guard let parameters = getParameters() else {
            handleError(title: "User input error", message: "Invalid username or password")
            return
        }
        
        register(parameters: parameters)
    }
    
    @IBAction
    func loginAction(_ sender: UIButton) {
        guard let parameters = getParameters() else {
            handleError(title: "User input error", message: "Invalid username or password")
            return
        }
        
        login(parameters: parameters)
    }
    
    @IBAction
    func checkmarkAction(_ sender: UIButton) {
        checkmarkButton.isSelected = !checkmarkButton.isSelected
    }
}
