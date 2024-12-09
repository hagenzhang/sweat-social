//
//  SearchScreenViewController.swift
//  sweat-social
//

import UIKit

class SearchScreenViewController: UIViewController {
    
    let searchScreenView = SearchScreenView()
    var queryResult: [User] = []

    override func loadView() {
        view = searchScreenView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search For Users"
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
        
        searchScreenView.queryResultsTable.delegate = self
        searchScreenView.queryResultsTable.dataSource = self
        
        searchScreenView.queryButton.addTarget(self, action: #selector(runQuery), for: .touchUpInside)
        
        let feed = UIBarButtonItem(image: UIImage(systemName: "dumbbell")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        ), style: .plain, target: self, action: #selector(toFeedScreen))
        let create = UIBarButtonItem(image: UIImage(systemName: "plus.circle.fill")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        ), style: .plain, target: self, action: #selector(createPost))
        let profile = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle.fill")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        ), style: .plain, target: self,  action: #selector(toProfileScreen))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        searchScreenView.toolbar.items = [feed, flexibleSpace, create, flexibleSpace, profile]
    }
    
    @objc func toFeedScreen() {
        print("")
        let feedController = FeedViewController()
        navigationController?.pushViewController(feedController, animated: true)
    }
    
    @objc func toProfileScreen() {
        FirebaseUserUtil().getProfileInformation(username: (FirebaseUserUtil.currentUser?.displayName)! , completion: { profile in
            print("FeedViewController - Going to Profile Screen")
            
            if let profile = profile {
                print("FeedViewController - Successful Profile Define: \(profile)")
                
                let profileViewController = ProfileViewController()
                
                // Unpack all of the Profile Info so it renders in the View.
                profileViewController.unpackProfile(receivedPackage: profile)
                
                // Navigate to the ProfileView.
                self.navigationController?.pushViewController(profileViewController, animated: true)
                print("") // spacer in logs
                
            } else {
                print("FeedViewController - Failed to Define Profile!")
            }
        })
    }
    
    @objc func createPost() {
        print("") // spacer in logs
        let createViewController = CreateViewController()
        self.navigationController?.pushViewController(createViewController, animated: true)
    }
    
    
    @objc func toSearchScreen() {
        print("") // spacer in logs
        let searchScreenController = SearchScreenViewController()
        self.navigationController?.pushViewController(searchScreenController, animated: true)
    }
    
    
    
    @objc func runQuery() {
        if let queryString = searchScreenView.queryString.text {
            
            FirebaseUserUtil().findUsersFromQuery(query: queryString, completion: { user in
                self.queryResult = user
                self.searchScreenView.queryResultsTable.reloadData()
            })
        } else {
            print("SearchScreenViewController: tried to run empty query")
        }
    }
    
    @objc func hideKeyboardOnTap(){
        view.endEditing(true)
    }

}

extension SearchScreenViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queryResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchTable", for: indexPath) as! SearchTableViewCell
        
        cell.profileImage.loadRemoteImage(from: self.queryResult[indexPath.row].photoURL)
        cell.usernameLabel.text = self.queryResult[indexPath.row].username
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("SearchScreenViewController - Clicked on a Cell @ indexPath \(indexPath)!")

        FirebaseUserUtil().getProfileInformation(username: self.queryResult[indexPath.row].username , completion: { profile in
            print("SearchScreenViewController - Going to Profile Screen")
            
            if let profile = profile {
                print("SearchScreenViewController - Successful Profile Define: \(profile)")
                
                let profileViewController = ProfileViewController()
                
                // Unpack all of the Profile Info so it renders in the View.
                profileViewController.unpackProfile(receivedPackage: profile)
                
                // Navigate to the ProfileView.
                self.navigationController?.pushViewController(profileViewController, animated: true)
                
            } else {
                print("SearchScreenViewController - Failed to Define Profile!")
            }
            
            print("") // spacer in logs
        })
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
