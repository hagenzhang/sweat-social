//
//  DisplayViewController.swift
//  sweat-social
//

import UIKit

class DisplayViewController: UIViewController {

    let displayView = DisplayView()
    
    var currentPost: Post?
    
    override func loadView() {
        view = displayView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayView.likeButton.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)
        
        view.backgroundColor = .white
        title = "Post Details"
    }
    
    @objc func likeButtonPressed() {
        FirebasePostUtil().didUserLikePost(postId: self.currentPost!.id, username: FirebaseUserUtil.currentUser!.displayName!, completion: { liked in
            // User has already liked this post (now we unlike the post)
            if liked {
                self.displayView.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                
                FirebasePostUtil().removeLikeFromPost(postId: self.currentPost!.id, username: FirebaseUserUtil.currentUser!.displayName!, completion: { done in
                    if done {
                        FirebasePostUtil().getPostLikeCount(postId: self.currentPost!.id, completion: { likes in
                            self.displayView.likedCountLabel.text = "\(likes)"
                        })
                    }
                })
            
            // User hasn't liked post yet (now we like the post)
            } else {
                self.displayView.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                FirebasePostUtil().addLikeToPost(postId: self.currentPost!.id, username: FirebaseUserUtil.currentUser!.displayName!, completion: { done in
                    if done {
                        FirebasePostUtil().getPostLikeCount(postId: self.currentPost!.id, completion: { likes in
                            self.displayView.likedCountLabel.text = "\(likes)"
                        })
                    }
                })
            }
        })
        

    }
    
    func loadPostDetails(post: Post) {
        self.currentPost = post
        
        displayView.postImage.loadRemoteImage(from: post.imageRef)
        
        FirebasePostUtil().didUserLikePost(postId: post.id, username: FirebaseUserUtil.currentUser!.displayName!, completion: { liked in
            if liked {
                self.displayView.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            } else {
                self.displayView.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        })
        
        FirebasePostUtil().getPostLikeCount(postId: post.id, completion: { likes in
            self.displayView.likedCountLabel.text = "\(likes)"
        })
        
        displayView.totalTimeValueLabel.text = "\(post.hours):\(post.mins)"
        displayView.caption.text = post.caption.count == 0 ? "No Caption" : post.caption
        displayView.locationValueLabel.text = post.loc.count == 0 ? "N/A" : post.loc
        
        displayView.messageValueLabel.text = post.exercises
    }
}
