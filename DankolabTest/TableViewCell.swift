//
//  TableViewCell.swift
//  DankolabTest
//
//  Created by Mikhail Danilov on 02.03.2021.
//  Copyright © 2021 Om. All rights reserved.
//

import UIKit
import SwiftHEXColors

class TableViewCell: UITableViewCell {
    
    let colorWhite: UIColor? = UIColor(hex: 0xFFFFFF)
    let colorBlack: UIColor? = UIColor(hex: 0x000000)
    
    @IBOutlet weak var viewChat: UIView!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewChat.layer.backgroundColor = colorBlack?.cgColor
        viewChat.layer.cornerRadius = 8
        
        messageLabel.font = UIFont.boldSystemFont(ofSize: 18)
        messageLabel.textColor = .white
        
        timeLabel.font = UIFont.systemFont(ofSize: 13)
        timeLabel.textColor = .white
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
