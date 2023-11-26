//
//  IntelligentNotes_FinalProjectTests.swift
//  IntelligentNotes_FinalProjectTests
//
//  Created by Rayhan Faizel on 15/11/23.
//

import XCTest
@testable import IntelligentNotes_FinalProject

final class IntelligentNotes_FinalProjectTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDBPathCorrect() throws {
        XCTAssertTrue( DBManager.dbPath == "test.db")
    }
    
    func testMainFolder() throws {
        XCTAssertTrue( DBManager.readFolders().contains(where: {$0.folderName == "Main" && $0.folderID == 1}))
    }

    func testInsertNoteAndDelete() throws {
        DBManager.purgeDB()
        DBManager.insertIntoNotes(title: "Note 1", content: "Content 1", folderId: 1)
        DBManager.insertIntoNotes(title: "Note 2", content: "Content 2", folderId: 1)
        DBManager.insertIntoNotes(title: "Note 3", content: "Content 3", folderId: 1)
        
        XCTAssert(DBManager.readNotes(folderId: 1).count == 3)
        XCTAssertTrue( DBManager.readNotes(folderId: 1).contains(where: {$0.title == "Note 1" && $0.content == "Content 1"}))
        XCTAssertTrue( DBManager.readNotes(folderId: 1).contains(where: {$0.title == "Note 2" && $0.content == "Content 2"}))
        XCTAssertTrue( DBManager.readNotes(folderId: 1).contains(where: {$0.title == "Note 3" && $0.content == "Content 3"}))

        for note in DBManager.readNotes(folderId: 1){
            let prevCount = DBManager.readNotes(folderId: 1).count
            DBManager.deleteNote(noteId: note.id)
            XCTAssert( DBManager.readNotes(folderId: 1).count == prevCount - 1)
        }
    }

    func testInsertAndUpdate() throws {
        DBManager.purgeDB()
        DBManager.insertIntoNotes(title: "Note 1", content: "Content 1", folderId: 1)
        var notes = DBManager.readNotes(folderId: 1)
        DBManager.updateNote(noteId: notes[0].id, title: "Updated", content: "Updated content")
        notes = DBManager.readNotes(folderId: 1)
        XCTAssertTrue(notes[0].content == "Updated content" && notes[0].title == "Updated")
        
        DBManager.deleteNote(noteId: notes[0].id)
    }
    func testInsertIntoFolders() throws {
        DBManager.purgeDB()
        DBManager.insertIntoFolders(folderName: "Secondary")
        XCTAssert(DBManager.readFolders().count == 2)
        XCTAssertTrue(DBManager.readFolders().contains(where: {$0.folderName == "Secondary"}))
        
        let secondaryFolderId = DBManager.readFolders()[DBManager.readFolders().firstIndex(where: {$0.folderName == "Secondary"})!].folderID
        
        DBManager.insertIntoNotes(title: "Main Note 1", content: "Content 1", folderId: 1)
        DBManager.insertIntoNotes(title: "Main Note 2", content: "Content 2", folderId: 1)
        DBManager.insertIntoNotes(title: "Main Note 3", content: "Content 3", folderId: 1)
        
        DBManager.insertIntoNotes(title: "Sec Note 1", content: "Content 1", folderId: secondaryFolderId)
        DBManager.insertIntoNotes(title: "Sec Note 2", content: "Content 2", folderId: secondaryFolderId)
        DBManager.insertIntoNotes(title: "Sec Note 3", content: "Content 3", folderId: secondaryFolderId)
        
        XCTAssertTrue(DBManager.readNotes(folderId: 1).contains(where: {$0.title == "Main Note 1"}))
        XCTAssertTrue(DBManager.readNotes(folderId: 1).contains(where: {$0.title == "Main Note 2"}))
        XCTAssertTrue(DBManager.readNotes(folderId: 1).contains(where: {$0.title == "Main Note 3"}))
        
        XCTAssertTrue(DBManager.readNotes(folderId: secondaryFolderId).contains(where: {$0.title == "Sec Note 1"}))
        XCTAssertTrue(DBManager.readNotes(folderId: secondaryFolderId).contains(where: {$0.title == "Sec Note 2"}))
        XCTAssertTrue(DBManager.readNotes(folderId: secondaryFolderId).contains(where: {$0.title == "Sec Note 3"}))
     
        XCTAssertFalse(DBManager.readNotes(folderId: secondaryFolderId).contains(where: {$0.title == "Main Note 1"}))
        XCTAssertFalse(DBManager.readNotes(folderId: secondaryFolderId).contains(where: {$0.title == "Main Note 2"}))
        XCTAssertFalse(DBManager.readNotes(folderId: secondaryFolderId).contains(where: {$0.title == "Main Note 3"}))
        
        XCTAssertFalse(DBManager.readNotes(folderId: 1).contains(where: {$0.title == "Sec Note 1"}))
        XCTAssertFalse(DBManager.readNotes(folderId: 1).contains(where: {$0.title == "Sec Note 2"}))
        XCTAssertFalse(DBManager.readNotes(folderId: 1).contains(where: {$0.title == "Sec Note 3"}))
        for note in DBManager.readNotes(folderId: 1){
            let prevCount = DBManager.readNotes(folderId: 1).count
            DBManager.deleteNote(noteId: note.id)
            XCTAssert( DBManager.readNotes(folderId: 1).count == prevCount - 1)
        }
        for note in DBManager.readNotes(folderId: secondaryFolderId){
            let prevCount = DBManager.readNotes(folderId: secondaryFolderId).count
            DBManager.deleteNote(noteId: note.id)
            XCTAssert( DBManager.readNotes(folderId: secondaryFolderId).count == prevCount - 1)
        }
        DBManager.deleteFolder(folderId: secondaryFolderId)
        XCTAssert(DBManager.readFolders().count == 1)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
