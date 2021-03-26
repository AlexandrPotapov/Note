import UIKit

extension NoteViewController: CPVCDelegate {
    
    //MARK: - CPVCDelegate
    func getPickColor(pickColor: UIColor) {
        
        
        guard let _pickColor = colors.filter( { $0.tag == 3} ).first else { return }
        
        _pickColor.layer.sublayers?.removeAll()
        _pickColor.color = pickColor
        colors.forEach { $0.isCurrent = false }
        _pickColor.isCurrent = true
    }
    
    //MARK: - Show/Hide KB
    @objc func didTapScrollView(){
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            return
        }
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height , right: 0.0)
        noteScrollView.contentInset = contentInsets
        noteScrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        
        noteScrollView.contentInset = contentInsets
        noteScrollView.scrollIndicatorInsets = contentInsets
    }
    
    //MARK: - PrepareForSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickColor" {
            let secondViewController = segue.destination as? ColorPickerViewController
            secondViewController?.delegate = self
            guard let customColor = colors.filter({ $0.tag == 3}).first else { return }
            if customColor.color != .clear {
                secondViewController?.color = customColor.color
                secondViewController?.colorCode = "#" + (customColor.color.toHex() ?? "")
            }
        }
        
        if segue.identifier == "SaveNote" {
            
        }
    }
    
//MARK: Actions
    @IBAction func noteSwitch(_ sender: UISwitch) {
        if sender.isOn {
            datePicker.isHidden = false
            selfDestructionDate = datePicker.date
        } else {
            datePicker.isHidden = true
        }
    }
    
    @IBAction func tapColorPick(_ gesture: UITapGestureRecognizer) {
        
        guard let gestureView = gesture.view as? ColorTagView  else { return }
        if gestureView.color == UIColor.clear { return }
        
        colors.forEach { $0.isCurrent = false }
        
        switch gesture.state {
        case .ended:
            gestureView.isCurrent = true
        default : break
        }
    }
    
    
    @IBAction func longPressColorPicker(_ sender: UILongPressGestureRecognizer) {
        
        switch sender.state {
        
        case .began:
            performSegue(withIdentifier: "PickColor", sender: sender)
        default: break
        }
    }
    
    @IBAction func pickDestructionDate(_ sender: UIDatePicker) {
        
        selfDestructionDate = sender.date
        
    }
    @IBAction func saveBarButton(_ sender: UIBarButtonItem) {
        guard let title = noteTextField.text, let content = noteTextView.text else { return }
        guard title != "", !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorAlert(description: "Введите заголовок заметки")
            return
        }
        if isOldNote == false {
            let noteId = UUID().uuidString
            note = Note(uid: noteId, title: title, content: content, color: getCurrentColor(), importance: getImportance(), selfDestructionDate: selfDestructionDate)
            self.delegate?.getNote(note: note, isOldNote: isOldNote, indexNote : indexNote)
        } else {
            note = Note(uid: note.uid, title: title, content: content, color: getCurrentColor(), importance: getImportance(), selfDestructionDate: selfDestructionDate)
            self.delegate?.getNote(note: note, isOldNote: isOldNote, indexNote : indexNote)
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
}



