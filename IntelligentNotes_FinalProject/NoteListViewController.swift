//
//  NoteListViewController.swift
//  IntelligentNotes_FinalProject
//
//  Created by Rayhan Faizel on 15/11/23.
//

import UIKit

class NoteListViewController: UICollectionViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    var dataSource: DataSource!

    var notes: [Note] = []
    var currentSelectedIndex = -1
    var currentIndexPath: IndexPath = []
    var currentFolder: Int!;
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>

    @IBOutlet weak var deleteButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadNoteList()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadNoteList()
    }

    @IBAction func setEditMode(_ sender: Any) {
        self.collectionView.isEditing.toggle()
        self.collectionView.allowsMultipleSelectionDuringEditing = self.collectionView.isEditing
        
        if (!self.collectionView.isEditing)
        {
            self.deleteButton.isEnabled = false
        }
    }
    @IBAction func deleteNotes(_ sender: Any) {
        for indexPath in self.collectionView!.indexPathsForSelectedItems! {
            let noteid = self.notes[indexPath.row].id
            DBManager.deleteNote(noteId: noteid)
        }
        reloadNoteList()
        self.setEditMode(self.collectionView!)
    }
    func testFunction(_ sender: UITapGestureRecognizer? = nil){
        print("kek")
    }
    func reloadNoteList(){
        let listLayout = listLayout()
        collectionView.collectionViewLayout = listLayout
        self.notes = DBManager.readNotes(folderId: currentFolder).sorted(by: {$0.modifyDate > $1.modifyDate})
        var totrequests: [UNNotificationRequest] = [];
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
            totrequests = requests
        })
        let cellRegistration = UICollectionView.CellRegistration {
            (cell: UICollectionViewListCell, indexPath: IndexPath, itemIdentifier: String) in
            print("Notes: \(self.notes)")
            let note = self.notes[indexPath.item]
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = note.title
            contentConfiguration.secondaryText = "Modified at \(note.modifyDate.description)"

            if (totrequests.contains(where: {$0.identifier == "Note-\(note.id)"})){
                if let notification = totrequests.first(where: {$0.identifier == "Note-\(note.id)"})
                {
                    contentConfiguration.image = UIImage(systemName:"clock")
                    contentConfiguration.secondaryText! += "\nAlarm rings at \((notification.trigger as? UNCalendarNotificationTrigger)!.nextTriggerDate()!.description)"
                }
            }
            else {
                contentConfiguration.image = UIImage(systemName: "note")
            }
            
            cell.contentConfiguration = contentConfiguration
            cell.accessories = [.multiselect()]
            //Uncomment the line below if you want the tap not not interfere and cancel other interactions.

        }
                                                                            

        
        

        dataSource = DataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: String) in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(self.notes.map { "\($0.id)" })
        dataSource.apply(snapshot)


        collectionView.dataSource = dataSource
        collectionView.reloadData()
    }
    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }

    @IBAction func unwindToNoteList(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (self.collectionView.isEditing)
        {
            self.deleteButton.isEnabled = !self.collectionView.indexPathsForSelectedItems!.isEmpty
            return
        }
        self.currentSelectedIndex = indexPath.row
        self.currentIndexPath = indexPath
        print("Selected item: \(self.currentSelectedIndex)")
        performSegue(withIdentifier: "editNoteSegue", sender: self)
    }

    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if (self.collectionView.isEditing)
        {
            self.deleteButton.isEnabled = !self.collectionView.indexPathsForSelectedItems!.isEmpty
            return
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editNoteSegue") {
            let controller = segue.destination as? EditNoteController

            controller?.noteTitle = self.notes[self.currentSelectedIndex].title
            controller?.noteContent = self.notes[self.currentSelectedIndex].content
            controller?.noteId = self.notes[self.currentSelectedIndex].id
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
