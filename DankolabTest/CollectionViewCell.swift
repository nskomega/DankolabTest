//
//  CollectionViewCell.swift
//  DankolabTest
//
//  Created by Mikhail Danilov on 04.03.2021.
//  Copyright © 2021 Om. All rights reserved.
//

import UIKit
import SwiftHEXColors

class CollectionViewCell: UICollectionViewCell {
    
    let blackColorText: UIColor? = UIColor(hex: 0xD9D8D8)
    let colorBlack: UIColor? = UIColor(hex: 0x000000)
    let colorText: UIColor? = UIColor(hex: 0xFFFFFF)
    
    func setData(text: String, time: String, myMsg: Bool, animate: Bool) {
        
        self.subviews.forEach { $0.removeFromSuperview() }
        
        let content = UIView()
        content.layer.cornerRadius = 4
        content.layer.shadowOffset = CGSize(width: 0, height: 2)
        content.layer.shadowOpacity = 0.5
        content.layer.shadowRadius = 4
        content.layer.shadowColor = colorBlack?.cgColor
        
        let msgLabel = UILabel()
        msgLabel.numberOfLines = 0
        msgLabel.font = msgLabel.font.withSize(15)
        
        let dateLabel = UILabel()
        
        dateLabel.font = dateLabel.font.withSize(11)
        let separator = UIView()
        
        addSubview(separator)
        addSubview(content)
        content.addSubview(msgLabel)
        addSubview(dateLabel)
        
        if myMsg {
            content.backgroundColor = blackColorText
            msgLabel.textAlignment = .right
            msgLabel.textColor = colorText
            dateLabel.textAlignment = .right
        } else {
            content.backgroundColor = UIColor.white
            msgLabel.textAlignment = .left
            msgLabel.textColor = colorBlack
            dateLabel.textAlignment = .left
        }
        
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        separator.topAnchor.constraint(equalTo: topAnchor).isActive = true
        separator.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        separator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        content.translatesAutoresizingMaskIntoConstraints = false
        msgLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        content.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        content.bottomAnchor.constraint(equalTo: bottomAnchor, constant:  -8).isActive = true
        
        msgLabel.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -4).isActive = true
        msgLabel.topAnchor.constraint(equalTo: content.topAnchor, constant: 4).isActive = true
        msgLabel.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width * 0.6).isActive = true
        
        dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: 90).isActive = true
        
        if myMsg {
            content.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
            msgLabel.leftAnchor.constraint(equalTo: content.leftAnchor, constant: 30).isActive = true
            msgLabel.rightAnchor.constraint(equalTo: content.rightAnchor, constant: -8).isActive = true
            dateLabel.rightAnchor.constraint(equalTo: content.leftAnchor, constant: -8).isActive = true
        } else {
            content.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
            msgLabel.leftAnchor.constraint(equalTo: content.leftAnchor, constant: 8).isActive = true
            msgLabel.rightAnchor.constraint(equalTo: content.rightAnchor, constant: -30).isActive = true
            dateLabel.leftAnchor.constraint(equalTo: content.rightAnchor, constant: 8).isActive = true
        }
        
        if animate {
            self.alpha = 0.0
            UIView.animate(withDuration: 1) {
                self.alpha = 1
            }
        }
        
        msgLabel.text = text
        dateLabel.text = time
    }
}
