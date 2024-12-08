//
//  SearchScreenView.swift
//  sweat-social
//

import UIKit

class SearchScreenView: UIView {
    
    var queryString: UITextField!
    var queryButton: UIButton!
    var queryResultsTable: UITableView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        setupQueryString()
        setupQueryButton()
        setupQueryResultTable()
        initConstraints()
    }
    
    func setupQueryString() {
        queryString = UITextField()
        queryString.placeholder = "search for users"
        queryString.autocapitalizationType = .none
        queryString.borderStyle = .roundedRect
        queryString.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(queryString)
    }
    
    func setupQueryButton() {
        queryButton = UIButton(type: .roundedRect)
        queryButton.setTitle("search", for: .normal)
        queryButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(queryButton)
    }
    
    func setupQueryResultTable() {
        queryResultsTable = UITableView()
        queryResultsTable.register(ProfileCellView.self, forCellReuseIdentifier: "searchTable")
        queryResultsTable.separatorStyle = .none
        queryResultsTable.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(queryResultsTable)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            queryButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16),
            queryButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -32),
            queryButton.widthAnchor.constraint(equalToConstant: 96),
            
            queryString.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16),
            queryString.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            queryString.trailingAnchor.constraint(equalTo: queryButton.leadingAnchor, constant: -16),
            
            queryResultsTable.topAnchor.constraint(equalTo: queryString.bottomAnchor, constant: 16),
            queryResultsTable.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            queryResultsTable.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -32),
            queryResultsTable.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
