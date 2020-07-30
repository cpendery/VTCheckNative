//
//  AccountData.swift
//  FootballTickets
//
//  Created by Sameer Dandekar on 1/23/20.
//  Copyright © 2020 Sameer Dandekar. All rights reserved.
//
 
import Foundation
import SwiftUI
 
// Global array of Account structs
var roomStructList = [Room]()
/*
 Difference between fileprivate and private:
 fileprivate --> makes this constant accessible anywhere only inside this source file.
 private     --> makes it accessible only inside the type (e.g., class, struct) that declared it.
 */
fileprivate let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
 
/*
 ******************************
 MARK: - Read Account Data File
 ******************************
 */
public func readRoomDataFile() {
   
    let roomDataFilename = "RoomData.json"
   
    // Obtain URL of the account data file in document directory on user's device
    let urlOfJsonFileInDocumentDirectory = documentDirectory.appendingPathComponent(roomDataFilename)
 
    do {
        _ = try Data(contentsOf: urlOfJsonFileInDocumentDirectory)
       
        // Country data file exists in the document directory
 
        roomStructList = loadFromDocumentDirectory(roomDataFilename)
        
        print("RoomData is loaded from document directory")
       
    } catch {
        // Account data file does not exist in the document directory; Load it from the main bundle.
       
        roomStructList = loadFromMainBundle(roomDataFilename)
        
        print("RoomData is loaded from main bundle")
    }
}
 
/*
***********************************************
MARK: - Load Account Data File from Main Bundle
***********************************************
*/
func loadFromMainBundle<T: Decodable>(_ filename: String, as type: T.Type = T.self) -> T {
    let data: Data
   
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Unable to find \(filename) in main bundle.")
    }
   
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Unable to load \(filename) from main bundle:\n\(error)")
    }
   
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Unable to parse \(filename) as \(T.self):\n\(error)")
    }
}
 
/*
 *****************************************************
 MARK: - Write Account Data File to Document Directory
 *****************************************************
 */
public func writeRoomDataFile() {
 
    // Obtain the URL of the JSON file in the document directory on the user's device
    let urlOfJsonFileInDocumentDirectory: URL? = documentDirectory.appendingPathComponent("RoomData.json")
 
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(roomStructList) {
        do {
            try encoded.write(to: urlOfJsonFileInDocumentDirectory!)
        } catch {
            fatalError("Unable to write encoded account data to document directory!")
        }
    } else {
        fatalError("Unable to encode account data!")
    }
}
 
/*
******************************************************
MARK: - Load Account Data File from Document Directory
******************************************************
*/
func loadFromDocumentDirectory<T: Decodable>(_ filename: String, as type: T.Type = T.self) -> T {
    let data: Data
   
    // Obtain the URL of the JSON file in the document directory on the user's device
    let urlOfJsonFileInDocumentDirectory: URL? = documentDirectory.appendingPathComponent(filename)
   
    guard let file = urlOfJsonFileInDocumentDirectory
        else {
            fatalError("Unable to find \(filename) in document directory.")
    }
   
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Unable to load \(filename) from document directory:\n\(error)")
    }
   
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Unable to parse \(filename) as \(T.self):\n\(error)")
    }
}
