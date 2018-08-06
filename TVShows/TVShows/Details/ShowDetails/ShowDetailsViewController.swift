//
//  ShowDetailsViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 26/07/2018.
//  Copyright © 2018 Mate Masnov. All rights reserved.
//

import UIKit
import PromiseKit

class ShowDetailsViewController: UIViewController, Progressable {

    //MARK: - Privates -
    private var showId: String!
    private var token: String!
    private let refresher: UIRefreshControl = UIRefreshControl()
    private var showDetails: ShowDetails?
    private var episodesList: [Episode] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    //MARK: - Outlets -
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.estimatedRowHeight = 100
            tableView.separatorStyle = .none
            tableView.contentInset.bottom = 80
            tableView.tableFooterView = UIView()
        }
    }
    
    //MARK: - Controller functions -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setRefresher()
        loadDetails()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setup(token: String, showId: String) {
        self.token = token
        self.showId = showId
    }

    private func setRefresher() {
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refresher
        } else {
            tableView.addSubview(refresher)
        }
        
        refresher.tintColor = UIColor(rgb: 0xFF758C)
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(refreshDetails(_:)), for: .valueChanged)
    }
    
    @objc private func refreshDetails(_ sender: Any) {
        loadDetails()
        refresher.endRefreshing()
    }
    
    //MARK: - API functions -
    private func loadDetails() {
        let headers: [String: String] = ["Authorization": token]
        let showId: String = self.showId
        
        showSpinner()
        ApiManager.makeAPICall(url: "\(Constants.URL.showsUrl)/\(showId)", headers: headers)
            .then({ [weak self] (showDetails: ShowDetails) -> Promise<[Episode]> in
                self?.showDetails = showDetails
                return ApiManager.makeAPICall(url: "\(Constants.URL.showsUrl)/\(showId)/episodes", headers: headers)
            })
            .done { [weak self] (episodes: [Episode]) in
                self?.episodesList = episodes
            }
            .catch { [weak self] (error) in
                self?.presentAlert(title: "API error", message: "Something went wrong")
            }
            .finally { [weak self] in
                self?.hideSpinner()
        }
    }
    
    //MARK: - Actions -
    @IBAction
    private func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction
    private func addEpisodeAction(_ sender: Any) {
        let addEpisodeStoryboard: UIStoryboard = UIStoryboard(name: "AddEpisode", bundle: nil)
        let addEpisodeViewController =
            addEpisodeStoryboard.instantiateViewController(withIdentifier: "AddEpisodeViewController")
                as! AddEpisodeViewController
        let navigationController = UINavigationController(rootViewController: addEpisodeViewController)
        
        addEpisodeViewController.title = "Add episode"
        addEpisodeViewController.delegate = self
        addEpisodeViewController.setup(token: token, showId: showId)
        
        present(navigationController, animated: true, completion: nil)
    }
}

//MARK: - Extensions -
extension ShowDetailsViewController: AddEpisodeControllerDelegate {
    func addedEpisode(episode: Episode) {
        showSpinner()
        episodesList.append(episode)
        hideSpinner()
    }
}

extension ShowDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row > 1 else { return }
        
        let episodeStoryboard: UIStoryboard = UIStoryboard(name: "Episode", bundle: nil)
        let episodeDetailsViewController =
            episodeStoryboard.instantiateViewController(withIdentifier: "EpisodeDetailsViewController")
                as! EpisodeDetailsViewController
        
        episodeDetailsViewController.setup(episodeId: episodesList[indexPath.row - 2].id, token: token)
        
        navigationController?.show(episodeDetailsViewController, sender: self)
        
    }
}

extension ShowDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if episodesList.count == 0 {
            return 0
        }
        
        return episodesList.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row: Int = indexPath.row
        
        if row == 0 {
            let cell: ShowImageTableViewCell = tableView.dequeueReusableCell(
                withIdentifier: "ShowImageTableViewCell",
                for: indexPath
                ) as! ShowImageTableViewCell
            
            guard let showDetails = showDetails else { return cell }
            
            let item: ImageCellItem = ImageCellItem(url: showDetails.imageUrl)
            
            cell.configure(with: item)
            
            return cell
        } else if row == 1 {
            let cell: ShowDescriptionTableViewCell = tableView.dequeueReusableCell(
                withIdentifier: "ShowDescriptionTableViewCell",
                for: indexPath
                ) as! ShowDescriptionTableViewCell
            
            guard let showDetails = showDetails else { return cell }
            
            let item: DescriptionCellItem = DescriptionCellItem(
                title: showDetails.title,
                description: showDetails.description,
                numberOfEpisodes: episodesList.count)
            
            cell.configure(with: item)
            
            return cell
        } else {
            let cell: EpisodeTableViewCell = tableView.dequeueReusableCell(
                withIdentifier: "EpisodeTableViewCell",
                for: indexPath
                ) as! EpisodeTableViewCell
                 
            cell.configure(with: episodesList[row - 2])
            
            return cell
        }
    
    }
}
