//
//  ProfileView.swift
//  sweat-social
//

import UIKit

class ProfileView: UIView {

    var labelName: UILabel!
    var labelEmail: UILabel!
    var labelFollowing: UILabel!
    var labelFollowers: UILabel!
    var avatarImg: UIImageView!
    var separatorLine: UIView!
    var tableViewPosts: UITableView!
    
    var toolbar:UIToolbar!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //setting the background color...
        self.backgroundColor = .white
        
        setupName()
        setupEmail()
        setupFollowing()
        setupFollowers()
        setupAvatarImg()
        setupSeparatorLine()
        setupTableViewPosts()
        setupToolbar()
        
        initConstraints()
    }
    
    func setupToolbar(){
        toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.safeAreaLayoutGuide.widthAnchor.hashValue, height: 50))
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(toolbar)
    }
    func setupAvatarImg() {
        avatarImg = UIImageView()
        avatarImg.contentMode = .scaleToFill
        avatarImg.clipsToBounds = true
        avatarImg.layer.cornerRadius = 10
        avatarImg.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(avatarImg)
    }
    func setupName() {
        labelName = UILabel()
        labelName.textAlignment = .center
        labelName.font = UIFont.boldSystemFont(ofSize: 24)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelName)
    }
    func setupEmail() {
        labelEmail = UILabel()
        labelEmail.textAlignment = .center
        labelEmail.font = UIFont.systemFont(ofSize: 20)
        labelEmail.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelEmail)
    }
    func setupFollowing() { // could make this a button to display
        labelFollowing = UILabel()
        labelFollowing.textAlignment = .left
        labelFollowing.font = UIFont.systemFont(ofSize: 16)
        labelFollowing.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelFollowing)
    }
    func setupFollowers() {
        labelFollowers = UILabel()
        labelFollowers.textAlignment = .right
        labelFollowers.font = UIFont.systemFont(ofSize: 16)
        labelFollowers.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelFollowers)
    }
    func setupSeparatorLine() {
        separatorLine = UIView()
        separatorLine.backgroundColor = .lightGray
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(separatorLine)
    }
    func setupTableViewPosts(){
        tableViewPosts = UITableView()
        tableViewPosts.register(ProfileCellView.self, forCellReuseIdentifier: "postTable")
        tableViewPosts.separatorStyle = .none
        tableViewPosts.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewPosts)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            avatarImg.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16),
            avatarImg.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            avatarImg.widthAnchor.constraint(equalToConstant: 75),
            avatarImg.heightAnchor.constraint(equalToConstant: 75),

            labelName.leadingAnchor.constraint(equalTo: avatarImg.trailingAnchor, constant: 16),
            labelName.topAnchor.constraint(equalTo: avatarImg.topAnchor),
            labelName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),

            labelEmail.leadingAnchor.constraint(equalTo: avatarImg.trailingAnchor, constant: 16),
            labelEmail.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 4),
            labelEmail.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            // on the left
            labelFollowing.leadingAnchor.constraint(equalTo: avatarImg.trailingAnchor, constant: 64),
            labelFollowing.topAnchor.constraint(equalTo: labelEmail.bottomAnchor, constant: 4),
            
            // on the rights
            labelFollowers.leadingAnchor.constraint(equalTo: labelFollowing.trailingAnchor, constant: 4),
            labelFollowers.topAnchor.constraint(equalTo: labelEmail.bottomAnchor, constant: 4),
            labelFollowers.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -64),
            
            separatorLine.topAnchor.constraint(equalTo: avatarImg.bottomAnchor, constant: 16),
            separatorLine.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            
            tableViewPosts.topAnchor.constraint(equalTo: separatorLine.topAnchor, constant: 8),
            tableViewPosts.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            tableViewPosts.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableViewPosts.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            toolbar.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            toolbar.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

