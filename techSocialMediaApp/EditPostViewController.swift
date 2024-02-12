//
//  EditPostViewController.swift
//  techSocialMediaApp
//
//  Created by Dax Gerber on 2/9/24.
//

import UIKit

class EditPostViewController: UIViewController {
    
    var post: Post?
    var didTapDelete = false
    
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

    
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        guard post != nil else { return }
        didTapDelete = true
        Task {
            try await NetworkController.shared.deletePost(userSecret: User.current!.secret, postid: post!.postid)
        }
    }
    
    
}

