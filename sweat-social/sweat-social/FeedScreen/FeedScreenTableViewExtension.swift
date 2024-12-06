//
//  FeedScreenTableViewExtension.swift
//  sweat-social
//
//  Created by Hagen Zhang on 12/3/24.
//

import UIKit

extension FeedViewController: UITableViewDelegate, UITableViewDataSource{
    // Helps render the Cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    // Sets the label values for each of the Cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewTextsID", for: indexPath) as! PostTableViewCell
        // cell.labelName.text = posts[indexPath.row].name
        // cell.labelEmail.text = posts[indexPath.row].email
        return cell
    }
    
    // Handles clicking on a cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("FeedScreenTableViewExtension - Clicked on a Cell @ indexPath \(indexPath)!")
    }
    
    // Handles swiping on a cell
    // HZ: CURRENTLY PLACEHOLDER CODE, just used to showcase implementation. Not functional!
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = UIContextualAction(style: .destructive, title: "Test") {  (contextualAction, view, boolValue) in
            print("FeedScreenTableViewExtension - trailingSwipeAction detected!")
        }
        item.image = UIImage(named: "deleteIcon")
        
        let swipeActions = UISwipeActionsConfiguration(actions: [item])
        
        return swipeActions
    }
}
