import Foundation

class FileNotebook: Notebook {
    
    public private(set) var notes = [Note]()
    public func add(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.uid == note.uid }) {
            notes[index] = note
        } else {
            notes.append(note)
        }
    }
    public func remove(with uid: String) {
        for (index, note) in self.notes.enumerated() {
            if note.uid == uid {
                self.notes.remove(at: index)
            }
        }
    }
    func getList() -> [Note] {
        return self.notes
    }
    
    func save() {
        saveToFile()
    }
    
    func load() {
        try? loadFromFile()
    }
    
    public func update(by notes: [Note]) {
        self.notes = notes
    }
    
    public func saveToFile() {
        guard let url = getDirectoryPath() else {
            return
        }
        
        do {
            var data: [[String: Any]] = []
            for note in notes {
                data.append(note.json)
            }
            if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: []),
                let jsonString = String(data: jsonData, encoding: .utf8) {
                try jsonString.write(to: url, atomically: true, encoding: .utf8)
            }
        } catch let error as NSError {
            print("Error: failed to save to file: \n\(error)" )
        }
        
    }
    
    public func loadFromFile() throws {
        guard let url = getDirectoryPath() else {
            return
        }
        
        do {
            let text = try String(contentsOf: url, encoding: .utf8)
            let data = Data(text.utf8)
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                notes = [Note]()
                for json in jsonData {
                    if let note = Note.parse(json: json) {
                        notes.append(note)
                    }
                }
            }
        } catch let error as NSError {
            print("Error: failed to read file: \n\(error)" )
            throw error
        }
        
    }

    private func getDirectoryPath() -> URL? {
        let fileManager = FileManager.default
        guard let directoryPaths = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil}
        
        if !fileManager.fileExists(atPath: directoryPaths.path) {
            do {
                try fileManager.createDirectory(at: directoryPaths, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                print("Error: failed to create directory: \n\(error)" )
            }
        }
        
        return directoryPaths.appendingPathComponent("notes")
            .appendingPathExtension("json")
    }
}


