//
//  SearchScreenViewController.swift
//  sweat-social
//

import UIKit

class SearchScreenViewController: UIViewController {
    
    let searchScreenView = SearchScreenView()
    
    
    override func loadView() {
        view = searchScreenView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search For Users"
        
        searchScreenView.queryButton.addTarget(self, action: #selector(runQuery), for: .touchUpInside)
    }
    
    @objc func runQuery() {
        
    }

}
