//
//  UserProfileViewController.swift
//  techSocialMediaApp
//
//  Created by Dax Gerber on 2/6/24.
//

import UIKit

class UserProfileViewController: UIViewController, UpdateEditProfileViewDelegate {
    
    var networkController = NetworkController.shared
    static var sharedProfile: UserProfile?

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var techInterestsLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            UserProfileViewController.sharedProfile = try await networkController.getUserProfile(userUUID: User.current!.userUUID, userSecret: User.current!.secret)
            userNameLabel.text = (UserProfileViewController.sharedProfile?.firstName ?? "") + " " + (UserProfileViewController.sharedProfile?.lastName ?? "")
            bioLabel.text = UserProfileViewController.sharedProfile?.bio ?? "Hi I am Dax"
            techInterestsLabel.text = UserProfileViewController.sharedProfile?.techInterests ?? "Phones"
        }
        // Do any additional setup after loading the view.
    }
    
    
    @IBSegueAction func updateSegue(_ coder: NSCoder) -> UpdateProfileViewController? {
        let vc = UpdateProfileViewController(coder: coder)
        vc?.delegate = self
        return vc
    }
    
    func didUpdate() {
        bioLabel.text = UserProfileViewController.sharedProfile?.bio
        techInterestsLabel.text = UserProfileViewController.sharedProfile?.techInterests
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
