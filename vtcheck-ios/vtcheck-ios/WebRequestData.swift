//
//  WebRequestData.swift
//  vtcheck-ios
//
//  Created by Sameer Dandekar on 8/1/20.
//  Copyright © 2020 Sameer Dandekar. All rights reserved.
//

import Foundation
import SwiftUI

var scannedRoomName = ""
var scannedRoomCurrentOccupancy = 0
var scannedRoomLimit = 1
var scannedRoomInfected = false
var done = false

var globalRoomsList = [Room]()

var loggedIn = false

public func loginRequest(username: String, password: String) {
    let url = URL(string: "https://api.hokiecheck.com:5000/login/?username=\(username)&password=\(password)")
    
    guard let requestUrl = url else { fatalError() }
    // Create URL Request
   var request = URLRequest(url: requestUrl)
   // Specify HTTP Method to use
   request.httpMethod = "GET"
   // Send HTTP Request
   let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
       
       // Check if Error took place
       if let error = error {
           print("Error took place \(error)")
           return
       }
       
       // Read HTTP Response Status code
       if let response = response as? HTTPURLResponse {
           print("Response HTTP Status code: \(response.statusCode)")
       }
       
       // Convert HTTP Response Data to a simple String
       if let data = data, let dataString = String(data: data, encoding: .utf8) {
           print("Response data string:\n \(dataString)")
       }
       
       
       let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
       // print if response is JSON object
       if let responseJSON = responseJSON as? [String: Any] {
            let permission = responseJSON["permission"] as! String
        if permission == "student" || permission == "admin" {
            loggedIn = true
        }
           
       }
       
        done = true
//        return loggedIn
   }
   task.resume()
   
    repeat {
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
    } while !done
}

/*
====================================
MARK: - GET Request Data from API
====================================
*/
public func getAllRoomData() {
    globalRoomsList = [Room]()
    done = false
    // Create URL
    let url = URL(string: "https://api.hokiecheck.com:5000/room/all")
    guard let requestUrl = url else { fatalError() }
    // Create URL Request
    var request = URLRequest(url: requestUrl)
    // Specify HTTP Method to use
    request.httpMethod = "GET"
    // Send HTTP Request
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        
        // Check if Error took place
        if let error = error {
            print("Error took place \(error)")
            return
        }
        
        // Read HTTP Response Status code
        if let response = response as? HTTPURLResponse {
            print("Response HTTP Status code: \(response.statusCode)")
        }
        
        // Convert HTTP Response Data to a simple String
        if let data = data, let dataString = String(data: data, encoding: .utf8) {
            print("Response data string:\n \(dataString)")
        }
        
        
        let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
        if let responseJSONArray = responseJSON as? [Any] {
            
            for (element) in responseJSONArray {
                // print if response is JSON object
                if let responseJSON = element as? [String: Any] {
                    let roomToAdd = Room(id: UUID(), field: responseJSON["Location_ID"] as! Int, building: responseJSON["Name"] as! String, name: responseJSON["Room"] as! String, address: responseJSON["Address"] as! String, currentOccupancy: responseJSON["CurrentOccupancy"] as! Int, limit: responseJSON["Limit"] as! Int, isInfected: responseJSON["isInfected"] as! Bool)
                    globalRoomsList.append(roomToAdd)
                    
                }
            }
            
        }
        
        print("bruh")
        done = true
    }
    task.resume()
 
    repeat {
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
    } while !done
}

/*
====================================
MARK: - GET Request Data from API
====================================
*/
public func getOneRoomData(roomID: String, action: String) {
    done = false
    // Create URL
    var url = URL(string: "https://api.hokiecheck.com:5000/room/\(roomID)")
    
    if action == "add" {
        url = URL(string: "https://api.hokiecheck.com:5000/add/room/\(roomID)")
    }
    else if action == "subtract" {
        url = URL(string: "https://api.hokiecheck.com:5000/subtract/room/\(roomID)")
    }
    guard let requestUrl = url else { fatalError() }
    // Create URL Request
    var request = URLRequest(url: requestUrl)
    // Specify HTTP Method to use
    request.httpMethod = "GET"
    // Send HTTP Request
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        
        // Check if Error took place
        if let error = error {
            print("Error took place \(error)")
            return
        }
        
        // Read HTTP Response Status code
        if let response = response as? HTTPURLResponse {
            print("Response HTTP Status code: \(response.statusCode)")
        }
        
        // Convert HTTP Response Data to a simple String
        if let data = data, let dataString = String(data: data, encoding: .utf8) {
            print("Response data string:\n \(dataString)")
        }
        
        
        let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
        // print if response is JSON object
        if let responseJSON = responseJSON as? [String: Any] {
            scannedRoomName = responseJSON["Room"] as! String
            scannedRoomCurrentOccupancy = responseJSON["CurrentOccupancy"] as! Int
            scannedRoomLimit = responseJSON["Limit"] as! Int
            scannedRoomInfected = responseJSON["isInfected"] as! Bool
            
        }
        
        done = true
    }
    task.resume()
    
     repeat {
         RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
     } while !done
 }
