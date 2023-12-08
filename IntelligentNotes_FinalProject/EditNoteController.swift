//
//  EditNoteController.swift
//  IntelligentNotes_FinalProject
//
//  Created by Rayhan Faizel on 15/11/23.
//

import UIKit

class EditNoteController:
    UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleField.text = noteTitle
        self.contentField.text = noteContent
        let tap = UITapGestureRecognizer(target: self.view,
        action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        /*
        let doubleTap1 = UITapGestureRecognizer(target: self.titleField,
                                                action: #selector(UIView.endEditing))
        doubleTap1.numberOfTapsRequired = 2
        self.titleField.addGestureRecognizer(doubleTap1)

        let doubleTap2 = UITapGestureRecognizer(target: self.contentField,
                                                action: #selector(UIView.endEditing))
        doubleTap2.numberOfTapsRequired = 2
        self.contentField.addGestureRecognizer(doubleTap2)
         */
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDismiss), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var contentField: UITextView!
    var noteTitle: String = ""
    var noteContent: String = ""
    var noteId: Int = -1;
    
    @IBOutlet weak var saveButton: UIButton!
    @IBAction func dismissKeyboardAction(_ sender: Any) {
        self.view.endEditing(true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "unwindToList")
        {
            let controller = segue.destination as? NoteListViewController
            DBManager.updateNote(noteId: self.noteId, title: self.titleField!.text!, content: self.contentField.text)
            controller?.reloadNoteList()
        }
        if (segue.identifier == "alarmSegue"){
            let controller = segue.destination as? AlarmViewController
            controller?.note = Note(id: self.noteId, title: self.noteTitle, content: self.noteContent, createDate: Date(), modifyDate: Date())
        }
        if (segue.identifier == "translateSegue"){
            let controller = segue.destination as? TranslateViewController
            controller?.note = Note(id: self.noteId, title: self.titleField.text! , content: self.contentField.text!, createDate: Date(), modifyDate: Date())
        }
    }
    @IBAction func unwindToEdit(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            self.contentField.contentInset.bottom = keyboardHeight
        }
    }
    @objc func keyboardWillDismiss(notification: NSNotification) {
            self.contentField.contentInset.bottom = 0
        
    }
    @IBAction func onTitleEdit(_ sender: Any) {
        if (self.titleField.text!.isEmpty){
            self.saveButton.isEnabled = false
        }
        else {
            self.saveButton.isEnabled = true
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
