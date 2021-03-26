import UIKit
import CoreData

class NoteTableViewController: UITableViewController, NVCDelegate {
    
    let token = "" // pass your token
    let backendQueue = OperationQueue()
    let dbQueue = OperationQueue()
    let commonQueue = OperationQueue()
    
    var managedObjectContext = (
        UIApplication.shared.delegate as! AppDelegate
    ).persistentContainer.newBackgroundContext()
    var noteArray = [Note]()
    var loadArray = [Note]()
    var saveArray = [Note]()
    var gistId = ""
    
    var notebook: Notebook!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        loadNotes()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.noteArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteCell
        cell.noteTitleLabel.text = self.noteArray[indexPath.row].title
        cell.noteLabel.text = self.noteArray[indexPath.row].content
        cell.tagView.backgroundColor = UIColor(hex:  self.noteArray[indexPath.row].color)
        
        return cell
    }
    
    

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let note = noteArray.remove(at: indexPath.row)
            removeNote(note: note)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = noteArray[indexPath.row]
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NoteViewController") as! NoteViewController
        controller.note = note
        controller.isOldNote = true
        controller.indexNote = indexPath
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Add" {
            let nvc = segue.destination as? NoteViewController
            nvc?.delegate = self
        }
    }
    func getNote(note: Note, isOldNote: Bool, indexNote: IndexPath) {
        
        if isOldNote == false {
            noteArray.append(note)
            tableView.insertRows(at: [IndexPath(row: noteArray.count - 1, section: 0)] , with: .automatic)
        } else if isOldNote == true {
            noteArray[indexNote.row] = note
            tableView.reloadData()
        }
        
        saveNote(note: note)
        
        
    }
    
    func saveNote(note: Note) {
        
        let saveNoteOperation = SaveNoteOperation(note: note, notebook: notebook, backendQueue: backendQueue, dbQueue: dbQueue, token: token, gistId: gistId)
        commonQueue.addOperation(saveNoteOperation)
        let updateNoteArray = BlockOperation {
            self.noteArray = self.notebook.getList()
        }
        updateNoteArray.addDependency(saveNoteOperation)
        OperationQueue.main.addOperation(updateNoteArray)
    }
    
    func loadNotes() {
        
        notebook = DBNotebook(context: managedObjectContext)
        
        let loadNoteOperation = LoadNotesOperation(notebook: notebook, backendQueue: backendQueue, dbQueue: dbQueue, token: token)
        commonQueue.addOperation(loadNoteOperation)
        let updateUI = BlockOperation {
            self.gistId = loadNoteOperation.gistId ?? ""
            self.noteArray = self.notebook.getList()
            self.tableView.reloadData()
        }
        updateUI.addDependency(loadNoteOperation)
        OperationQueue.main.addOperation(updateUI)
    }
    
    func removeNote(note: Note) {
        
        let removeNoteOperation = RemoveNoteOperation(note: note, notebook: notebook, backendQueue: backendQueue, dbQueue: dbQueue, token: token, gistId: gistId)
        commonQueue.addOperation(removeNoteOperation)
        let updateNoteArray = BlockOperation { 
            self.noteArray = self.notebook.getList()
        }
        updateNoteArray.addDependency(removeNoteOperation)
        OperationQueue.main.addOperation(updateNoteArray)
    }
}
