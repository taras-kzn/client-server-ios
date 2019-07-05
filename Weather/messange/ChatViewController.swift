//
//  ChatViewController.swift
//  Weather
//
//  Created by admin on 30/05/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Firebase

class ChatViewController: UIViewController,UITextFieldDelegate{
    

    var docRef: DocumentReference!
    var coll = Firestore.firestore()
    var textLabel = [String]()
    
    @IBOutlet weak var messTextFildView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.translatesAutoresizingMaskIntoConstraints = false
        messTextFildView.layer.cornerRadius = 10
        
        docRef = coll.collection("userMessage").document("meesange")
        
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { (nc) in
            self.view.frame.origin.y = -200
            
            
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { (nc) in
            self.view.frame.origin.y = 0.0
        }
        

        tableView.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "Chat")

    
    }
    @IBAction func pushBuut(_ sender: Any) {
        guard let messText = messTextFildView.text, !messText.isEmpty else {
            return
        }
        guard let data = messTextFildView.text, !data.isEmpty else {return}
        print(data)
        docRef = coll.collection("messangUser").addDocument(data: ["wwww":"23456","messange" : messText, ]) {error in
            if let err = error {
                print("Ошибка: \(err)")
            } else {
                print("успешно добавилось: \(self.docRef!.documentID)")
            }
        }
        self.messTextFildView.resignFirstResponder()
        
        
        coll.collection("messangUser").getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var i=0;
                for document in querySnapshot!.documents {
                    i=i+1;
                    if (self.docRef!.documentID == document.documentID){
                        print("\(document.documentID) => \(document.data())")
                        var nameDate = document.data()["messange"] as? String ?? ""
                        self.textLabel.append(nameDate) //TODO
                   }
                    
                    
                }
                self.tableView.reloadData()
            }
        }
//        docRef.getDocument { (docSnapshot, error) in
//            guard let document = docSnapshot, document.exists else {return}
//            for document in docSnapshot!.documents {
//                print("\(document.documentID) => \(document.data())")
//            }
//            let myData = document.data()
//            print(myData)
//
//            let nameDate = myData!["messange"] as? String ?? ""
//
//
//            self.textLabel.append("\(nameDate)")
//            self.tableView.reloadData()
//        }
    }
    


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.messTextFildView.resignFirstResponder()
    }


}
extension ChatViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textLabel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Chat", for: indexPath) as! ChatTableViewCell
        var mess = textLabel[indexPath.row]
        cell.messangeLabel.text = mess
        cell.messangeLabel.layer.cornerRadius = 10
        cell.messangeLabel.layer.masksToBounds = true
        cell.mesangeView.layer.cornerRadius = 15
        cell.mesangeView.layer.shadowOpacity = 0.5
        return cell

    }
    
    
    
}
