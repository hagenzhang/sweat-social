//
//  DisplayView.swift
//  sweat-social
//

import UIKit

class DisplayView: UIView {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let postImage: UIImageView! = UIImageView()
    let caption: UILabel = UILabel()
    
    let totalTimeLabel = UILabel()
    let totalTimeValueLabel = UILabel()
    
    let locationLabel = UILabel()
    let locationValueLabel = UILabel()
    
    let messageLabel = UILabel()
    let messageValueLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupScrollView()
        setupPostImage()
        setupCaption()
        setupTotalTimeRow()
        setupLocationRow()
        setupMessageView()
        initConstraints()
    }
    
    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    func setupPostImage() {
        postImage.contentMode = .scaleToFill
        postImage.clipsToBounds = true
        postImage.layer.cornerRadius = 10
        postImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(postImage)
    }
    
    func setupCaption() {
        caption.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(caption)
    }

    func setupTotalTimeRow() {
        totalTimeLabel.text = "Total Time:"
        totalTimeLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        totalTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(totalTimeLabel)

        totalTimeValueLabel.font = UIFont.systemFont(ofSize: 16)
        totalTimeValueLabel.textColor = .darkGray
        totalTimeValueLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(totalTimeValueLabel)
    }

    func setupLocationRow() {
        locationLabel.text = "Location:"
        locationLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(locationLabel)

        locationValueLabel.font = UIFont.systemFont(ofSize: 16)
        locationValueLabel.textColor = .darkGray
        locationValueLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(locationValueLabel)
    }

    func setupMessageView() {
        messageLabel.text = "Details:"
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(messageLabel)

        messageValueLabel.font = UIFont.systemFont(ofSize: 16)
        messageValueLabel.textColor = .darkGray
        messageValueLabel.numberOfLines = 0
        messageValueLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(messageValueLabel)
    }

    func initConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            postImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
            postImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            postImage.heightAnchor.constraint(equalToConstant: 300),
            postImage.widthAnchor.constraint(equalToConstant: 300),
            
            caption.topAnchor.constraint(equalTo: postImage.bottomAnchor, constant: 16),
            caption.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            totalTimeLabel.topAnchor.constraint(equalTo: caption.bottomAnchor, constant: 16),
            totalTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            totalTimeLabel.widthAnchor.constraint(equalToConstant: 100),
            
            locationLabel.topAnchor.constraint(equalTo: totalTimeLabel.bottomAnchor, constant: 16),
            locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            locationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            messageLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 16),
            messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            messageLabel.widthAnchor.constraint(equalToConstant: 100),

            totalTimeValueLabel.centerYAnchor.constraint(equalTo: totalTimeLabel.centerYAnchor),
            totalTimeValueLabel.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -70),
            totalTimeValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            locationValueLabel.centerYAnchor.constraint(equalTo: locationLabel.centerYAnchor),
            locationValueLabel.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -74),
            locationValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            messageValueLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 8),
            messageValueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            messageValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            messageValueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
