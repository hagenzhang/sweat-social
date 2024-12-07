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
        
        cell.caption.text = posts[indexPath.row].exercises
        cell.nameLabel.text = posts[indexPath.row].username
        
        
        return cell
    }
    
    // Handles clicking on a cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("FeedScreenTableViewExtension - Clicked on a Cell @ indexPath \(indexPath)!")
    }
    
}
