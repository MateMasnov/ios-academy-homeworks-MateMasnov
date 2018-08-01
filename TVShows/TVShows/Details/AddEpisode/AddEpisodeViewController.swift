//
//  AddEpisodeViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 26/07/2018.
//  Copyright © 2018 Mate Masnov. All rights reserved.
//

import UIKit
import PromiseKit

protocol AddEpisodeControllerDelegate: class {
    func addedEpisode(episode: Episode)
}

class AddEpisodeViewController: UIViewController, Progressable {
    
    //MARK: - Privates -
    private var showId: String!
    private var token: String!
    weak var delegate: AddEpisodeControllerDelegate?

    //MARK: - Outlets -
    @IBOutlet weak var episodeTitleField: UITextField!
    @IBOutlet weak var seasonNumberField: UITextField!
    @IBOutlet weak var episodeNumberField: UITextField!
    @IBOutlet weak var episodeDescriptionField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //MARK: - Controller functions -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationItems()
        episodeTitleField.delegate = self
        seasonNumberField.delegate = self
        episodeDescriptionField.delegate = self
        episodeNumberField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = UIColor(rgb: 0xFF758C)
        registerKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    private func setNavigationItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didSelectCancelShow))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didSelectAddShow))
    }
    
    func setup(token: String, showId: String) {
        self.token = token
        self.showId = showId
    }
    
    //MARK: - Keyboard notifications -
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
    
    //MARK: - Bar button actions -
    @objc private func didSelectAddShow() {
        guard let parameters = getParameters() else {
            let textFields: [UITextField] = [
                episodeTitleField,
                episodeDescriptionField,
                episodeNumberField,
                seasonNumberField
            ]
        
            handleError(title: "Input error",
                        message: "Invalid text input",
                        textFields: textFields)
            return
        }
        
        addEpisode(parameters: parameters)
    }
    
    @objc private func didSelectCancelShow() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Strategic functions -
    private func handleError(title: String, message: String, textFields: [UITextField]?) {
        guard let textFields = textFields else {
            presentAlert(title: title, message: message)
            
            episodeTitleField.text = nil
            episodeDescriptionField.text = nil
            episodeNumberField.text = nil
            seasonNumberField.text = nil
            return
        }
        
        self.presentAlertWithTextFieldAnimations(title: title, message: message, textFields: textFields)
    }
    
    private func getParameters() -> [String: String]? {
        guard
            let title: String = episodeTitleField.text,
            let season: String = seasonNumberField.text,
            let episode: String = episodeNumberField.text,
            let description: String = episodeDescriptionField.text,
            !title.isEmpty,
            !season.isEmpty,
            !episode.isEmpty,
            !description.isEmpty
            else {
                return nil
        }
        
        return [ "showId": showId,
                 "mediaId": "",
                 "title": title,
                 "description": description,
                 "episodeNumber": episode,
                 "season": season
                ]
    }
    
    //MARK: - API functions -
    private func addEpisode(parameters: [String: String]) {
        let headers: [String: String] = ["Authorization": token]
        
        showSpinner()
        ApiManager.addEpisodeAPICall(parameters: parameters, headers: headers)
            .done { [weak self] (result) in
                guard let `self` = self else { return }
                
                self.delegate?.addedEpisode(episode: result)
                self.dismiss(animated: true, completion: nil)
            }
            .catch { [weak self] (error) in
                guard let `self` = self else { return }

                let textFields: [UITextField] = [
                    self.episodeTitleField,
                    self.episodeDescriptionField,
                    self.episodeNumberField,
                    self.seasonNumberField
                ]
                
                print("API failure: \(error)")
                self.handleError(title: "API error",
                                 message: "Something went wrong",
                                 textFields: textFields)
            }.finally { [weak self] in
                self?.hideSpinner()
        }
    }
}

//MARK: - Extensions -
extension AddEpisodeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == episodeTitleField {
            seasonNumberField.becomeFirstResponder()
        }
        if textField == seasonNumberField {
            episodeNumberField.becomeFirstResponder()
        }
        if textField == episodeNumberField {
            episodeDescriptionField.becomeFirstResponder()
        }
        if textField == episodeDescriptionField {
            textField.resignFirstResponder()
            didSelectAddShow()
        }
        
        return true
    }
}
