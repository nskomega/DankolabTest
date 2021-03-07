//
//  ChatsModel.swift
//  DankolabTest
//
//  Created by Mikhail Danilov on 02/03/2021.
//  Copyright © 2021 Om. All rights reserved.
//

import Foundation
import RealmSwift

class ChatsModel: Object {
    @objc dynamic var id = ""
    @objc dynamic var date = Date()
    @objc dynamic var lastText = ""
    @objc dynamic var updateDate = Date()
}
