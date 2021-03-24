//
//  LoadNotesDBOperation.swift
//  Note
//
//  Created by Александр on 21.02.2021.
//  Copyright © 2021 lancelap. All rights reserved.
//

import Foundation

class LoadNotesDBOperation: BaseDBOperation {

    override func main() {
        notebook.load()
        finish()
    }
}

