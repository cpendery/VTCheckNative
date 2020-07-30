//
//  MyFavoriteItem.swift
//  Countries
//
//  Created by Sameer Dandekar on 1/23/20.
//  Copyright © 2020 Sameer Dandekar. All rights reserved.
//
 
import SwiftUI
 
struct RoomItem: View {
    // Input Parameter
    let room: Room
   
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(verbatim: room.name)
                    .font(.headline)
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                HStack {
                    Text("Current Occupancy: ")
                    Text(String(room.currentOccupancy))
                }
                HStack {
                    Text("Limit: ")
                    Text(String(room.limit))
                }
                
            }
            // Set font and size for the whole VStack content
            .font(.system(size: 14))
           
        }   // End of HStack
    }
   
}
 
 
struct RoomItem_Previews: PreviewProvider {
    static var previews: some View {
        RoomItem(room: roomStructList[0])
    }
}
 
 
