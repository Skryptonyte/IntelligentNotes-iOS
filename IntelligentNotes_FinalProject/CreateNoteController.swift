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
        self.titleField.accessibilityIdentifier = "titleField"
        self.contentField.accessibilityIdentifier = "contentField"
        self.saveButton.accessibilityIdentifier = "saveButton"
        self.view.accessibilityIdentifier = "NoteView"
        self.dismissKBButton.accessibilityIdentifier = "dismiss"
        let tap = UITapGestureRecognizer(target: self.view,
        action: #selector(UIView.endEditing))
        
        self.view.addGestureRecognizer(tap)
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
    @IBAction func dismissAction(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var contentField: UITextView!

    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var dismissKBButton: UIBarButtonItem!
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "unwindToList"){
            let controller = segue.destination as? NoteListViewController
            let folderId = (controller?.currentFolder!)!
            DBManager.insertIntoNotes(title: titleField!.text!, content: contentField!.text, folderId: folderId)
            controller?.reloadNoteList()


        }
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
