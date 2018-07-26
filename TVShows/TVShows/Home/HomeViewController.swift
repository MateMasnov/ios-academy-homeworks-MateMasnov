//
//  HomeViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 18/07/2018.
//  Copyright © 2018 Mate Masnov. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire
import PromiseKit

class HomeViewController: UIViewController, Progressable {

    //MARK: - Privates -
    private var loginData: LoginData!
    private var shows: [Show] = []
    
    //MARK: - Outlets -
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.estimatedRowHeight = 50
        }
    }
    
    //MARK: - Controller functions -
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "TV Shows"
        displayShows()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func setLoginData(loginData: LoginData) {
        self.loginData = loginData
    }
    
    //MARK: - API functions -
    func displayShows() {
        
        showSpinner()
        getShowsAPICall(token: loginData.token)
            .done { [weak self] (responseArray) in
                guard let `self` = self else { return }
                
                self.shows = responseArray
                self.tableView.reloadData()
                self.tableView.tableFooterView = UIView()
            }
            .catch { [weak self] (error) in
                guard let `self` = self else { return }
                
                print("API failure: \(error)")
                self.presentAlert(title: "API failure", message: "Something went wrong")
            }
            .finally {
                self.hideSpinner()
        }
    }
    
    func getShowsAPICall(token: String) -> Promise<[Show]> {
        let headers = ["Authorization": token]
        
        return Promise {
            seal in
            
            Alamofire
                .request("https://api.infinum.academy/api/shows",
                         method: .get,
                         encoding: JSONEncoding.default,
                         headers: headers)
                .validate()
                .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {
                    (response: DataResponse<[Show]>) in
                    
                    switch response.result {
                    case .success(let responseArray):
                        seal.fulfill(responseArray)
                    case .failure(let error):
                        seal.reject(error)
                    }
            }
        }
    }
}

//MARK: - Extensions -
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default, title: "Delete") { action, indexPath in
            self.shows.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        deleteButton.backgroundColor = UIColor(rgb: 0xFF758C)
        
        return [deleteButton]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsStoryboard: UIStoryboard = UIStoryboard(name: "Details", bundle: nil)
        let showDetailsViewController =
            detailsStoryboard.instantiateViewController(withIdentifier: "ShowDetailsViewController")
                as! ShowDetailsViewController
 
        showDetailsViewController.setToken(token: loginData.token)
        showDetailsViewController.setShowId(showId: shows[indexPath.row].id)
        
        navigationController?.show(showDetailsViewController, sender: self)
    }
    
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: HomeTableViewCell = tableView.dequeueReusableCell(
            withIdentifier: "HomeTableViewCell",
            for: indexPath
            ) as! HomeTableViewCell
        
        cell.configure(with: shows[indexPath.row])
        
        return cell
    }
}

