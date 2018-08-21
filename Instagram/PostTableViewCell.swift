//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by 浅尾栄志 on 2018/08/19.
//  Copyright © 2018年 jirokirameki. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentsLabel: UILabel!
    
//    var commentArray: [CommentData] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.commentsLabel.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setPostData(_ postData: PostData) {
        self.postImageView.image = postData.image
        self.captionLabel.text = "\(postData.name!) : \(postData.caption!)"
                
        // 初期化
        self.commentsLabel.text = ""
        var i = 0
        
        while i < postData.comments.count {
            self.commentsLabel.text = self.commentsLabel.text! + "\n\(postData.comments[i].name!) : \(postData.comments[i].comment!)"
            i += 1
        }

        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: postData.date!)
        self.dateLabel.text = dateString
        
        if postData.isLiked {
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        } else {
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
    }
}
