//
//  ChatsViewController.swift
//  DankolabTest
//
//  Created by Mikhail Danilov on 02.03.2021.
//  Copyright © 2021 Om. All rights reserved.
//

import UIKit
import SwiftHEXColors
import RealmSwift

class ChatsViewController: UIViewController {
    
    let colorWhite: UIColor? = UIColor(hex: 0xFFFFFF)
    let colorBlack: UIColor? = UIColor(hex: 0x000000)
    
    let realm = try! Realm()
    let results = try! Realm().objects(ChatsModel.self).sorted(byKeyPath: "updateDate", ascending: false)
    
    var notificationToken: NotificationToken?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBAction func addChats(_ sender: Any) {
        add()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.notificationToken = results.observe { (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                self.tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.endUpdates()
            case .error(let err):
                fatalError("\(err)")
            }
        }
        
        self.navigationController?.navigationBar.topItem?.title = "Чаты"
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.backgroundColor = colorWhite?.cgColor
        self.navigationController?.navigationBar.layer.shadowColor = colorBlack?.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.38
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.navigationController?.navigationBar.layer.shadowRadius = 7
        
        if results.isEmpty {
            tableView.isHidden = true
            infoLabel.isHidden = false
        }
    }
}

extension ChatsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        let object = results[indexPath.row]
        
        cell.messageLabel.text = object.lastText
        
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "HH:mm"
        cell.timeLabel.text = formatter1.string(from: object.updateDate as Date)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatsModel = self.results[indexPath.row]
        showChat(chatsModel: chatsModel)
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "", handler: {a,b,c in
            self.realm.beginWrite()
            self.realm.delete(self.results[indexPath.row])
            try! self.realm.commitWrite()
            
            if self.results.isEmpty {
                tableView.isHidden = true
                self.infoLabel.isHidden = false
            } else {
                tableView.isHidden = false
                self.infoLabel.isHidden = true
            }
        })
        deleteAction.image = UIImage(named: "remove")
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    @objc func add() {
        realm.beginWrite()
        let id = String(arc4random())
        //        let id = String(Date().timeIntervalSince1970)
        
        realm.create(ChatsModel.self, value: [id, NSDate()])
        try! realm.commitWrite()
        
        if results.isEmpty {
            tableView.isHidden = true
            infoLabel.isHidden = false
        } else {
            tableView.isHidden = false
            infoLabel.isHidden = true
        }
        
        if results.last != nil {
            showChat(chatsModel: results.first ?? ChatsModel())
        }
    }
    
    func showChat(chatsModel: ChatsModel){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        vc.chatsModel = chatsModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
