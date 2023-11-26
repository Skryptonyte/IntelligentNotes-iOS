//
//  SettingsTableViewController.swift
//  IntelligentNotes_FinalProject
//
//  Created by Rayhan Faizel on 24/11/23.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.engineSelection.selectedSegmentIndex = PreferenceManager.getEngine()
    }
    @IBOutlet weak var engineSelection: UISegmentedControl!
    
    @IBAction func setEngine(_ sender: UISegmentedControl) {
        let userDefaults = UserDefaults.standard
        PreferenceManager.setEngine(engine: sender.selectedSegmentIndex)
    }
    
    @IBAction func wipeDataAction(_ sender: Any) {
        let alert = UIAlertController(title: "Wipe Data", message: "You are about to delete all folders and notes!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Erase", style: .destructive, handler: {
            (UIAlertAction) -> Void in
            DBManager.purgeDB()
        }))
        present(alert, animated: true)
    }
    // MARK: - Table view data source

    @IBAction func cancelAllAlarms(_ sender: Any) {
        let alert = UIAlertController(title: "Cancel all alarms", message: "You are about to cancel all alarms!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: {
            (UIAlertAction) -> Void in
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests() }))
        present(alert, animated: true)
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
