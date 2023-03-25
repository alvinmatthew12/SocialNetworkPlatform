//
//  CreatePostViewController.swift
//  SocialNetworkPlatform
//
//  Created by Alvin Matthew Pratama on 25/03/23.
//

import UIKit

internal final class CreatePostViewController: UIViewController {
    
    @IBOutlet private weak var profilePictureImageView: UIImageView!
    @IBOutlet private weak var postAsLabel: UILabel!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var imageView: UIImageView!
    private let imagePicker = UIImagePickerController()
    private let toolbar = UIToolbar()
    
    private lazy var addImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "photo.artframe"), for: .normal)
        button.setTitle("Add Image", for: .normal)
        button.addTarget(self, action: #selector(imageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let removeImageCaptioLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap image to remove"
        label.textColor = .greyColor
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private var selectedImage: UIImage? {
        didSet {
            imageView.image = selectedImage
            if selectedImage != nil {
                addImageButton.setTitle("Change Image", for: .normal)
                removeImageCaptioLabel.isHidden = false
                imageView.isHidden = false
            } else {
                addImageButton.setTitle("Add Image", for: .normal)
                removeImageCaptioLabel.isHidden = true
                imageView.isHidden = true
            }
            toolbar.setNeedsLayout()
        }
    }
    
    private var imageViewOriginalFrame: CGRect?
    private let textViewPlaceholder = "Enter your text here..."
    
    override internal func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupToolbar()
        setupView()
        
        // Register for keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    private func setupView() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.width / 2
        textView.delegate = self
        textView.text = textViewPlaceholder
        textView.textColor = .greyColor
        
        removeImageCaptioLabel.isHidden = true
        imageView.isHidden = true
        imageViewOriginalFrame = imageView.frame
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)

    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.topItem?.backButtonTitle = "Cancel"
        navigationItem.backBarButtonItem?.tintColor = .textColor
        navigationController?.navigationBar.backIndicatorImage = UIImage()
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage()
        UIBarButtonItem.appearance().tintColor = .textColor
        
        let postBarButton = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(postButtonTapped))
        postBarButton.imageInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -8)
        navigationItem.rightBarButtonItem = postBarButton
    }
    
    private func setupToolbar() {
        toolbar.sizeToFit()
        let imageBarButton = UIBarButtonItem(customView: addImageButton)
        let captionBarButton = UIBarButtonItem(customView: removeImageCaptioLabel)
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [imageBarButton, space, captionBarButton]
        textView.inputAccessoryView = toolbar
    }
    
    @objc private func postButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func imageButtonTapped() {
        present(imagePicker, animated: true, completion: { [weak self] in
            self?.textView.resignFirstResponder()
        })
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        // Get the size of the keyboard
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size else { return }
        
        // Adjust the frame of the image view to move it above the keyboard
        imageView.frame.origin.y = view.frame.height - keyboardSize.height - imageView.frame.height - 20
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        // Move the image view back to its original position
        imageView.frame = imageViewOriginalFrame ?? CGRect(x: 16, y: self.view.frame.height - 150, width: 100, height: 100)
    }
    
    @objc private func imageTapped() {
        selectedImage = nil
    }
}

extension CreatePostViewController: UITextViewDelegate {
    internal func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceholder {
            textView.text = ""
            textView.textColor = .textColor
        }
    }

    internal func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = textViewPlaceholder
            textView.textColor = .greyColor
        }
    }
}

extension CreatePostViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            selectedImage = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }

    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
