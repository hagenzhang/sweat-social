//
//  FeedScreenTableViewExtension.swift
//  sweat-social
//

import UIKit

extension FeedViewController: UITableViewDelegate, UITableViewDataSource{
    // Helps render the Cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    // Sets the label values for each of the Cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "posts", for: indexPath) as! PostTableViewCell
        
        cell.caption.text = posts[indexPath.row].caption
        cell.nameLabel.text = posts[indexPath.row].username
        cell.postImage.loadRemoteImage(from: posts[indexPath.row].imageRef)
        
        return cell
    }
    
    // Handles clicking on a cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("FeedScreenTableViewExtension - Clicked on a Cell @ indexPath \(indexPath)!")
        
        let displayView = DisplayViewController()
        
        displayView.loadPostDetails(post: posts[indexPath.row])
        
        // FOR TESTING ONLY, REMOVE WHEN DONE
        FirebasePostUtil().addLikeToPost(postId: posts[indexPath.row].id, username: "admin", completion: { success in
            FirebasePostUtil().getPostLikeCount(postId: self.posts[indexPath.row].id, completion: { likes in
                    print("Post Like Count: \(likes)")
            })
        })

        
        self.navigationController?.pushViewController(displayView, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
