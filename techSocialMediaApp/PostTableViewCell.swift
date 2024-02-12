//
//  PostTableViewCell.swift
//  techSocialMediaApp
//
//  Created by Dax Gerber on 2/8/24.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likesButton: UIButton!
    @IBOutlet weak var likesNumberLabel: UILabel!
    
    
    var delegate: PostIdDelegate?
    
    var post: Post?
    var selectedPostId = 0
    
    @IBAction func LikesButtonTapped(_ sender: Any) {
        delegate?.likeButtonTapped(post: post!)
    }
    
    
    @IBAction func commentsButtonTapped(_ sender: Any) {
        delegate?.commentsButtonTapped(post: post!)
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        delegate?.editPostTapped(post: post!)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0))
    }
    
}

protocol PostIdDelegate: AnyObject {
    func likeButtonTapped(post: Post)
    func commentsButtonTapped(post: Post)
    func editPostTapped(post: Post)
}
