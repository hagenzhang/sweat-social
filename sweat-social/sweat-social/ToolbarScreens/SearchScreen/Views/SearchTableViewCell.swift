//
//  SearchTableViewCell.swift
//  sweat-social
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    var wrapperCellView: UIView!
    var profileImage: UIImageView!
    var usernameLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupWrapperCellView()
        setupProfileImage()
        setupUsernameLabel()
        
        initConstraints()
    }
    
    func setupWrapperCellView(){
        wrapperCellView = UIView()
        wrapperCellView.backgroundColor = .white
        wrapperCellView.layer.cornerRadius = 6.0
        wrapperCellView.layer.shadowColor = UIColor.gray.cgColor
        wrapperCellView.layer.shadowOffset = .zero
        wrapperCellView.layer.shadowRadius = 4.0
        wrapperCellView.layer.shadowOpacity = 0.2
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapperCellView)
    }
    
    func setupProfileImage() {
        profileImage = UIImageView()
        profileImage.contentMode = .scaleToFill
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 12
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(profileImage)
    }
    
    func setupUsernameLabel(){
        usernameLabel = UILabel()
        usernameLabel.font = UIFont.systemFont(ofSize: 18)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(usernameLabel)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            
            profileImage.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 8),
            profileImage.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 8),
            profileImage.centerYAnchor.constraint(equalTo: wrapperCellView.centerYAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 32),
            profileImage.heightAnchor.constraint(equalToConstant: 32),
            
            usernameLabel.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 8),
            usernameLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 12),
            usernameLabel.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -8),
            usernameLabel.heightAnchor.constraint(equalToConstant: 30),
            usernameLabel.centerYAnchor.constraint(equalTo: wrapperCellView.centerYAnchor),
            
            wrapperCellView.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
