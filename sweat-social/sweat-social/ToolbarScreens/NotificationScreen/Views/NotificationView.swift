//
//  NotificationView.swift
//  sweat-social
//

import UIKit

class NotificationView: UIView {

    var notificationTable: UITableView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        setupQueryResultTable()
        initConstraints()
    }
    
    func setupQueryResultTable() {
        notificationTable = UITableView()
        notificationTable.register(NotificationTableViewCell.self, forCellReuseIdentifier: "notifTable")
        notificationTable.separatorStyle = .none
        notificationTable.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(notificationTable)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
