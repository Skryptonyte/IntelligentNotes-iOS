//
//  FolderSelectSaveViewController.swift
//  IntelligentNotes_FinalProject
//
//  Created by Rayhan Faizel on 27/11/23.
//

import UIKit

class FolderSelectSaveViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var folderPicker: UIPickerView!
    var content: String! = nil
    var title_: String! = nil
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.folders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.folders[row].folderName
    }
    
    var folders: [Folder] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.folders = DBManager.readFolders()
        self.folderPicker.delegate = self
        self.folderPicker.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitAction(_ sender: Any) {
        let selectedFolderId = self.folders[self.folderPicker.selectedRow(inComponent: 0)].folderID
        DBManager.insertIntoNotes(title: self.title_, content: self.content, folderId: selectedFolderId)
        dismiss(animated: true)
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
