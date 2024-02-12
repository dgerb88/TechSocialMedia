//
//  OthersPostsTableViewController.swift
//  techSocialMediaApp
//
//  Created by Dax Gerber on 2/12/24.
//

import UIKit

class OthersPostsTableViewController: UITableViewController {
    
    var posts = [Post]()
    var networkController = NetworkController.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPosts()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func fetchPosts() {
        Task {
            do {
                posts = try await networkController.getPosts(userSecret: User.current!.secret, pageNumber: 0)
                tableView.reloadData()
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "post", for: indexPath) as! PostTableViewCell
        cell.authorLabel.text = posts[indexPath.row].authorUserName
        cell.bodyLabel.text = posts[indexPath.row].body
        cell.commentsLabel.text = "\(posts[indexPath.row].numComments)"
        cell.dateLabel.text = posts[indexPath.row].createdDate
        cell.titleLabel.text = posts[indexPath.row].title
        cell.likesNumberLabel.text = String(posts[indexPath.row].likes)
        cell.post = posts[indexPath.row]
        cell.delegate = self
        // Configure the cell...

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func updateLikes(with post: Post) {
        Task {
            let newPost = try await networkController.updateLikes(userSecret: User.current!.secret, postid: post.postid)
            for index in 0..<posts.count {
                if posts[index].postid == newPost.postid {
                    posts[index] = newPost
                }
            }
            tableView.reloadData()
        }
        
    }

}

extension OthersPostsTableViewController: PostIdDelegate {
    func likeButtonTapped(post: Post) {
        updateLikes(with: post)
    }
    func commentsButtonTapped(post: Post) {
        //Did not actually do
    }
    func editPostTapped(post: Post) {
        //Cannot edit other people's posts
    }
}
