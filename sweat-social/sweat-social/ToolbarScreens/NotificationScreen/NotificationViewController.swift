//
//  NotificationViewController.swift
//  sweat-social
//

import UIKit

class NotificationViewController: UIViewController {

    let notificationView = NotificationView()
    var notifications: [String] = []

    override func loadView() {
        view = notificationView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Activity"
        
        notificationView.notificationTable.delegate = self
        notificationView.notificationTable.dataSource = self
    }

}

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notifTable", for: indexPath) as! NotificationTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("NotificationViewController - Clicked on a Cell @ indexPath \(indexPath)!")
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
