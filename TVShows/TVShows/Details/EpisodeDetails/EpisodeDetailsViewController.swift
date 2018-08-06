//
//  EpisodeDetailsViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 01/08/2018.
//  Copyright © 2018 Mate Masnov. All rights reserved.
//

import UIKit
import PromiseKit

class EpisodeDetailsViewController: UIViewController, Progressable {

    
    private var episodeId: String!
    private var token: String!
    private var episodeDetails: Episode? {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.estimatedRowHeight = 100
            tableView.separatorStyle = .none
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        loadEpisodeDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setup(episodeId: String, token: String) {
        self.token = token
        self.episodeId = episodeId
    }
    
    private func loadEpisodeDetails() {
        showSpinner()
        ApiManager.getEpisodeDetailsAPICall(episodeId: episodeId, token: token)
            .done { [weak self] (episode) in
                self?.episodeDetails = episode
            }
            .catch { [weak self] (error) in
                self?.presentAlert(title: "API error", message: "Something went wrong")
            }
            .finally { [weak self] in
                self?.hideSpinner()
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func commentsButtonAction(_ sender: Any) {
        let commentsStoryboard: UIStoryboard = UIStoryboard(name: "Comments", bundle: nil)
        let commentsViewController =
            commentsStoryboard.instantiateViewController(withIdentifier: "CommentsViewController")
                as! CommentsViewController
        
        guard let episodeDetails = episodeDetails else { return }
        
        commentsViewController.setup(episodeId: episodeDetails.id, token: token)
        commentsViewController.title = "Comments"
        
        navigationController?.show(commentsViewController, sender: self)
        
    }
}

extension EpisodeDetailsViewController: UITableViewDelegate {
    
}

extension EpisodeDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row: Int = indexPath.row
        
        if row == 0 {
            let cell: EpisodeImageTableViewCell = tableView.dequeueReusableCell(
                withIdentifier: "EpisodeImageTableViewCell",
                for: indexPath
                ) as! EpisodeImageTableViewCell
            
            guard let episodeDetails = episodeDetails else { return cell }
            
            let item: ImageCellItem = ImageCellItem(url: episodeDetails.imageUrl)
            
            cell.configure(with: item)
            
            return cell
        } else {
            let cell: EpisodeDetailsTableViewCell = tableView.dequeueReusableCell(
                withIdentifier: "EpisodeDetailsTableViewCell",
                for: indexPath
                ) as! EpisodeDetailsTableViewCell
            
            guard let episodeDetails = episodeDetails else { return cell }
            
            cell.configure(with: episodeDetails)
            
            return cell
        }
        
    }
}
