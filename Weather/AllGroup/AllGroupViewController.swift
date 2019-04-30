//
//  AllGroupViewController.swift
//  Weather
//
//  Created by admin on 07/03/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit



class AllGroupViewController: UIViewController {
    
    let searchController = UISearchController (searchResultsController: nil )
    var filterPersons = [ PersonGroup ] ()
    
    var sections: [String] = []
    var personInSections: [String: [PersonGroup]] = [:]
    
    private var selectedPerson: PersonGroup?
 
    @IBOutlet weak var tableView: UITableView!
    
    var persons = [PersonGroup.init(photo: UIImage(named: "circles")!, name:"Спорт и здоровый образ жизни"),PersonGroup.init(photo:UIImage(named: "car")! , name: "Авто любители"),PersonGroup.init(photo: UIImage(named: "kompjuter")!, name: "Уроки по swift"),PersonGroup.init(photo: UIImage(named: "airplane")!, name: "Самолеты")]
    
 
    

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
        
        self.filterPersons = self.persons
        
        
        fillSections()
        fillSectionsWithFriends()
        
        
        
    }
    func  isFiltering () -> Bool {
        return searchController.isActive && !searchBarIsEmpty ()
    }
    
    func  searchBarIsEmpty () -> Bool {
        // Возвращает true, если текст пустой или ноль,
        return searchController.searchBar.text? .isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filterPersons = persons.filter({( person : PersonGroup) -> Bool in
            return person.name.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
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
        let person: PersonGroup
        let letter = self.sections[indexPath.section]
        let groupOnLetter = personInSections[letter] ?? []
        
        if isFiltering() {
            person = filterPersons[indexPath.row]
        } else {
            person = groupOnLetter[indexPath.row]
            
        }
        
        cell.groupName.text = person.name
        cell.photoCell.image = person.photo
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
    // MARK: - UISearchResultsUpdating делегат
    func  updateSearchResults ( for searchController: UISearchController) {
        
        filterContentForSearchText (searchController.searchBar.text!)
    }
  
}

extension AllGroupViewController{
   
  
    func fillSections() {
        sections = Array(Set(persons.map { String(($0.name.first)!) })).sorted()
        
    }
    
   
    
    func fillSectionsWithFriends() {
        self.personInSections.removeAll()
        
        for person in self.persons {
            guard let firstLetter = person.name.first else { continue }
            
            var groups: [PersonGroup] = []
            
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








