//
//  GroupViewController.swift
//  Weather
//
//  Created by admin on 07/03/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseAuth


final class GroupViewController: UIViewController {
    
    var groupService = GroupService()
    var groupArray = [GroupArray]()
    var token : NotificationToken?
    var myGroup = [AllGroupArray]()

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        
        if segue.identifier == "addGroup"{
            let allGroupController = segue.source as! AllGroupViewController
            if let indexPath = allGroupController.tableView.indexPathForSelectedRow{
                let person: AllGroupArray
                let letter = allGroupController.sections[indexPath.section]
                let groupOnLetter = allGroupController.personInSections[letter] ?? []
                if allGroupController.isFiltering() {
                    person = allGroupController.filterPersons[indexPath.row]
                } else {
                    person = groupOnLetter[indexPath.row]
                }
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
        
    }
    
    @IBAction func logOut(_ sender: Any) {
        do {
            
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        } catch (let error) {
            // 2
            print("Auth sign out failed: \(error)")
        }
    }
    
    func loadDataRealmGroups() {
        
        do{
            let realm = try Realm()
            let grops = realm.objects(GroupArray.self).filter("userIdName == %@", "3639061").sorted(byKeyPath: "gropuName")
            self.groupArray = Array(grops)
            print(realm.configuration.fileURL)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupCell", for: indexPath) as! GroupTableViewCell
        cell.photoCell.layer.cornerRadius = 15
        cell.photoCell.layer.masksToBounds = true
        cell.viewPhotoCell.layer.cornerRadius = 20
        cell.viewPhotoCell.layer.shadowOpacity = 0.5
        let groups = groupArray[indexPath.row]
        cell.groupName.text = groups.gropuName
        var image = [UIImage]()
        let allCgoupImage = DispatchGroup()
        allCgoupImage.enter()
        asyncLoadImage(imageUrl: URL(string: groups.imageGroup)!,
                       runQueue: .global(),
                       complictionQueue: .main) { (result, error) in
                        guard let image1 = result else {return}
                        image.append(image1)
                        allCgoupImage.leave()
        }
        allCgoupImage.notify(queue: .main) {
            cell.photoCell.image = image[0]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete{
            groupArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    private func asyncLoadImage(imageUrl: URL,runQueue: DispatchQueue,complictionQueue: DispatchQueue,complition: @escaping (UIImage?,Error?)-> ()){
        runQueue.async {
            do {
                let data = try Data(contentsOf: imageUrl)
                complictionQueue.async {
                    complition(UIImage(data: data),nil)
                }
            } catch let error {
                complictionQueue.async {
                    complition(nil,error)
                }
            }
        }
    }

}

