//
//  FeedView.swift
//  sweat-social
//

import UIKit
class FeedView: UIView {
    var toolbar:UIToolbar!
    
    var tableViewPosts: UITableView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupToolbar()
        setupTableViewPosts()
        initConstraints()
    }
    
    func setupToolbar(){
        toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.safeAreaLayoutGuide.widthAnchor.hashValue, height: 50))
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(toolbar)
    }
    
    func setupTableViewPosts(){
        tableViewPosts = UITableView()
        tableViewPosts.register(PostTableViewCell.self, forCellReuseIdentifier: "posts")
        tableViewPosts.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewPosts)
    }
    func initConstraints(){
        NSLayoutConstraint.activate([
            toolbar.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            toolbar.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            
            tableViewPosts.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 32),
            tableViewPosts.bottomAnchor.constraint(equalTo: toolbar.topAnchor),
            tableViewPosts.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            tableViewPosts.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

