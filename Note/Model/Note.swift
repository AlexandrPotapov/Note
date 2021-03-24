//
//  Note.swift
//  Note
//
//  Created by lancelap on 07.07.2019.
//  Copyright © 2019 lancelap. All rights reserved.
//

enum Importance : String {
    case unImportant
    case normal
    case important
}

import Foundation

public struct Note {
    let uid: String
    let title: String
    let content: String
    let color: String
    let importance: Importance
    let selfDestructionDate: Date?
    
    init(uid: String, title: String, content: String, color: String, importance: Importance, selfDestructionDate: Date?) {
        self.uid = uid
        self.title = title
        self.content = content
        self.color = color
        self.importance = importance
        self.selfDestructionDate = selfDestructionDate
    }
    
    init(title: String, content: String, importance: Importance) {
        uid = UUID().uuidString
        self.title = title
        self.content = content
        color = "FFFFFFFF" // белый цвет по умолчанию
        self.importance = importance
        selfDestructionDate = nil
    }
}

