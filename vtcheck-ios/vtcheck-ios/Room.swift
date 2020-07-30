//
//  Account.swift
//  FootballTickets
//
//  Created by Sameer Dandekar on 1/23/20.
//  Copyright © 2020 Sameer Dandekar. All rights reserved.
//
 
import SwiftUI
 
struct Room: Hashable, Codable, Identifiable {
   
    var id: UUID        // Storage Type: String, Use Type (format): UUID
    var field: Int
    var name: String
    var address: String
    var currentOccupancy: Int
    var limit: Int
    var isInfected: Bool
}
