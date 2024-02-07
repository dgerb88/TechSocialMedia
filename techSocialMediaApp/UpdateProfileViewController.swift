//
//  UpdateProfileViewController.swift
//  techSocialMediaApp
//
//  Created by Dax Gerber on 2/7/24.
//

import UIKit

protocol UpdateEditProfileViewDelegate: AnyObject {
    func didUpdate()
}


class UpdateProfileViewController: UIViewController {

    
    @IBOutlet weak var updateBioTextField: UITextField!
    @IBOutlet weak var techInterestsTextField: UITextField!
    weak var delegate: UpdateEditProfileViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateBioTextField.text = UserProfileViewController.sharedProfile?.bio
        techInterestsTextField.text = UserProfileViewController.sharedProfile?.techInterests
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButton(_ sender: Any) {
        UserProfileViewController.sharedProfile?.bio = updateBioTextField.text
        UserProfileViewController.sharedProfile?.techInterests = techInterestsTextField.text
        Task {
            try await NetworkController.shared.updateProfile(userSecret: User.current!.secret, updatedProfile: UserProfileViewController.sharedProfile!)
        }
        Task {
            do {
                var posts = try await NetworkController.shared.getUserPosts(userSecret: User.current!.secret, userUUID: User.current!.userUUID, pageNumber: 0)
                print(posts)
                try await NetworkController.shared.deletePost(userSecret: User.current!.secret, postid: 525)
                posts =  try await NetworkController.shared.getUserPosts(userSecret: User.current!.secret, userUUID: User.current!.userUUID, pageNumber: 0)
                print(posts)
            } catch {
                print(error.localizedDescription)
            }
        }
        delegate?.didUpdate()
        dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
