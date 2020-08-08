//
//  MyFavoriteDetails.swift
//  Countries
//
//  Created by Sameer Dandekar on 1/23/20.
//  Copyright © 2020 Sameer Dandekar. All rights reserved.
//
 
import SwiftUI
import MapKit
 
struct RoomDetails: View {
    // Input Parameter
    let room: Room
   
    var body: some View {
        // A Form cannot have more than 10 Sections.
        // Group the Sections if more than 10.
        Form {
            Group {
                Section(header: Text("Name")) {
                    Text(verbatim: room.name)
                }
                Section(header: Text("Address")) {
                    Text(verbatim: room.address)
                }
                Section(header: Text("Current Occupancy")) {
                    Text(String(room.currentOccupancy))
                }
                

                Section(header: Text("Current Status")) {
                    if room.isInfected {
                        Text("This room is closed due to COVID-19 restrictions.")
                    }
                    else {
                        Text("This room is open.")
                    }
                }
            }
 
        }   // End of Form
        .navigationBarTitle(Text("Room Details"), displayMode: .inline)
        .font(.system(size: 14))
    }
   
}
 
 
struct RoomDetails_Previews: PreviewProvider {
    static var previews: some View {
        RoomDetails(room: roomStructList[0])
    }
}
 
