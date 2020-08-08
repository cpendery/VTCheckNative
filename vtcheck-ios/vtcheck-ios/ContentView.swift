//
//  ContentView.swift
//  vtcheck-ios
//
//  Created by Sameer Dandekar on 7/26/20.
//  Copyright © 2020 Sameer Dandekar. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
            NavigationView {
                VStack(alignment: .center) {
                    Image("Fralin")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width - 60)
                        .padding(.bottom, 30)
                    
                    NavigationLink(destination: ScanQRBarcode(barcode: "")) {
                        HStack {
                            Image(systemName: "qrcode.viewfinder")
                                .foregroundColor(Color(red: 232.0/255.0, green: 119.0/255.0, blue: 34.0/255.0, opacity: 1.0))
                                .imageScale(.large)
                                .font(Font.title.weight(.regular))
                                .frame(width: 60)
                            
                            Text("Scan Location Tag")
                                .font(.headline)
                                .foregroundColor(Color(red: 232.0/255.0, green: 119.0/255.0, blue: 34.0/255.0, opacity: 1.0))
                        }
                    }
                    .padding(.bottom, 60)
                    
                    
                    NavigationLink(destination: RoomList()) {
                        HStack {
                            Image(systemName: "bed.double")
                                .foregroundColor(Color(red: 232.0/255.0, green: 119.0/255.0, blue: 34.0/255.0, opacity: 1.0))
                                .imageScale(.large)
                                .font(Font.title.weight(.regular))
                                .frame(width: 60)
                            Text("View Rooms")
                                .font(.headline)
                                .foregroundColor(Color(red: 232.0/255.0, green: 119.0/255.0, blue: 34.0/255.0, opacity: 1.0))
                        }
                    }
                    .padding(.bottom, 60)
                                  
                }   // End of VStack
                .navigationBarTitle(Text("Hokie Check"), displayMode: .inline)
           
            }   // End of NavigationView
        }   // End of ZStack
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
