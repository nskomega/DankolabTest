//
//  ChatMessage.swift
//  DankolabTest
//
//  Created by Mikhail Danilov on 04.03.2021.
//  Copyright © 2021 Om. All rights reserved.
//

import Foundation
import RealmSwift

class ChatMessage: Object {
    @objc dynamic var id = ""
    @objc dynamic var chatModelId = ""
    @objc dynamic var date = NSDate()
    @objc dynamic var text = ""
    @objc dynamic var myMsg = true
}
