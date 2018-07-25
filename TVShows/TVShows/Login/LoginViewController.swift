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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: - Notification functions -
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func adjustKeyboard(_ isKeyboardShown: Bool, notification: Notification) {
        let userInfo = notification.userInfo ?? [:]
        let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        
        let keyboardVisibleHeight: CGFloat = keyboardFrame.height
        var height = keyboardVisibleHeight
        
        if #available(iOS 11.0, *), keyboardVisibleHeight > 0 {
            height = height - self.view.safeAreaInsets.bottom
        }
        
        let insetsShow = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: height,
            right: 0
        )
        let insetsHide = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0
        )
        self.scrollView.contentInset = isKeyboardShown ? insetsShow : insetsHide
        
        self.view.setNeedsLayout()
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        adjustKeyboard(true, notification: notification)
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        adjustKeyboard(false, notification: notification)
    }
    
    //MARK: - Strategic functions -
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
    
    func handleError(title: String, message: String) {
        presentAlert(title: title, message: message, controller: self)
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    func navigateToHomeViewController(loginData: LoginData) {
        let homeStoryboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let homeViewController =
            homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
                as! HomeViewController
        homeViewController.setLoginData(loginData: loginData)
        
        self.navigationController?.setViewControllers([homeViewController], animated: true)
    }
    
    //MARK: - API call functions -
    func loginAPICall(parameters: [String: String]) -> Promise<LoginData> {
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
    
    func registerAPICall(parameters: [String: String]) -> Promise<User> {
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
    
    func register(parameters: [String: String]) {
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
            .finally {
                self.hideSpinner()
        }
    }
    
    func login(parameters: [String: String]) {
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
            }.finally {
                self.hideSpinner()
        }
    }
    
    //MARK: - Actions -
    @IBAction
    func createAccountAction(_ sender: UIButton) {
        guard let parameters = getParameters() else {
            self.handleError(title: "User input error", message: "Invalid username or password")
            return
        }
        
        register(parameters: parameters)
    }
    
    @IBAction
    func loginAction(_ sender: UIButton) {
        guard let parameters = getParameters() else {
            self.handleError(title: "User input error", message: "Invalid username or password")
            return
        }
        
        login(parameters: parameters)
    }
    
    @IBAction
    func checkmarkAction(_ sender: UIButton) {
        checkmarkButton.isSelected = !checkmarkButton.isSelected
    }
}
