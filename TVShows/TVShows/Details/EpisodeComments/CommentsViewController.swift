//
//  CommentsViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 01/08/2018.
//  Copyright © 2018 Mate Masnov. All rights reserved.
//

import UIKit
import PromiseKit

class CommentsViewController: UIViewController, Progressable {
    //MARK: - Privates -
    private var token: String!
    private var episodeId: String!
    private var commentsList: [Comments] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    //MARK: - Outlets -
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.estimatedRowHeight = 100
            tableView.separatorStyle = .none
        }
    }
    
    //MARK: - Controller functions -
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        loadComments()
    }

    func setup(episodeId: String, token: String) {
        self.episodeId = episodeId
        self.token = token
    }
    
    //MARK: - Notification functions -
    override func viewWillAppear(_ animated: Bool) {
        registerKeyboardNotifications()
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = UIColor(rgb: 0xFF758C)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        bottomConstraint.constant += CGFloat(self.getKeyboardHeight(notification: notification))
        view.layoutIfNeeded()
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        bottomConstraint.constant = CGFloat(20)
        view.layoutIfNeeded()
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
    
    private func loadComments() {
        showSpinner()
        ApiManager.getAllComments(episodeId: episodeId, token: token)
            .done { [weak self] (comments) in
                self?.commentsList = comments
            }
            .catch { [weak self] (error) in
                self?.presentAlert(title: "Api error", message: "Something went wrong")
            }.finally { [weak self] in
                self?.hideSpinner()
        }
    }
    
    private func postComment() {
        guard let parameters = getParameters() else {
            presentAlertWithTextFieldAnimations(title: "Input error",
                                                message: "Invalid user input",
                                                textFields: [commentTextField])
            return
        }
        
        showSpinner()
        ApiManager.addComment(parameters: parameters, token: token)
            .done { [weak self] (comment) in
                self?.commentsList.append(comment)
            }.catch { [weak self] (error) in
                guard let `self` = self else { return }
                
                self.presentAlertWithTextFieldAnimations(title: "Api error",
                                                    message: "Something went wrong",
                                                    textFields: [(self.commentTextField)!])
            }.finally { [weak self] in
                self?.hideSpinner()
        }
    }
    
    func getParameters() -> [String: String]? {
        guard
            let text =
                commentTextField.text,
                !text.isEmpty
            else {
                return nil
        }
        
        return ["text": text, "episodeId": episodeId]
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addCommentAction(_ sender: Any) {
        postComment()
    }
    
}

//MARK: - Extensions -
extension CommentsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if commentsList.count <= 0 { return nil }
        let deleteButton = UITableViewRowAction(style: .default, title: "Delete") { [weak self] action, indexPath in
            self?.commentsList.remove(at: indexPath.row)
        }
        
        deleteButton.backgroundColor = UIColor(rgb: 0xFF758C)
        
        return [deleteButton]
    }
}

extension CommentsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if commentsList.count <= 0 {
            let cell: CommentsEmptyStateTableViewCell = tableView.dequeueReusableCell(
                withIdentifier: "CommentsEmptyStateTableViewCell",
                for: indexPath
                ) as! CommentsEmptyStateTableViewCell
            
            return cell
        } else {
            let cell: CommentsTableViewCell = tableView.dequeueReusableCell(
                withIdentifier: "CommentsTableViewCell",
                for: indexPath
                ) as! CommentsTableViewCell
            
            cell.configure(with: commentsList[indexPath.row])
            
            return cell
        }
    }
}
