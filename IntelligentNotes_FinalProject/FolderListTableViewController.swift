//
//  FolderListTableViewController.swift
//  IntelligentNotes_FinalProject
//
//  Created by Rayhan Faizel on 24/11/23.
//

import UIKit

class FolderListTableViewController: UITableViewController {
    var folders: [Folder]!;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.folders = DBManager.readFolders()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @IBAction func addFolderAction(_ sender: Any) {
        let alert = UIAlertController(title: "New Folder", message: "", preferredStyle: .alert)
        var tf: UITextField?;
        alert.addTextField { (textField : UITextField!) -> Void in
            tf = textField
            tf?.placeholder = "Enter folder name"
        };        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: {
            (UIAlertAction) -> Void in
            DBManager.insertIntoFolders(folderName: tf!.text!)
            self.folders = DBManager.readFolders()
            self.tableView.reloadData()
        }))
        present(alert, animated: true)

    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return folders.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "folderCell", for: indexPath)
        cell.textLabel?.text = folders[indexPath.row].folderName
        cell.imageView?.image = UIImage(systemName: "folder")
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "folderNavigate", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "folderNavigate"){
            let index = self.tableView.indexPathForSelectedRow?.row
            let vc: NoteListViewController = segue.destination as! NoteListViewController
            vc.title = folders[index!].folderName
            vc.currentFolder = folders[index!].folderID
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
