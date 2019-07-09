//
//  FriendViewController.swift
//  Weather
//
//  Created by admin on 08/03/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import RealmSwift


final class FriendViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var friendServerc = FriendServic()
    var friendsArray = [FriendsArray]()
    var idAdel = ""
    var notif: NotificationToken?
    var mapFriends = [String:[FriendsArray]]()
    var sortArray = [String]()
    var filterFriend = [FriendsArray]()
    let searchController = UISearchController(searchResultsController: nil)
    var searchBarIsEmpety : Bool{
        guard let text = searchController.searchBar.text else {
            return false
        }
        return text.isEmpty
    }
    private var isFilterFriend : Bool {
        return searchController.isActive && !searchBarIsEmpety
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "searh"
        definesPresentationContext = true
        tableView .register(FriendHeader.self, forHeaderFooterViewReuseIdentifier: "header")
        loadDataRealm()

//        friendServerc.loadFriendsData(userId: userID,token: Session.instance.token){ [weak self]  in
//            self?.loadDataRealm()
//            self?.tableView.reloadData()
//
//        }

        mapFriends = map(friends: self.friendsArray)
        sortArray = self.mapFriends.keys.sorted()
        userDefaulsSave()
        loadStringUserDefauls()
        loadSessionToken()
        tableView.reloadData()
       
    }
    
    private func loadDataRealm(){
  
        do{
            let realm = try Realm()
            let friends = realm.objects(FriendsArray.self).filter("uesrIdName == %@","3639061")
            self.friendsArray = Array(friends)
            notif = friends.observe{ [weak self] changes in
                switch changes {
                case .initial:
                    self?.tableView.reloadData()
                case .update(_, let deletions, let insertions, let modifications):
                    self?.tableView.beginUpdates()
                    self?.tableView.performBatchUpdates({self?.tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: (self?.mapFriends.count)!)}),with: .automatic)
                        self?.tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: (self?.mapFriends.count)!)}),with: .automatic)
                        self?.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: (self?.mapFriends.count)!)}),with: .automatic)
                        print(deletions,modifications,insertions)
                    }, completion: {_ in
                        print("update")
                    })
                    //self?.tableView.endUpdates()
                case .error(let error):
                    print(error)
                }
                print("изминения прошли")
            }
        }catch{
            print("error")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "shouVC"{
            let vc = segue.destination as? PhotoViewController
            if let indexPath = tableView.indexPathForSelectedRow{
                var friend : FriendsArray
                if isFilterFriend{
                    friend = self.filterFriend[indexPath.row]
                } else{
                    let letter = self.sortArray[indexPath.section]
                    let friendLetter = mapFriends[letter]!
                    friend = friendLetter[indexPath.row]
                }
                vc?.friendArrayColecction = [friend]
            }
        }
    }
 
}

extension FriendViewController : UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return mapFriends.keys.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFilterFriend{
            return filterFriend.count
        }
        let letter = sortArray[section]
        let friendLetter = mapFriends[letter]!
        print(friendLetter)
        return friendLetter.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyFriendCell", for: indexPath) as! FriendTableViewCell
        var friend : FriendsArray
        if isFilterFriend{
            friend = filterFriend[indexPath.row]
        } else{
            let letter = sortArray[indexPath.section]
            let friendLetter = mapFriends[letter]!
            friend = friendLetter[indexPath.row]
        }
        cell.photoCell.layer.cornerRadius = 15
        cell.photoCell.layer.masksToBounds = true
        cell.viewPhotoCell.layer.cornerRadius = 20
        cell.viewPhotoCell.layer.shadowOpacity = 0.5
        cell.friendCell.text = friend.lastName + " " + friend.firstName
        let queue = DispatchQueue.global(qos: .utility)
        let imageURL = NSURL(string: friend.photoId)
        queue.async {
            if let data = try? Data(contentsOf: imageURL as! URL ){
                DispatchQueue.main.async {
                    cell.photoCell.image = UIImage(data: data)
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! FriendHeader
        let letter = sortArray[section]
        header.label.text = letter
        return header
    }
    
    private func map(friends: [FriendsArray])->[String:[FriendsArray]]{
        
        var mapFriends = [String:[FriendsArray]]()
        for friend  in friends{
            let firstLetter = String(friend.lastName.first!)
            var arrayLetter = mapFriends[firstLetter] ?? []
            arrayLetter.append(friend)
            mapFriends[String(firstLetter)] = arrayLetter
        }
        
        return mapFriends
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let friend : FriendsArray
        if isFilterFriend{
            friend = filterFriend[indexPath.row]
        }else{
            friend = friendsArray[indexPath.row]
        }
        self.performSegue(withIdentifier: "shouVC", sender: friend)
    }

}

extension FriendViewController : UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filterSerachText(_searchText: searchController.searchBar.text!)
    }
    
    private func filterSerachText(_searchText:String){
        
        filterFriend = friendsArray.filter({ (friend: FriendsArray) -> Bool in
            return friend.lastName.lowercased().contains(_searchText.lowercased())
        })        
        tableView.reloadData()
    }

}

