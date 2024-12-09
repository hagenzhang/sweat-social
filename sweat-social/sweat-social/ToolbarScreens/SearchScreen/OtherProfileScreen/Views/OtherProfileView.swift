//
//  OtherProfileView.swift
//  sweat-social
//
//  Created by Christine Lee on 12/8/24.
//

import UIKit

class OtherProfileView: UIView {

    var labelName: UILabel!
    var labelEmail: UILabel!
    var labelFollowing: UILabel!
    var labelFollowers: UILabel!
    var avatarImg: UIImageView!
    var followButton: UIButton!
    var separatorLine: UIView!
    var tableViewPosts: UITableView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //setting the background color...
        self.backgroundColor = .white
        
        setupName()
        setupEmail()
        setupFollowing()
        setupFollowers()
        setupAvatarImg()
        setupFollowButton()
        setupSeparatorLine()
        setupTableViewPosts()
        
        initConstraints()
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
    
    func setupFollowButton() {
        followButton = UIButton(type: .roundedRect)
        followButton.setTitle("Follow", for:.normal)
        followButton.backgroundColor = .systemBlue
        followButton.setTitleColor(.white, for: .normal)
        followButton.layer.cornerRadius = 10
        followButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(followButton)
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
            
            followButton.topAnchor.constraint(equalTo: labelFollowers.bottomAnchor, constant: 8),
            followButton.leadingAnchor.constraint(equalTo: labelFollowing.leadingAnchor),
            followButton.trailingAnchor.constraint(equalTo: labelFollowers.trailingAnchor),
            
            separatorLine.topAnchor.constraint(equalTo: followButton.bottomAnchor, constant: 16),
            separatorLine.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            
            tableViewPosts.topAnchor.constraint(equalTo: separatorLine.topAnchor, constant: 8),
            tableViewPosts.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            tableViewPosts.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableViewPosts.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
