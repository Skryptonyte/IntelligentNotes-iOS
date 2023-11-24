//
//  PreferenceManager.swift
//  IntelligentNotes_FinalProject
//
//  Created by Rayhan Faizel on 24/11/23.
//

import Foundation

class PreferenceManager{
    static func getEngine() -> Int{
        let userDefaults = UserDefaults.standard
        if let engine = userDefaults.value(forKey: "engine") {
            return engine as! Int
        }
        else {
            return 0
        }
    }
    static func setEngine(engine: Int){
        let userDefaults = UserDefaults.standard
        userDefaults.set(engine, forKey: "engine")
    }
}
