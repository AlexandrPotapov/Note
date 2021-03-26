import Foundation
import CoreData

class DBNotebook: NSObject, Notebook {
    
    private let context: NSManagedObjectContext
    private let request: NSFetchRequest<MONote>
    
    init(context: NSManagedObjectContext) {
        self.context = context
        let sortDescriptor = NSSortDescriptor(key: "dateModify", ascending: true)
        request = NSFetchRequest<MONote>(entityName: "Note")
        request.sortDescriptors = [sortDescriptor]
        
        super.init()
    }
    
    func getList() -> [Note] {
        var result = [Note]()
        
        for mONote in _load() {
            if let note = createNote(from: mONote) {
                result.append(note)
            }
        }
        
        return result
    }
    
    func add(_ note: Note) {
        for mONote in _load() {
            if mONote.uid == note.uid {
                updateMO(mo: mONote, by: note)
                return
            }
        }
        
        let mONote = MONote(context: context)
        updateMO(mo: mONote, by: note)
    }
    
    func remove(with uid: String) {
        for note in _load() {
            if note.uid == uid {
                context.delete(note)
                return
            }
        }
    }
    
    func update(by notes: [Note]) {
        for note in _load() {
            context.delete(note)
        }
        
        for note in notes {
            self.add(note)
        }
    }
    
    func save() {
        context.performAndWait {
            do {
                try context.save()
            } catch let error as NSError {
                print("Error: failed to save to DB: \n\(error)" )
            }
        }
    }
    
    func load() {}
    
    func _load() -> [MONote] {
        return (try? context.fetch(request)) ?? []
    }
    
    private func updateMO(mo: MONote, by note: Note) {
        mo.uid = note.uid
        mo.title = note.title
        mo.content = note.content
        mo.importance = note.importance.rawValue
        mo.color = note.color
        mo.selfDestructionDate = note.selfDestructionDate
        mo.dateModify = Date()
    }
    
    private func createNote(from mONote: MONote) -> Note? {
        guard let uid = mONote.uid,
            let title = mONote.title,
            let content = mONote.content
            else {
                return nil
        }
        
        var importance = Importance.normal
        if let importanceRaw = mONote.importance,
            let importanceSafe = Importance(rawValue: importanceRaw) {
            importance = importanceSafe
        }
        
        
        return Note(uid: uid, title: title, content: content, color: mONote.color ?? "FFFFFFFF" , importance: importance, selfDestructionDate: mONote.selfDestructionDate)
    }
}
