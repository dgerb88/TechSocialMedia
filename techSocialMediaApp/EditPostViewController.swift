//
//  EditPostViewController.swift
//  techSocialMediaApp
//
//  Created by Dax Gerber on 2/9/24.
//

import UIKit

class EditPostViewController: UIViewController {
    
    var post: Post?
    weak var delegate: EditPostDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeTitleTextField.text = post?.title
        changeBodyTextfield.text = post?.body
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var postBodyLabel: UILabel!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var changeTitleTextField: UITextField!
    @IBOutlet weak var changeBodyTextfield: UITextField!
    // MARK: - Navigation

     @IBAction func saveButtonTapped(_ sender: Any) {
         post?.title = changeTitleTextField.text ?? ""
         post?.body = changeBodyTextfield.text ?? ""
         Task {
             if post == nil {
                 let newPost = try await NetworkController.shared.createPost(userSecret: User.current!.secret, title: changeTitleTextField.text ?? "", body: changeBodyTextfield.text ?? "")
                 delegate?.newPost(post: newPost)
             } else {
                 let newPost = try await NetworkController.shared.editPost(userSecret: User.current!.secret, postid: post!.postid, title: changeTitleTextField.text ?? "", body: changeBodyTextfield.text ?? "")
                 delegate?.updatePost(post: newPost)
             }
         }
         dismiss(animated: true)
     }
    
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        dismiss(animated: true)
        guard post != nil else { return }
        Task {
            try await NetworkController.shared.deletePost(userSecret: User.current!.secret, postid: post!.postid)
        }
    }
    
    
}

protocol EditPostDelegate: AnyObject {
    func updatePost(post: Post)
    func newPost(post: Post)
}
