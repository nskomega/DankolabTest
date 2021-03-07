//
//  ChatViewController.swift
//  DankolabTest
//
//  Created by Mikhail Danilov on 02.03.2021.
//  Copyright © 2021 Om. All rights reserved.
//

import UIKit
import SwiftHEXColors
import RealmSwift

class ChatViewController: UIViewController {
    
    let realm = try! Realm()
    
    @IBOutlet weak var keybordViewButtonCostraint: NSLayoutConstraint!
    let colorWhite: UIColor? = UIColor(hex: 0xFFFFFF)
    let colorBlack: UIColor? = UIColor(hex: 0x000000)
    let colorGray: UIColor? = UIColor(hex: 0xF4F3F3)
    let colorRed: UIColor? = UIColor(hex: 0xE11C28)
    let backColorText: UIColor? = UIColor(hex: 0xD9D8D8)
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBOutlet weak var viewTextFieldMessage: UIView!
    
    @IBOutlet weak var heightTextViewConstraint: NSLayoutConstraint!
    
    var chatsModel: ChatsModel?
    var messages = [ChatMessage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.backgroundColor = colorWhite?.cgColor
        self.navigationController?.navigationBar.layer.shadowColor = colorBlack?.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.38
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.navigationController?.navigationBar.layer.shadowRadius = 7
        
        collectionView.layer.backgroundColor = colorGray?.cgColor
        collectionView.delegate = self
        collectionView.dataSource = self
        
        viewTextFieldMessage.layer.backgroundColor = colorWhite?.cgColor
        
        textView.layer.backgroundColor = colorGray?.cgColor
        textView.layer.shadowColor = colorBlack?.cgColor
        textView.layer.shadowOpacity = 0.5
        textView.layer.shadowOffset = CGSize(width: 0, height: 2)
        textView.layer.shadowRadius = 4
        textView.layer.cornerRadius = 4
        textView.delegate = self
        textView.text = "Введите сообщение..."
        textView.textColor = .lightGray
        
        sendBtn.isEnabled = false
        
        loadChat()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func tapSend(_ sender: Any) {
        
        guard let text = textView.text, !text.isEmpty else { return }
        guard let chatsModel = self.chatsModel else { return }
        
        realm.beginWrite()
        let id = String(arc4random())
        let myMsg = randomBool()
        realm.create(ChatMessage.self, value: [id, chatsModel.id, NSDate(), text, myMsg])
        try! realm.commitWrite()
        textView.text = ""
        heightTextViewConstraint.constant = 30
        
        let workouts = realm.objects(ChatsModel.self).filter("id = %@", chatsModel.id)
        if let workout = workouts.first {
            try! realm.write {
                workout.lastText = text
                workout.updateDate = Date()
            }
        }
        let chatMessage = ChatMessage()
        chatMessage.date = NSDate()
        chatMessage.id = id
        chatMessage.text = text
        chatMessage.myMsg = myMsg
        
        messages.append(chatMessage)
        
        let indexPath = IndexPath(row:messages.count-1, section: 0)
        self.collectionView.insertItems(at: [indexPath])
        scrollToLastItem()
    }
    
    
    func loadChat() {
        messages.removeAll()
        let id = chatsModel?.id ?? "0"
        for item in realm.objects(ChatMessage.self).sorted(byKeyPath: "date").filter("chatModelId == %@" , id) {
            messages.append(item)
        }
        collectionView.reloadData()
        
        let item = self.collectionView(self.collectionView, numberOfItemsInSection: 0) - 1
        let lastItemIndex = IndexPath(item: item, section: 0)
        self.collectionView.scrollToItem(at: lastItemIndex, at: .bottom, animated: true)
        scrollToLastItem()
    }
    
    func randomBool() -> Bool {
        return arc4random_uniform(2) == 0
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if keybordViewButtonCostraint.constant == 0 {
                sendBtn.isEnabled = true
                keybordViewButtonCostraint.constant = -keyboardSize.height
                scrollToLastItem()
            }
        }
        
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if keybordViewButtonCostraint.constant != 0 {
                keybordViewButtonCostraint.constant = 0
                sendBtn.isEnabled = false
            }
        }
    }
    
    func scrollToLastItem() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            let lastSection = self.collectionView.numberOfSections - 1
            let lastRow = self.collectionView.numberOfItems(inSection: lastSection)
            let indexPath = IndexPath(row: lastRow - 1, section: lastSection)
            self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: false)
        }
    }
}

extension ChatViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let _ = textView.text, let font = textView.font else { return  }
        var numLines = (textView.contentSize.height / font.lineHeight)
        
        if numLines > 4 {
            numLines = 4
        }
        
        if numLines == 0 || numLines == 1 {
            heightTextViewConstraint.constant = 30
        } else {
            heightTextViewConstraint.constant = 30 + (numLines - 1 ) * font.lineHeight
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if (textView.text == "Введите сообщение..." && textView.textColor == .lightGray)
        {
            textView.text = ""
            textView.textColor = .black
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if (textView.text == "")
        {
            textView.text = "Введите сообщение..."
            textView.textColor = .lightGray
        }
        textView.resignFirstResponder()
    }
}

extension ChatViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let object = messages[indexPath.row]
        
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "HH:mm"
        let animate = indexPath.row == messages.count-1 ? true : false
        cell.setData(text: object.text, time: formatter1.string(from: object.date as Date), myMsg: object.myMsg, animate: animate)
        
        return cell
    }
}
