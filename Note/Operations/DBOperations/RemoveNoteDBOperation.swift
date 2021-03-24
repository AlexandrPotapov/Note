//
//  RemoveNoteDBOperation.swift
//  Note
//
//  Created by Александр on 21.02.2021.
//  Copyright © 2021 lancelap. All rights reserved.
//

import Foundation

class RemoveNoteDBOperation: BaseDBOperation {
    private let note: Note
    
    init(note: Note, notebook: Notebook) {
        self.note = note
        super.init(notebook: notebook)
    }
    
    override func main() {
        notebook.remove(with: note.uid)
        notebook.save()
        finish()
    }
}

