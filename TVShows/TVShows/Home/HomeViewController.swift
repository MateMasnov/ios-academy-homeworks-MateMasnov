//
//  HomeViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 18/07/2018.
//  Copyright © 2018 Mate Masnov. All rights reserved.
//

import UIKit
import PromiseKit
import KeychainAccess

class HomeViewController: UIViewController, UICollectionViewDelegateFlowLayout, Progressable {

    //MARK: - Privates -
    private var token: String!
    private var isListView: Bool = true
    private var toggleButton: UIBarButtonItem?
    private var shows: [Show] = [] {
        didSet  {
            collectionView.reloadData()
        }
    }
    
    //MARK: - Outlets -
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.reloadData()
        }
    }
    
    //MARK: - Controller functions -
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationItems()
        loadShows()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = UIColor(rgb: 0xFF758C)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func setToken(token: String) {
        self.token = token
    }
    
    private func setNavigationItems() {
        let logoutItem = UIBarButtonItem.init(image: UIImage(named: "ic-logout"),
                                              style: .plain,
                                              target: self,
                                              action: #selector(_logoutActionHandler))
        navigationItem.leftBarButtonItem = logoutItem
        
        toggleButton = UIBarButtonItem.init(image: UIImage(named: "ic-gridview"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(butonTapped(sender:)))
        navigationItem.rightBarButtonItem = toggleButton
    }
    
    //MARK: - Button actions -
    @objc private func butonTapped(sender: UIBarButtonItem) {
        guard let toggleButton = toggleButton else { return }
        
        if isListView {
            toggleButton.image = UIImage(named: "ic-listview")
        } else {
            toggleButton.image = UIImage(named: "ic-gridview")
        }
        isListView = !isListView
        
        collectionView.reloadData()
        self.navigationItem.setRightBarButton(toggleButton, animated: true)
    }
    
    @objc private func _logoutActionHandler() {
        let keychain = Constants.KeychainEnum.keychain
        keychain["email"] = nil
        keychain["password"] = nil
        
        let loginStoryboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let loginViewController =
            loginStoryboard.instantiateViewController(withIdentifier: "LoginViewController")
                as! LoginViewController
        navigationController?.setViewControllers([loginViewController], animated: true)
    }
    
    //MARK: - API functions -
    private func loadShows() {
        showSpinner()
        ApiManager.getShowsAPICall(token: token)
            .done { [weak self] (responseArray) in
                guard let `self` = self else { return }
                
                self.shows = responseArray
            }
            .catch { [weak self] (error) in
                guard let `self` = self else { return }
                
                print("API failure: \(error)")
                self.presentAlert(title: "API failure", message: "Something went wrong")
            }
            .finally { [weak self] in
                self?.hideSpinner()
        }
    }
}

//MARK: - Extensions -
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsStoryboard: UIStoryboard = UIStoryboard(name: "Details", bundle: nil)
        let showDetailsViewController =
            detailsStoryboard.instantiateViewController(withIdentifier: "ShowDetailsViewController")
                as! ShowDetailsViewController
        
        showDetailsViewController.setup(token: token, showId: shows[indexPath.row].id)
        
        navigationController?.show(showDetailsViewController, sender: self)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        
        if isListView {
            return CGSize(width: width, height: 120)
        } else {
            return CGSize(width: (width - 15)/2, height: (width - 15)/2)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shows.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if isListView {
            let cell: HomeListCollectionViewCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "HomeListCollectionViewCell",
                for: indexPath
                ) as! HomeListCollectionViewCell
            
            cell.configure(with: shows[indexPath.row])
            
            return cell
        } else {
            let cell: HomeGridCollectionViewCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "HomeGridCollectionViewCell",
                for: indexPath
                ) as! HomeGridCollectionViewCell
            
            cell.configure(with: shows[indexPath.row])
            
            return cell
        }
    }
}

