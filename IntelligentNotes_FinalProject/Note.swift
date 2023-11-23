//
//  Note.swift
//  IntelligentNotes_FinalProject
//
//  Created by Rayhan Faizel on 15/11/23.
//

import UIKit

struct Note: Codable {
    var id: Int
    var title: String
    var content: String
    var createDate: Date
    var modifyDate: Date
}
