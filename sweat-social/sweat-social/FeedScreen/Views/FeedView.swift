//
//  FeedView.swift
//  sweat-social
//

import UIKit

class FeedView: UIView {
    var toolbar:UIToolbar!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupToolbar()
        initConstraints()
    }
    
    func setupToolbar(){
        toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.safeAreaLayoutGuide.widthAnchor.hashValue, height: 50))
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(toolbar)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            toolbar.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            toolbar.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

