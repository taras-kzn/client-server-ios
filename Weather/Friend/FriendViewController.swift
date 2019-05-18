//
//  FriendViewController.swift
//  Weather
//
//  Created by admin on 08/03/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper


class FriendViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var friendServerc = FriendServic()
    var friendsArray = [FriendsArray]()
    var idAdel = ""

    
    
    var myFriend = [
        PersonGroup(photo: UIImage(named: "circles")!,name : "Ахметвалеев Рустем"),
        PersonGroup(photo: UIImage(named: "Image3")!, name: "Ибрагимов Артур"),
        PersonGroup(photo: UIImage(named: "car")!, name: "Зарипоп Руслан"),
        PersonGroup(photo: UIImage(named: "santaKlaus")!, name: "Незамов Дамир")
        
    ]
    
    
    var mapFriends = [String:[PersonGroup]]()
    var sortArray = [String]()
    

    var filterFriend = [PersonGroup]()
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
        mapFriends = map(friends: self.myFriend)
        sortArray = self.mapFriends.keys.sorted()
        
        userDefaulsSave()
        loadStringUserDefauls()
        loadSessionToken()
        print(idAdel)

        friendServerc.loadFriendsData(friends: userID,token: Session.instance.token){ [weak self] friendsArray in
            // сохраняем полученные данные в массиве, чтобы коллекция могла получить к ним доступ
            self?.friendsArray = (friendsArray)
            self?.tableView.reloadData()
            print(friendsArray.first?.lastName)
            print(Session.instance.token)
   
        }
        
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "shouVC"{
            let vc = segue.destination as? PhotoViewController
            if let indexPath = tableView.indexPathForSelectedRow{
                var friend : PersonGroup
                if isFilterFriend{
                    friend = self.filterFriend[indexPath.row]
                } else{
                    let letter = self.sortArray[indexPath.section]
                    let friendLetter = mapFriends[letter]!
                    friend = friendLetter[indexPath.row]
                    
                }
                vc?.photoColection = [friend]
            }

        }
    }
 
}

extension FriendViewController : UITableViewDataSource,UITableViewDelegate{
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        //return mapFriends.keys.count
//
//    }
//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if isFilterFriend{
//            return filterFriend.count
//        }
//        let letter = sortArray[section]
//        let friendLetter = mapFriends[letter]!
//        return friendLetter.count
        return friendsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyFriendCell", for: indexPath) as! FriendTableViewCell
        
//        var friend : PersonGroup
//        if isFilterFriend{
//            friend = filterFriend[indexPath.row]
//        } else{
//            let letter = sortArray[indexPath.section]
//            let friendLetter = mapFriends[letter]!
//            friend = friendLetter[indexPath.row]
//
//        }
//        cell.friendCell.text = friend.name
//        cell.photoCell.image = friend.photo
        cell.photoCell.layer.cornerRadius = 15
        cell.photoCell.layer.masksToBounds = true
        cell.viewPhotoCell.layer.cornerRadius = 20
        cell.viewPhotoCell.layer.shadowOpacity = 0.5
        
        let friends = friendsArray[indexPath.row]
        
        cell.friendCell.text = friends.firstName + " " + friends.lastName
        let queue = DispatchQueue.global(qos: .utility)
        let imageURL = NSURL(string: friends.photoId)
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
    
    func map(friends: [PersonGroup])->[String:[PersonGroup]]{
        var mapFriends = [String:[PersonGroup]]()
       
        
        for friend  in friends{
            
            let firstLetter = String(friend.name.first!)
            var arrayLetter = mapFriends[firstLetter] ?? []
            arrayLetter.append(friend)
            mapFriends[String(firstLetter)] = arrayLetter
        }
        
        return mapFriends
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friend : PersonGroup
        
        if isFilterFriend{
            friend = filterFriend[indexPath.row]
        }else{
            friend = myFriend[indexPath.row]
        }
        
        self.performSegue(withIdentifier: "shouVC", sender: friend)
    }

}

extension FriendViewController : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterSerachText(_searchText: searchController.searchBar.text!)
    }
    
    private func filterSerachText(_searchText:String){
        filterFriend = myFriend.filter({ (friend: PersonGroup) -> Bool in
            return friend.name.lowercased().contains(_searchText.lowercased())
        })
        
        tableView.reloadData()
    }
//    func userDefaulsSave() {
//        UserDefaults.standard.set("3639061", forKey:"idAdel")
//    }
//    private func loadStringUserDefauls() {
//        idAdel = UserDefaults.standard.string(forKey: "idAdel")!
//        print(idAdel)
//    }
//    private func loadSessionToken(){
//        Session.instance.token = KeychainWrapper.standard.string(forKey: "token")!
//    }
   
}

