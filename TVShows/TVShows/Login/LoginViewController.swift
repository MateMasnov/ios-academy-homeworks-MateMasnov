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

//MARK: - Structures -
struct User: Codable {
    let email: String
    let type: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case type
        case id = "_id"
    }
}

struct LoginData: Codable {
    let token: String
}

class LoginViewController: UIViewController {

    //MARK: - Outlets -
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var checkmarkButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    //MARK: - Private -
    private let homeStoryboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
    private let alert = UIAlertController(title: "User input error",
                                          message: "Invalid email or password",
                                          preferredStyle: UIAlertControllerStyle.alert)
    private var user: User?
    private var loginData: LoginData?
    
    //MARK: - Controller functions -
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: true)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        // Do any additional setup after loading the view.
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
            handleError()
            
            return nil
        }
        
        return ["email": email,
                "password": password]
    }
    
    func handleError() {
        self.present(alert, animated: true, completion: nil)
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    //MARK: - Actions -
    @IBAction
    func createAccountAction(_ sender: UIButton) {
        guard let parameters = getParameters() else {
            return
        }
        
        SVProgressHUD.show()
        Alamofire
            .request("https://api.infinum.academy/api/users",
                     method: .post,
                     parameters: parameters,
                     encoding: JSONEncoding.default)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self]
                (response: DataResponse<User>) in
                
                switch response.result {
                case .success(let userResult):
                    self?.user = User(email: userResult.email, type: userResult.type, id: userResult.id)
                    SVProgressHUD.dismiss()
                    
                    let homeViewController =
                        self?.homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
                        as! HomeViewController
                    self?.navigationController?.setViewControllers([homeViewController], animated: true)
                case .failure(let error):
                    print("API failure: \(error)")
                    self?.handleError()
                    SVProgressHUD.dismiss()
                }
        }
    }
    
    @IBAction
    func loginAction(_ sender: UIButton) {
        guard let parameters = getParameters() else {
            return
        }
        
        SVProgressHUD.show()
        Alamofire
            .request("https://api.infinum.academy/api/users/sessions",
                     method: .post,
                     parameters: parameters,
                     encoding: JSONEncoding.default)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self]
                (response: DataResponse<LoginData>) in
                
                switch response.result {
                case .success(let data):
                    self?.loginData = LoginData(token: data.token)
                    SVProgressHUD.dismiss()
                    
                    let homeViewController =
                        self?.homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
                        as! HomeViewController
                    self?.navigationController?.setViewControllers([homeViewController], animated: true)
                case .failure(let error):
                    print("API failure: \(error)")
                    SVProgressHUD.dismiss()
                    self?.handleError()
                }
        }
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
