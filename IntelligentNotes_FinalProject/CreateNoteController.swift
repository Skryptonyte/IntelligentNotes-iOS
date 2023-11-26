//
//  CreateNoteController.swift
//  IntelligentNotes_FinalProject
//
//  Created by Rayhan Faizel on 15/11/23.
//

import UIKit
import AVFoundation

class CreateNoteController:
    
    UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var contentField: UITextView!


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "unwindToList"){
            let controller = segue.destination as? NoteListViewController
            let folderId = (controller?.currentFolder!)!
            DBManager.insertIntoNotes(title: titleField!.text!, content: contentField!.text, folderId: folderId)
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
