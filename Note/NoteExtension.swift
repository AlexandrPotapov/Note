//
//  NoteExtension.swift
//  Note
//
//  Created by lancelap on 07.07.2019.
//  Copyright © 2019 lancelap. All rights reserved.
//

import Foundation

extension Note {
    static func parse(json: [String: Any]) -> Note? {
        guard let uid = json["uid"] as? String,
            let title = json["title"] as? String,
            let content = json["content"] as? String,
            let color = json["color"] as? String,
            let importanceString = json["importance"] as? String,
            let selfDestructionDate = json["selfDestructionDate"] as? String else {
                return nil
        }
        guard let importance = Importance.init(rawValue: importanceString) else { return nil }
        
        let date: Date?
        if selfDestructionDate != "" {
            date = Date(timeIntervalSince1970: Double(selfDestructionDate)!) // TODO: безопасно извлечь опционалл
        } else {
            date = nil
        }
        
        return Note(uid: uid, title: title, content: content, color: color, importance: importance, selfDestructionDate: date )
    }
    
}


extension Note {
    var json: [String : Any] {
        var _json = [String : Any]()
        if color != "FFFFFFFF" && importance != .normal {
            var importance: String {
                switch self.importance {
                    
                case .unImportant:
                    return "unImportant"
                case .normal:
                    return "normal"
                case .important:
                    return "important"
                }
            }
            
            var date = ""
            let timeInterval = selfDestructionDate?.timeIntervalSince1970
            if timeInterval != nil {
                date = String(Double(timeInterval!))
            }

            
            _json = ["uid": uid, "title" : title, "content" : content, "color" : color, "importance" : importance, "selfDestructionDate" : date] as [String : Any]
        }
        
        return _json
    }
}



