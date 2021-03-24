//
//  ViewController.swift
//  Note
//
//  Created by lancelap on 07.07.2019.
//  Copyright © 2019 lancelap. All rights reserved.
//

import UIKit

protocol NVCDelegate: class {
    func getNote(note: Note, isOldNote: Bool, indexNote: IndexPath)
}

class NoteViewController: UIViewController {
    
    
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet var colors: [ColorTagView]!
    @IBOutlet weak var importanceSC: UISegmentedControl!
    @IBOutlet weak var noteSwitcher: UISwitch!
    @IBOutlet weak var noteScrollView: UIScrollView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    weak var delegate: NVCDelegate?
    
    var note: Note!
    var selfDestructionDate: Date?
    var importance: Importance!
    var isOldNote = false
    var indexNote: IndexPath = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        datePicker.isHidden = true
        setupNoteView()


        
        NotificationCenter.default.addObserver(self, selector: #selector(NoteViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NoteViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // скрывть клавиатуру при нажатии на скролвью
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapScrollView))
        tapGestureRecognizer.numberOfTapsRequired = 1
        noteScrollView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func setupNoteView() {
        
        let whiteColor = "FFFFFFFF"
        let redColor = "FF0000FF"
        let greenColor = "00F900FF"
        
        noteTextField.attributedPlaceholder = NSAttributedString(string: "Title",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        colors[1].color = .red
        
        if note != nil {
            noteTextField.text = note.title
            noteTextView.text = note.content
    switch note.importance {

    case .unImportant:
        importanceSC.selectedSegmentIndex = 1
    case .normal:
        importanceSC.selectedSegmentIndex = 0
    case .important:
        importanceSC.selectedSegmentIndex = 2
    }

    if note.color == whiteColor {
        guard let color = colors.filter( { $0.tag == 0} ).first else { return }
        color.color = .white
        color.isCurrent = true
            } else if  note.color == redColor {
                colors[1].color = .red
                colors.forEach { $0.isCurrent = false }
                colors[1].isCurrent = true
            } else if  note.color == greenColor {
                colors[2].color = .green
                colors.forEach { $0.isCurrent = false }
                colors[2].isCurrent = true
            } else {
                getPickColor(pickColor: UIColor(hex: note.color) ?? .white)
            }
            
            if note.selfDestructionDate != nil {
                noteSwitcher.isOn = true
                datePicker.isHidden = false
                datePicker.date = note.selfDestructionDate!
            }
}

    }

    func getImportance() -> Importance {
        switch importanceSC.selectedSegmentIndex {
        case 0:
            importance = .normal
        case 1:
            importance = .unImportant
        case 2:
            importance = .important
        default:
            break
        }
        return importance
    }
    
    func getCurrentColor() -> String {
        return ( (colors.filter( { $0.isCurrent } ).first)?.color)?.toHex(alpha: true) ?? "FFFFFFFF"
    }
    
    func newNote() {
        
    }
    
    func errorAlert(description: String) {
        let ac = UIAlertController(title: "Ошибка", message: description, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(okAction)
        
        self.present(ac, animated: true, completion: nil)
    }
}
