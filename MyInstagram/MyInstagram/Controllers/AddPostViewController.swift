//
//  AddPostViewController.swift
//  MyInstagram
//
//  Created by Иван Знак on 10/01/2024.
//

import UIKit
import PhotosUI
import FirebaseAuth
import FirebaseFirestore

enum NotificationStorage {
    static let name = NSNotification.Name.init("AddPostViewController")
}

class AddPostViewController: UIViewController, PHPickerViewControllerDelegate, UITextViewDelegate{
    let scrollView = UIScrollView()
    let textView = UITextView()
    let imageView = UIImageView()
    let imageViewLabel = UILabel()
    
    lazy var phPicker: PHPickerViewController = {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.selectionLimit = 10
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationControllerParameters()
        constraints()
        imageViewParameters()
        textViewParameters()
        imageViewLabelParameters()
        scrollViewParameters()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func backButtonTarget(){
        navigationController?.popViewController(animated: true)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func addPostButtonTarget(){
        if imageView.image != nil && textView.textColor != .lightGray {
            let post = PostItem(image: imageView.image, title: "Name of Account", likeText:NSMutableAttributedString(string: "Likes: 0"), bodyText: NSMutableAttributedString(string: "NAME " + textView.text), isLiked: false, isBookmark: false)
            NotificationCenter.default.post(name: NotificationStorage.name, object: self, userInfo: ["NewPost" : post])
            
            setData()
            
            
            
            navigationController?.pushViewController(ViewController(), animated: true)
            navigationController?.setNavigationBarHidden(true, animated: false)
        } else if imageView.image == nil && textView.textColor == .lightGray {
            showAlert("Error", description: "Please choose a text and image to add Post", completion: nil)
        } else if imageView.image == nil && textView.textColor != .lightGray {
            showAlert("Error", description: "Please choose an image to add Post", completion: nil)
        } else if textView.textColor == .lightGray && imageView.image != nil {
            showAlert("Error", description: "Please choose a text to add Post", completion: nil)
        }
    }
    @objc func imageViewTarget(){
        navigationController?.present(phPicker, animated: true)
    }
    private func imageViewParameters(){
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTarget))
        imageView.addGestureRecognizer(tapGesture)
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.systemGray.cgColor
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
    }
    private func textViewParameters(){
        textView.text = "Enter your text of post"
        textView.textColor = .lightGray
        textView.delegate = self
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.font = .systemFont(ofSize: 17)
//        textView.autocapitalizationType = .words
        textView.isScrollEnabled = false
        
        
    }
    private func imageViewLabelParameters(){
        imageViewLabel.text = "Choose your photo of post"
        imageViewLabel.textColor = .systemBlue
        imageViewLabel.textAlignment = .center
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray && textView.isFirstResponder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing (_ textView: UITextView) {
        if textView.text.isEmpty || textView.text == "" {
            textView.textColor = .lightGray
            textView.text = "Enter your text of post"
        }
    }
    //MARK: - PHPickerViewControllerDelegate
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if results.count == 1 {
            let itemProviders = results.map { $0.itemProvider }
            for item in itemProviders {
                item.loadObject(ofClass: UIImage.self) { image, error in
                    guard let image = image as? UIImage else {return}
                    DispatchQueue.main.async {
                        self.imageView.image = image
                        self.imageViewLabel.removeFromSuperview()
                    }
                }
            }
            picker.dismiss(animated: true)
        } else if results.isEmpty {
            picker.dismiss(animated: true)
        }
        else if results.count >= 2 {
            picker.showAlert("Soon", description: "Adding >1 images to Post will be adding soon", completion: nil)
        }
    }
    
    func navigationControllerParameters(){
        navigationItem.title = "Add Post"
        navigationController?.setNavigationBarHidden(false, animated: false)
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTarget))
        navigationItem.leftBarButtonItem = backButton
        
        let addPostButton = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(addPostButtonTarget))
        navigationItem.rightBarButtonItem = addPostButton
    }
    
    private func scrollViewParameters(){
        scrollView.isScrollEnabled = true
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = false
    }
    
    private func constraints(){
        imageView.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        imageViewLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(textView)
        imageView.addSubview(imageViewLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            textView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            imageView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalToConstant: 500),
            
            imageViewLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            imageViewLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }
    
    private func showAlert(_ title: String, description: String, completion: ((Bool) -> Void)?) {
        let controller = UIAlertController(title: title, message: description, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            completion?(true)
        }))
        self.present(controller, animated: true)
    }
    
    private func setData(){
        var name: String?
        if let id = Auth.auth().currentUser?.uid {
            Firestore.firestore().document("\(id)/accountInformation").getDocument { snapshot, error in
                if error == nil {
                    if let snapshot = snapshot?.data() {
                        name = snapshot["name"] as? String
                        
                    }
                }
            }
        }
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: DispatchWorkItem(block: {
            if let id = Auth.auth().currentUser?.uid {
                guard let name = name else {return}
                guard let text = self.textView.text else {return}
                let database = Firestore.firestore().collection(id).document("postItems").collection("postItem").document(UUID().uuidString)
                database.setData(["title" : name, "bodyText": "\(name): \(text)"])
            }
        }))
        
    }
}
extension PHPickerViewController {
    func showAlert(_ title: String, description: String, completion: ((Bool) -> Void)?) {
        let controller = UIAlertController(title: title, message: description, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            completion?(true)
        }))
        self.present(controller, animated: true)
    }
}
