//
//  PostTableViewCell.swift
//  sweat-social
//

import UIKit
import SwiftUI

class PostTableViewCell: UITableViewCell {
    
    var wrapperCellView: UIView!
    
    // above the image,
    var profileImage: UIImageView!
    var nameLabel: UILabel!
    
    // handles the caption section
    var likedSymbol: UIImageView!
    var caption: UITextView!
    
    // temp objects TODO
    var tempRect: UIImageView!
    var exerciseTable: PostExerciseTable!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupWrapperCellView()
        setupProfileImage()
        setupNameLabel()
        
        setupLikeSymbol()
        setupCaption()
        
        tempRect = UIImageView(image: UIImage(systemName: "square.fill"))
        tempRect.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(tempRect)
        
        initConstraints()
    }
    
    func setupWrapperCellView(){
        wrapperCellView = UITableViewCell()
        wrapperCellView.backgroundColor = .white
        wrapperCellView.layer.cornerRadius = 6.0
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapperCellView)
    }
    
    func setupProfileImage() {
        profileImage = UIImageView()
        profileImage.image = UIImage(systemName: "person.circle")
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(profileImage)
    }
    
    func setupNameLabel() {
        nameLabel = UILabel()
        nameLabel.text = "placeholder name"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // func setupPostImage() { }

    func setupLikeSymbol() {
        likedSymbol = UIImageView(image: UIImage(systemName: "heart.fill"))
        likedSymbol.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(likedSymbol)
    }
    
    func setupCaption() {
        caption = UITextView()
        
        caption.text = "This is going to represent a really long caption! I'm sort of curious how it well " +
            "render and fare, plus some people loooove to write a whole bunch down here so it might be nice " +
            "to see if it can handle such a load. Obviously this is a placeholder."
        
        caption.textColor = .black
        caption.font = caption.font?.withSize(12)
        caption.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(caption)
    }
    
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            profileImage.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 5),
            profileImage.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 5),
            profileImage.heightAnchor.constraint(equalToConstant: 20),
            
            nameLabel.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 5),
            
            // stand-in for where the post photo will go
            tempRect.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 5),
            tempRect.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor),
            tempRect.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor),
            
            likedSymbol.topAnchor.constraint(equalTo: tempRect.bottomAnchor, constant: 5),
            likedSymbol.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 5),
            likedSymbol.heightAnchor.constraint(equalToConstant: 20),
            
            caption.topAnchor.constraint(equalTo: likedSymbol.bottomAnchor, constant: 5),
            caption.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 5),
            caption.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -5),
        ])
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
