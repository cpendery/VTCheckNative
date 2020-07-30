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
                VStack(alignment: .leading) {
                    Image("BarcodeScanning")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width - 60)
                        .padding(.bottom, 30)
                    
                    NavigationLink(destination: ScanQRBarcode(barcode: "")) {
                        HStack {
                            Image(systemName: "qrcode.viewfinder")
                                .foregroundColor(.blue)
                                .imageScale(.large)
                                .font(Font.title.weight(.regular))
                                .frame(width: 60)
                            Text("Scan Location Tag")
                                .font(.headline)
                        }
                    }.padding(.bottom, 60)
                    
                    NavigationLink(destination: RoomList()) {
                        HStack {
                            Image(systemName: "bed.double")
                                .foregroundColor(.blue)
                                .imageScale(.large)
                                .font(Font.title.weight(.regular))
                                .frame(width: 60)
                            Text("View Rooms")
                                .font(.headline)
                        }
                    }.padding(.bottom, 60)
                                  
                }   // End of VStack
                .navigationBarTitle(Text("VT Check"), displayMode: .inline)
           
            }   // End of NavigationView
        }   // End of ZStack
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
