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

class HomeViewController: UIViewController, Progressable {

    private var loginData: LoginData!
    private var shows: [Show] = []
    
    @IBOutlet
    weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.estimatedRowHeight = 50
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "TV Shows"
        getShowsAPICall()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func getShowsAPICall() {
        guard let loginData = loginData else {
            return
        }
        
        let headers = ["Authorization": loginData.token]
        
        showSpinner()
        Alamofire
            .request("https://api.infinum.academy/api/shows",
                     method: .get,
                     encoding: JSONEncoding.default,
                     headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self]
                (response: DataResponse<[Show]>) in
                
                guard let `self` = self else {
                    return
                }
                
                self.hideSpinner()
                switch response.result {
                case .success(let responseArray):
                    self.shows = responseArray
                    self.tableView.reloadData()
                    self.tableView.tableFooterView = UIView()
                case .failure(let error):
                    print("API failure: \(error)")
                }
        }
    }
    
    func setLoginData(loginData: LoginData) {
        self.loginData = loginData
    }
}

extension HomeViewController: UITableViewDelegate {
    
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
        
        let item: HomeCellItem = HomeCellItem(title: shows[indexPath.row].title)
        
        cell.configure(with: item)
        
        return cell
    }
    
}
