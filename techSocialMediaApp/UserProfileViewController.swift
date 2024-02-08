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
    
    var posts = [Post]()

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var techInterestsLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    @IBOutlet weak var postTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            UserProfileViewController.sharedProfile = try await networkController.getUserProfile(userUUID: User.current!.userUUID, userSecret: User.current!.secret)
            userNameLabel.text = (UserProfileViewController.sharedProfile?.firstName ?? "") + " " + (UserProfileViewController.sharedProfile?.lastName ?? "")
            bioLabel.text = UserProfileViewController.sharedProfile?.bio ?? "Hi I am Dax"
            techInterestsLabel.text = UserProfileViewController.sharedProfile?.techInterests ?? "Phones"
        }
        fetchPosts()
        postTableView.dataSource = self
        postTableView.delegate = self 
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
    func fetchPosts() {
        Task {
            posts = try await networkController.getPosts(userSecret: User.current!.secret, pageNumber: 0)
            postTableView.reloadData()
        }
    }
    
    func updateLikes(with postid: Int) {
        Task {
            try await networkController.updateLikes(userSecret: User.current!.secret ,postid: postid )
            postTableView.reloadData()
        }
    }
    func getComments(with postId: Int) {
        Task {
            try await networkController.getComments(userSecret: User.current!.secret, postid: postId, pageNumber: 0)
            postTableView.reloadData()
        }
    }
    
}
extension UserProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "post", for: indexPath) as! PostTableViewCell
        
        cell.authorLabel.text = posts[indexPath.row].authorUserName
        cell.bodyLabel.text = posts[indexPath.row].body
        cell.commentsLabel.text = "Comments \(posts[indexPath.row].numComments)"
        cell.dateLabel.text = posts[indexPath.row].createdDate
        cell.titleLabel.text = posts[indexPath.row].title
        cell.likesNumberLabel.text = String(posts[indexPath.row].likes)
        cell.delegate = self
        // Configure the cell...

        return cell
    }

    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension UserProfileViewController: PostIdDelegate {
    func likeButtonTapped(postid: Int) {
        updateLikes(with: postid)
    }
    func commentsButtonTapped(postid: Int) {
        <#code#>
    }
    
}
