//
//  MyFavoritesList.swift
//  Countries
//
//  Created by Sameer Dandekar on 2/11/20.
//  Copyright © 2020 Sameer Dandekar. All rights reserved.
//
 
import SwiftUI
 
struct RoomList: View {
   
    // Subscribe to changes in UserData
    @EnvironmentObject var userData: UserData
    
    @State private var searchItem = ""
   
    var body: some View {
            List {
                SearchBar(searchItem: $searchItem)
                // Each Country struct has its own unique 'id' used by ForEach
                ForEach(userData.roomsList.filter {self.searchItem.isEmpty ? true : $0.name.localizedStandardContains(self.searchItem)}, id: \.self) {
                    aRoom in
                    NavigationLink(destination: RoomDetails(room: aRoom)) {
                        RoomItem(room: aRoom)
                    }
                }
               
            }   // End of List
            .navigationBarTitle(Text("Rooms"), displayMode: .inline)
        
    }
   
}
 
 
struct RoomList_Previews: PreviewProvider {
    static var previews: some View {
        RoomList()
            .environmentObject(UserData())
    }
}
 
 
