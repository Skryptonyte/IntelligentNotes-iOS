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
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var contentField: UITextView!
    var noteTitle: String = ""
    var noteContent: String = ""
    var noteId: Int = -1;
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "unwindToList")
        {
            let controller = segue.destination as? NoteListViewController
            DBManager.updateNote(noteId: self.noteId, title: self.titleField!.text!, content: self.contentField.text)
            controller?.reloadNoteList()
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
