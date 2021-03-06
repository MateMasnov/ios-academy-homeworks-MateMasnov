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
    private var picker: UIImagePickerController?
    private var imageToUpload: UIImage?
    private var showId: String!
    private var mediaId: String?
    weak var delegate: AddEpisodeControllerDelegate?

    //MARK: - Outlets -
    @IBOutlet weak var uploadImageView: UIImageView!
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
        navigationController?.navigationBar.tintColor = Constants.Color.application
        registerKeyboardNotifications()
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
    
    func setShowId(showId: String) {
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }

    //MARK: - Bar button actions -
    @objc private func didSelectAddShow() {
        guard let imageToUpload = imageToUpload else {
            handleError(title: "Image error",
                        message: "Please select image",
                        textFields: nil)
            return
        }
        
        uploadImage(image: imageToUpload)
    }
    
    @objc private func didSelectCancelShow() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uploadPhotoAction(_ sender: Any) {
        picker = UIImagePickerController()
        
        guard let picker = picker else { return }
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle = .popover
        present(picker, animated: true, completion: nil)
    }
    
    //MARK: - Strategic functions -
    private func handleError(title: String, message: String, textFields: [UITextField]?) {
        guard let textFields = textFields else {
            presentAlert(title: title, message: message)
            return
        }
        
        presentAlertWithTextFieldAnimations(title: title, message: message, textFields: textFields)
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
        
        guard let mediaId = mediaId else { return nil }
        
        return [ "showId": showId,
                 "mediaId": mediaId,
                 "title": title,
                 "description": description,
                 "episodeNumber": episode,
                 "season": season
                ]
    }
    
    private func getTextFields() -> [UITextField] {
        return [
            episodeTitleField,
            episodeDescriptionField,
            episodeNumberField,
            seasonNumberField
        ]
    }
    
    //MARK: - API functions -
    private func addEpisode() {
        let textFields: [UITextField] = getTextFields()
        
        guard let parameters = getParameters() else {
            handleError(title: "Input error",
                        message: "Fill required fields",
                        textFields: textFields)
            
            return
        }
        
        showSpinner()
        ApiManager
            .makeAPICall(url: Constants.URL.episodesUrl,
                               method: .post,
                               parameters: parameters)
            .done { [weak self] (result: Episode) in
                guard let `self` = self else { return }
                
                self.delegate?.addedEpisode(episode: result)
                self.dismiss(animated: true, completion: nil)
            }
            .catch { [weak self] (error) in
                guard let `self` = self else { return }
                
                print("API failure: \(error)")
                self.handleError(title: "API error",
                                 message: "Something went wrong",
                                 textFields: textFields)
            }
            .finally { [weak self] in
                self?.hideSpinner()
        }
    }
    
    private func uploadImage(image: UIImage) {
        showSpinner()
        ApiManager
            .uploadImageOnAPI(image: image, name: "String")
            .done { [weak self] (media) in
                guard let `self` = self else { return }
                
                self.mediaId = media.id
                self.addEpisode()
            }
            .catch { [weak self] (error) in
                guard let `self` = self else { return }

                self.presentAlert(title: "Image error", message: "Please try again")
                self.uploadImageView.image = UIImage(named: "photo-logo")!
            }
            .finally { [weak self] in
                self?.hideSpinner()
        }
    }
}

//MARK: - Extensions -
extension AddEpisodeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        uploadImageView.contentMode = .scaleAspectFit
        uploadImageView.image = chosenImage
        imageToUpload = chosenImage
        picker.dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

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
