//
//  FeedView.swift
//  sweat-social
//

import UIKit
class FeedView: UIView {
    
    var globalFeedButton: UIButton!
    var forYouFeedButton: UIButton!
    
    var toolbar:UIToolbar!
    
    var tableViewPosts: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupButtons()
        setupToolbar()
        setupTableViewPosts()
        initConstraints()
    }
    
    func setupButtons() {
        globalFeedButton = UIButton(type: .system)
        globalFeedButton.setTitle("  Discover  ", for: .normal)
        globalFeedButton.layer.cornerRadius = 12
        globalFeedButton.layer.borderWidth = 1
        globalFeedButton.layer.borderColor = UIColor.black.cgColor
        globalFeedButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(globalFeedButton)
        
        forYouFeedButton = UIButton(type: .system)
        forYouFeedButton.setTitle("  For You  ", for: .normal)
        forYouFeedButton.layer.cornerRadius = 12
        forYouFeedButton.layer.borderWidth = 1
        forYouFeedButton.layer.borderColor = UIColor.black.cgColor
        forYouFeedButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(forYouFeedButton)
    }
    
    
    func setupToolbar(){
        toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.safeAreaLayoutGuide.widthAnchor.hashValue, height: 50))
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(toolbar)
    }
    
    func setupTableViewPosts(){
        tableViewPosts = UITableView()
        tableViewPosts.register(PostTableViewCell.self, forCellReuseIdentifier: "posts")
        tableViewPosts.autoresizingMask = UIView.AutoresizingMask.flexibleHeight;
        tableViewPosts.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewPosts)
    }
    func initConstraints(){
        NSLayoutConstraint.activate([
            globalFeedButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            globalFeedButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 120),
            
            forYouFeedButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            forYouFeedButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -120),
            
            toolbar.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            toolbar.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            
            tableViewPosts.topAnchor.constraint(equalTo: self.globalFeedButton.bottomAnchor, constant: 16),
            tableViewPosts.bottomAnchor.constraint(equalTo: toolbar.topAnchor),
            tableViewPosts.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            tableViewPosts.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

