//
//  ContentView.swift
//  LoginPageSwiftUITutorial
//
//  Created by BLCKBIRDS on 01.07.19.
//  Copyright © 2019 BLCKBIRDS. All rights reserved.
//

import SwiftUI

let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)

let storedUsername = "Myusername"
let storedPassword = "Mypassword"

struct LoginView : View {
    
    @State var username: String = ""
    @State var password: String = ""
    
    @State var authenticationDidFail: Bool = false
    @State var authenticationDidSucceed: Bool = false
    
    @State var editingMode: Bool = false
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        
        ZStack {
            VStack {
                WelcomeText()
                UserImage()
                UsernameTextField(username: $username, editingMode: $editingMode)
                PasswordSecureField(password: $password)
                if authenticationDidFail {
                    Text("Information not correct. Try again.")
                        .offset(y: -10)
                        .foregroundColor(.red)
                }
                Button(action: {
                    loginRequest(username: self.username, password: self.password)
                    if loggedIn {
                        self.authenticationDidSucceed = true
                        self.authenticationDidFail = false
                        self.viewRouter.currentPage = "page2"
                        getAllRoomData()
                    } else {
                        self.authenticationDidFail = true
                    }
                }) {
                    LoginButtonContent()
                }
                }
                .padding()
            if authenticationDidSucceed {
                Text("Login succeeded!")
                    .font(.headline)
                    .frame(width: 250, height: 80)
                    .background(Color.green)
                    .cornerRadius(20.0)
                    .foregroundColor(.white)
                    //change
                    .animation(Animation.default)
            }
        }
            .offset(y: editingMode ? -150 : 0)
    }
}

#if DEBUG
struct LoginView_Previews : PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
#endif

struct WelcomeText : View {
    var body: some View {
        return Text("Welcome!")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
    }
}

struct UserImage : View {
    var body: some View {
        return Image("Fralin")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 150, height: 150)
            .clipped()
            .cornerRadius(150)
            .padding(.bottom, 75)
    }
}

struct LoginButtonContent : View {
    var body: some View {
        return Text("LOGIN")
            .font(.headline)
            //change
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 60)
            .background(Color.green)
            .cornerRadius(15.0)
    }
}

struct UsernameTextField : View {
    
    @Binding var username: String
    
    @Binding var editingMode: Bool
    
    var body: some View {
        return TextField("Username", text: $username, onEditingChanged: {edit in
            if edit == true
            {self.editingMode = true}
            else
            {self.editingMode = false}
        })
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
    }
}

struct PasswordSecureField : View {
    
    @Binding var password: String
    
    var body: some View {
        return SecureField("Password", text: $password)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
    }
}
