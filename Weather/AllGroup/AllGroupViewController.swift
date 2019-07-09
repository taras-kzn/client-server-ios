//
//  AllGroupViewController.swift
//  Weather
//
//  Created by admin on 07/03/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseAuth



final class AllGroupViewController: UIViewController {
    
    var notifAllGroups: NotificationToken?
    private var allGroupService = AllGroupService()
    private var allGroupArray = [AllGroupArray](){
        willSet{
            tableView.reloadData()
        }
    }
    private let searchController = UISearchController (searchResultsController: nil )
    var filterPersons = [ AllGroupArray ] ()
    var sections: [String] = []
    var personInSections: [String: [AllGroupArray]] = [:]
    private var selectedPerson: AllGroupArray?
 
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableHeaderView = searchController.searchBar
        tableView .register(HeaderGroup.self, forHeaderFooterViewReuseIdentifier: "header")
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск групп"
        
        definesPresentationContext = true
        
        userDefaulsSave()
        loadStringUserDefauls()
        loadSessionToken()
        loadDataRealmAllGroups()
        tableView.reloadData()
        fillSections()
        fillSectionsWithFriends()
        self.filterPersons = self.allGroupArray
        
//        allGroupService.loadAllGroupData(token: Session.instance.token) { [weak self] in
//
////            self?.loadDataRealmAllGroups()
////            self?.tableView.reloadData()
//
//        }
    
    }
    
    func  isFiltering () -> Bool {
        return searchController.isActive && !searchBarIsEmpty ()
    }
    
    private func  searchBarIsEmpty () -> Bool {
        // Возвращает true, если текст пустой или ноль,
        return searchController.searchBar.text? .isEmpty ?? true
    }
    
    private func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filterPersons = allGroupArray.filter({( person : AllGroupArray) -> Bool in
            return person.allGroupName.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    private func loadDataRealmAllGroups() {
        
        do{
            let realm = try Realm()
            let grops = realm.objects(AllGroupArray.self)
            self.allGroupArray = Array(grops)
            notifAllGroups = grops.observe{ [weak self] changes in
                switch changes {
                case .initial:
                    self?.tableView.reloadData()
                case .update(_, let deletions, let insertions, let modifications):
                    self?.tableView.beginUpdates()
                    self?.tableView.performBatchUpdates({self?.tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: (self?.allGroupArray.count)!)}),with: .automatic)
                        self?.tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: self!.allGroupArray.count)}),with: .automatic)
                        self?.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: self!.allGroupArray.count)}),with: .automatic)
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
    
}

extension AllGroupViewController : UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        let letter = self.sections[section]
        let groupOnLetter = personInSections[letter] ?? []
        if isFiltering() {
          return filterPersons.count
        }
        
        return groupOnLetter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! AllGroupViewCell
        let person: AllGroupArray
        let letter = self.sections[indexPath.section]
        let groupOnLetter = personInSections[letter] ?? []
        if isFiltering() {
            person = filterPersons[indexPath.row]
        } else {
            person = groupOnLetter[indexPath.row]
        }
        cell.groupName.text = person.allGroupName
        let queue = DispatchQueue.global(qos: .utility)
        let imageURL = NSURL(string: person.allGroupImage)
        queue.async {
            if let data = try? Data(contentsOf: imageURL as! URL ){
                DispatchQueue.main.async {
                    cell.photoCell.image = UIImage(data: data)
                }
            }
        }
        cell.photoCell.layer.cornerRadius = 15
        cell.photoCell.layer.masksToBounds = true
        cell.viewPhotoCell.layer.cornerRadius = 20
        cell.viewPhotoCell.layer.shadowOpacity = 0.5
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! HeaderGroup
             header.label.text = self.sections[section]
 
        return header
    }

}

extension  AllGroupViewController : UISearchResultsUpdating  {
    
    func  updateSearchResults ( for searchController: UISearchController) {
        
        filterContentForSearchText (searchController.searchBar.text!)
    }
  
}

extension AllGroupViewController{
   
    private func fillSections() {
        sections = Array(Set(allGroupArray.map { String(($0.allGroupName.first)!) })).sorted()
    }

    private func fillSectionsWithFriends() {
        
        self.personInSections.removeAll()
        
        for person in self.allGroupArray {
            guard let firstLetter = person.allGroupName.first else { continue }
            var groups: [AllGroupArray] = []
            
            if let personInSections = self.personInSections[String(firstLetter)] {
                groups.append(contentsOf: personInSections)
            }
            
            groups.append(person)
            self.personInSections[String(firstLetter)] = groups
            print("\(personInSections)")
        }
        self.tableView.reloadData()
    }
}








