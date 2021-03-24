//
//  PhotoCommentViewController.swift
//  Note
//
//  Created by Александр on 20.02.2021.
//  Copyright © 2021 lancelap. All rights reserved.
//

import UIKit

class PhotoCommentViewController: UIViewController {
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var nameTextField: UITextField!
  
  var photoName: String?
  var photoIndex: Int!
    
    var image: UIImage!



  override func viewDidLoad() {
    super.viewDidLoad()
    if let photoName = photoName {
      self.imageView.image = UIImage(named: photoName)
    }
    
    if let image = image {
      self.imageView.image = image
    }
    
    NotificationCenter.default.addObserver(self, selector: #selector(NoteViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(NoteViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapScrollView))
    tapGestureRecognizer.numberOfTapsRequired = 1
    scrollView.addGestureRecognizer(tapGestureRecognizer)

  }
}

//MARK:- Actions and prepare
extension PhotoCommentViewController {
  @IBAction func hideKeyboard(_ sender: AnyObject) {
    nameTextField.endEditing(true)
  }

  @IBAction func openZoomingController(_ sender: AnyObject) {
    self.performSegue(withIdentifier: "zooming", sender: nil)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let id = segue.identifier,
      let viewController = segue.destination as? ZoomedPhotoViewController,
      id == "zooming" {
      viewController.photoCommentImage = image
    }
  }
}

//MARK:- Keyboard
extension PhotoCommentViewController {
    
    @objc func didTapScrollView(){
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            return
        }
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height , right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
}
