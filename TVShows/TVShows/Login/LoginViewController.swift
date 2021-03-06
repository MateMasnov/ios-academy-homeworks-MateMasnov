//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 17/07/2018.
//  Copyright © 2018 Mate Masnov. All rights reserved.
//

import UIKit
import PromiseKit
import KeychainAccess

class LoginViewController: UIViewController, Progressable {
    
    //MARK: - Outlets -
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var checkmarkButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //MARK: - Private -
    
    //MARK: - Controller functions -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkKeychainLogin()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        registerKeyboardNotifications()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func checkKeychainLogin() {
        let keychain: Keychain = Constants.KeychainEnum.keychain
        guard
            let email = keychain["email"],
            let password = keychain["password"]
            else {
                return
        }
        
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        
        login(parameters: parameters)
    }
    
    //MARK: - Notification functions -
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
   
    @objc private func keyboardWillShow(_ notification: Notification) {
        adjustKeyboard(true, notification: notification, scrollView: scrollView)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        adjustKeyboard(false, notification: notification, scrollView: scrollView)
    }
    
    private func registerKeyboardNotifications() {
        NotificationCenter
            .default
            .addObserver(
                self,
                selector: #selector(keyboardWillShow(_:)),
                name: .UIKeyboardWillShow,
                object: nil)
        
        NotificationCenter
            .default
            .addObserver(
                self,
                selector: #selector(keyboardWillHide(_:)),
                name: .UIKeyboardWillHide,
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
    
    private func handleError(title: String, message: String, textFields: [UITextField]?) {
        guard let textFields = textFields else {
            self.presentAlert(title: title, message: message)
            
            emailTextField.text = nil
            passwordTextField.text = nil
            return
        }
        
        presentAlertWithTextFieldAnimations(title: title,
                                                 message: message,
                                                 textFields: textFields)
    }
    
    private func navigateToHomeViewController() {
        let homeStoryboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let homeViewController =
            homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
                as! HomeViewController
        
        homeViewController.title = "TV Shows"
        
        navigationController?.setViewControllers([homeViewController], animated: true)
    }
    
    //MARK: - Api functions -
    private func register(parameters: [String: String]) {
        showSpinner()
        ApiManager.makeAPICall(url: Constants.URL.usersUrl,
                               method: .post,
                               parameters: parameters)
            .done { [weak self] (user: User) in
                self?.login(parameters: parameters)
            }
            .catch { [weak self] (error) in
                guard let `self` = self else { return }
                
                print("API failure: \(error)")
                self.handleError(title: "API error",
                                 message: "Something went wrong",
                                 textFields: [self.emailTextField, self.passwordTextField])
            }
            .finally { [weak self] in
                self?.hideSpinner()
        }
    }
    
    private func login(parameters: [String: String]) {
        showSpinner()
        ApiManager.makeAPICall(url: "\(Constants.URL.usersUrl)/sessions",
                               method: .post,
                               parameters: parameters)
            .done { [weak self] (loginData: LoginData) in
                guard let `self` = self else { return }
                
                if self.checkmarkButton.isSelected {
                    let keychain: Keychain = Constants.KeychainEnum.keychain
                    keychain["email"] = parameters["email"]
                    keychain["password"] = parameters["password"]
                }
                
                ApiManager.initializeSession(token: loginData.token)
                
                self.navigateToHomeViewController()
            }
            .catch { [weak self] (error) in
                guard let `self` = self else { return }
                
                print("API failure: \(error)")
                self.handleError(title: "API error",
                                 message: "Something went wrong",
                                 textFields: [self.emailTextField, self.passwordTextField])
            }.finally { [weak self] in
                self?.hideSpinner()
        }
    }
    
    //MARK: - Actions -
    @IBAction
    private func createAccountAction(_ sender: UIButton) {
        guard let parameters = getParameters() else {
            handleError(title: "User input error",
                        message: "Invalid username or password",
                        textFields: [emailTextField, passwordTextField])
            return
        }
        
        register(parameters: parameters)
    }
    
    @IBAction
    private func loginAction(_ sender: UIButton) {
        guard let parameters = getParameters() else {
            handleError(title: "User input error",
                        message: "Invalid username or password",
                        textFields: [emailTextField, passwordTextField])
            return
        }
        
        login(parameters: parameters)
    }
    
    @IBAction
    private func checkmarkAction(_ sender: UIButton) {
        checkmarkButton.isSelected = !checkmarkButton.isSelected
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            passwordTextField.resignFirstResponder()
            loginAction(loginButton)
        }
        
        return true
    }
}
