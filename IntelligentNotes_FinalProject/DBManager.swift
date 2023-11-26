//
//  DBManager.swift
//  IntelligentNotes_FinalProject
//
//  Created by Rayhan Faizel on 21/11/23.
//

import Foundation
import SQLite3

class DBManager {
    static var dbPath: String {
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
            print("In testing mode!")
             return "test.db"
        }

        return "intelligent_notes_v2.db"
    }

    static func openDatabase() -> OpaquePointer?
      {
          let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
              .appendingPathComponent(dbPath)
          var db: OpaquePointer? = nil
          if sqlite3_open(filePath.path, &db) != SQLITE_OK
          {
              debugPrint("can't open database")
              return nil
          }
          else
          {
              print("Successfully created connection to database at \(dbPath)")
              return db
          }
      }
    static func executeQuery(query: String) {
        var stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(openDatabase(), query, -1, &stmt, nil) == SQLITE_OK){
            if (sqlite3_step(stmt) == SQLITE_DONE){
                print("Query \(query) was run successfully")
            }
            else {
                print("Query \(query) failed!")
            }
        }
        sqlite3_finalize(stmt)
    }
    
    static func insertIntoNotes(title: String, content: String, folderId: Int){
        var stmt: OpaquePointer? = nil
        let query = "INSERT INTO NOTES VALUES(NULL,?,?,?,?)"
        if (sqlite3_prepare_v2(openDatabase(), query, -1, &stmt, nil) == SQLITE_OK){
            sqlite3_bind_text(stmt, 1, (title as NSString).utf8String, -1, nil)
            sqlite3_bind_text(stmt, 2, (content as NSString).utf8String, -1, nil)
            sqlite3_bind_int(stmt, 3, Int32(folderId))
            sqlite3_bind_int(stmt, 4, Int32(Date().timeIntervalSince1970))
            if (sqlite3_step(stmt) == SQLITE_DONE){
                print("Query \(query) was run successfully")
            }
            else {
                print("Query \(query) failed!")
            }
        }
        sqlite3_finalize(stmt)
    }

    static func updateNote(noteId: Int, title: String, content: String){
        var stmt: OpaquePointer? = nil
        let query = "UPDATE NOTES SET NAME=?, CONTENT=?, MODIFYTIME=? WHERE NOTEID=?"
        if (sqlite3_prepare_v2(openDatabase(), query, -1, &stmt, nil) == SQLITE_OK){
            sqlite3_bind_text(stmt, 1, (title as NSString).utf8String, -1, nil)
            sqlite3_bind_text(stmt, 2, (content as NSString).utf8String, -1, nil)
            sqlite3_bind_int(stmt, 3, Int32(Date().timeIntervalSince1970))
            sqlite3_bind_int(stmt, 4, Int32(noteId))

            if (sqlite3_step(stmt) == SQLITE_DONE){
                print("Query \(query) was run successfully")
            }
            else {
                print("Query \(query) failed!")
            }
        }
        sqlite3_finalize(stmt)
    }
    
    static func deleteNote(noteId: Int){
        var stmt: OpaquePointer? = nil
        let query = "DELETE FROM NOTES WHERE NOTEID=?"
        if (sqlite3_prepare_v2(openDatabase(), query, -1, &stmt, nil) == SQLITE_OK){
            sqlite3_bind_int(stmt, 1, Int32(noteId))

            if (sqlite3_step(stmt) == SQLITE_DONE){
                print("Query \(query) was run successfully")
            }
            else {
                print("Query \(query) failed!")
            }
        }
        sqlite3_finalize(stmt)
    }
    static func readNotes(folderId: Int) -> [Note] {
           let queryStatementString = "SELECT * FROM notes  where folderid=\(folderId);"
           var queryStatement: OpaquePointer? = nil
           var notes : [Note] = []
           if sqlite3_prepare_v2(openDatabase(), queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
               while sqlite3_step(queryStatement) == SQLITE_ROW {
                   let id = sqlite3_column_int(queryStatement, 0)
                   let title = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                   let content = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                   let ts = sqlite3_column_int(queryStatement, 4)
                   notes.append(Note(id: Int(id), title: title, content: content, createDate: Date(timeIntervalSince1970: TimeInterval(ts)), modifyDate: Date(timeIntervalSince1970: TimeInterval(ts))))
                    }
           } else {
               print("SELECT statement could not be prepared")
           }
           sqlite3_finalize(queryStatement)
            print(notes)
           return notes
       }
    static func insertIntoFolders(folderName: String){
        var stmt: OpaquePointer? = nil
        let query = "INSERT INTO folders VALUES(NULL,?)"
        if (sqlite3_prepare_v2(openDatabase(), query, -1, &stmt, nil) == SQLITE_OK){
            sqlite3_bind_text(stmt, 1, (folderName as NSString).utf8String, -1, nil)

            if (sqlite3_step(stmt) == SQLITE_DONE){
                print("Query \(query) was run successfully")
            }
            else {
                print("Query \(query) failed!")
            }
        }
        sqlite3_finalize(stmt)
    }
    static func readFolders() -> [Folder] {
           let queryStatementString = "SELECT * FROM folders"
           var queryStatement: OpaquePointer? = nil
           var folders : [Folder] = []
           if sqlite3_prepare_v2(openDatabase(), queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
               while sqlite3_step(queryStatement) == SQLITE_ROW {
                   let id = sqlite3_column_int(queryStatement, 0)
                   let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                   
                   folders.append(Folder(folderID: Int(id), folderName: name))
               }
           } else {
               print("SELECT statement could not be prepared")
           }
           sqlite3_finalize(queryStatement)
           print(folders)
           return folders
       }
    static func deleteFolder(folderId: Int){
        var stmt: OpaquePointer? = nil
        let query = "DELETE FROM NOTES WHERE FOLDERID=?"
        if (sqlite3_prepare_v2(openDatabase(), query, -1, &stmt, nil) == SQLITE_OK){
            sqlite3_bind_int(stmt, 1, Int32(folderId))

            if (sqlite3_step(stmt) == SQLITE_DONE){
                print("Query \(query) was run successfully")
            }
            else {
                print("Query \(query) failed!")
            }
        }
        sqlite3_finalize(stmt)
        var stmt2: OpaquePointer? = nil

        let query2 = "DELETE FROM FOLDERS WHERE FOLDERID=?"
        if (sqlite3_prepare_v2(openDatabase(), query2, -1, &stmt2, nil) == SQLITE_OK){
            sqlite3_bind_int(stmt2, 1, Int32(folderId))

            if (sqlite3_step(stmt2) == SQLITE_DONE){
                print("Query \(query2) was run successfully")
            }
            else {
                print("Query \(query2) failed!")
            }
        }
        sqlite3_finalize(stmt2)
    }
    static func purgeDB(){
        DBManager.executeQuery(query: "DELETE FROM notes")
        DBManager.executeQuery(query: "DELETE FROM folders where foldername != 'Main'")
    }
}
