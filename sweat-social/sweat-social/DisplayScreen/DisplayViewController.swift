//
//  DisplayViewController.swift
//  sweat-social
//

import UIKit

class DisplayViewController: UIViewController {

    let displayView = DisplayView()
    
    override func loadView() {
        view = displayView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Post Details"
        
        
    }
    
    func loadPostDetails(post: Post) {
        displayView.postImage.loadRemoteImage(from: post.imageRef)
        
        displayView.totalTimeValueLabel.text = "\(post.hours):\(post.mins)"
        displayView.caption.text = post.caption.count == 0 ? "No Caption" : post.caption
        displayView.locationValueLabel.text = post.loc.count == 0 ? "N/A" : post.loc
        
        displayView.messageValueLabel.text = post.exercises
    }
}
