//
//  GroupViewController.swift
//  Weather
//
//  Created by admin on 07/03/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import RealmSwift



class GroupViewController: UIViewController {
    
    var groupService = GroupService()
    var groupArray = [GroupArray]()
    var token : NotificationToken?
       

    @IBOutlet weak var tableView: UITableView!
    
    var myGroup = [PersonGroup]()
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        if segue.identifier == "addGroup"{
            let allGroupController = segue.source as! AllGroupViewController
            if let indexPath = allGroupController.tableView.indexPathForSelectedRow{
                
                let person: PersonGroup
                let letter = allGroupController.sections[indexPath.section]
                let groupOnLetter = allGroupController.personInSections[letter] ?? []
                
                if allGroupController.isFiltering() {
                    person = allGroupController.filterPersons[indexPath.row]
                } else {
                    person = groupOnLetter[indexPath.row]
                    
                }
                
                //let group = allGroupController.persons[indexPath.row]
                if !myGroup.contains(person){
                    myGroup.append(person)
                    tableView.reloadData()
               }
                
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        userDefaulsSave()
        loadStringUserDefauls()
        loadSessionToken()
        
        loadDataRealmGroups()
        tableView.reloadData()
        
       
//        groupService.loadGroupData(idUser: userID, token: Session.instance.token, completion: { [weak self] groupArray in
//            // сохраняем полученные данные в массиве, чтобы коллекция могла получить к ним доступ
//            //self?.groupArray = (groupArray)
//            self?.loadDataRealmGroups()
//            self?.tableView.reloadData()
//
//
//        })
        
        
        
    }
    func loadDataRealmGroups() {
        do{
            let realm = try Realm()
            let grops = realm.objects(GroupArray.self).filter("userIdName == %@", "3639061").sorted(byKeyPath: "gropuName")
            self.groupArray = Array(grops)
            token = grops.observe{ [weak self] changes in
                switch changes {
                    
                case .initial:
                    self?.tableView.reloadData()
                case .update(_, let deletions, let insertions, let modifications):
                    self?.tableView.beginUpdates()
                    self?.tableView.performBatchUpdates({self?.tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: (self?.groupArray.count)!)}),with: .automatic)
                        self?.tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: self!.groupArray.count)}),with: .automatic)
                        self?.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: self!.groupArray.count)}),with: .automatic)
                        print(deletions,modifications,insertions)
                    
                    }, completion: {_ in
                        print("update")
                    })
                    self?.tableView.endUpdates()
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


extension GroupViewController : UITableViewDataSource{
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupCell", for: indexPath) as! GroupTableViewCell
        //let group = myGroup[indexPath.row]
//        cell.groupName.text = group.name
//        cell.photoCell.image = group.photo
        cell.photoCell.layer.cornerRadius = 15
        cell.photoCell.layer.masksToBounds = true
        cell.viewPhotoCell.layer.cornerRadius = 20
        cell.viewPhotoCell.layer.shadowOpacity = 0.5
        
        let groups = groupArray[indexPath.row]
        cell.groupName.text = groups.gropuName
        let queue = DispatchQueue.global(qos: .utility)
        let imageURL = NSURL(string: groups.imageGroup)
        queue.async {
            if let data = try? Data(contentsOf: imageURL as! URL ){
                DispatchQueue.main.async {
                    cell.photoCell.image = UIImage(data: data)
                    
                }
            }
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete{
            groupArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }
  
 
   
}

