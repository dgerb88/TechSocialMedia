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
    var postid = 0
    var comments = [Comment]()

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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "editPost", let vc = segue.destination as? EditPostViewController, let post = sender as? Post else { return }
        postid = post.postid
        vc.post = post
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
            posts = try await networkController.getUserPosts(userSecret: User.current!.secret, userUUID: User.current!.userUUID, pageNumber: 0)
            postTableView.reloadData()
        }
    }
    
    func updateLikes(with post: Post) {
        Task {
            let newPost = try await networkController.updateLikes(userSecret: User.current!.secret, postid: post.postid)
            for index in 0..<posts.count {
                if posts[index].postid == newPost.postid {
                    posts[index] = newPost
                }
            }
            postTableView.reloadData()
        }
        
    }
    
    @IBAction func newPostTapped(_ sender: Any) {
        performSegue(withIdentifier: "newPost", sender: sender)
    }
    
    
    func getComments(with postId: Int) {
        Task {
            comments = try await networkController.getComments(userSecret: User.current!.secret, postid: postId, pageNumber: 0)
        }
    }
    
    func editPost(post: Post) {
            for index in 0..<posts.count {
                if posts[index].postid == post.postid {
                    posts[index] = post
                }
            }
            postTableView.reloadData()
    }
    func deletePost(post: Post) {
        for index in 0..<posts.count {
            if posts[index].postid == post.postid {
                posts.remove(at: index)
            }
        }
        postTableView.reloadData()
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
        cell.commentsLabel.text = "\(posts[indexPath.row].numComments)"
        cell.dateLabel.text = posts[indexPath.row].createdDate
        cell.titleLabel.text = posts[indexPath.row].title
        cell.likesNumberLabel.text = String(posts[indexPath.row].likes)
        cell.delegate = self
        cell.selectedPostId = posts[indexPath.row].postid
        cell.post = posts[indexPath.row]
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
    func likeButtonTapped(post: Post) {
        updateLikes(with: post)
    }
    func commentsButtonTapped(post: Post) {
        getComments(with: post.postid)
    }
    func editPostTapped(post: Post) {
        performSegue(withIdentifier: "editPost", sender: post)
    }
    
}

extension UserProfileViewController {
    
    @IBAction func unwindToUserProfileView(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source as! EditPostViewController
        // Use data from the view controller which initiated the unwind segue
        if !sourceViewController.didTapDelete {
            sourceViewController.post?.title = sourceViewController.changeTitleTextField.text ?? ""
            sourceViewController.post?.body = sourceViewController.changeBodyTextfield.text ?? ""
            Task {
                if sourceViewController.post == nil {
                    let newPost = try await NetworkController.shared.createPost(userSecret: User.current!.secret, title: sourceViewController.changeTitleTextField.text ?? "", body: sourceViewController.changeBodyTextfield.text ?? "")
                    self.posts.append(newPost)
                    self.postTableView.reloadData()
                } else {
                    do {
                        try await NetworkController.shared.editPost(userSecret: User.current!.secret, postid: sourceViewController.post!.postid, title: sourceViewController.changeTitleTextField.text ?? "", body: sourceViewController.changeBodyTextfield.text ?? "")
                        sourceViewController.post?.title = sourceViewController.changeTitleTextField.text ?? ""
                        sourceViewController.post?.body = sourceViewController.changeBodyTextfield.text ?? ""
                        let newPost = sourceViewController.post!
                        self.editPost(post: newPost)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        } else {
            deletePost(post: sourceViewController.post!)
        }
    }
    
}
