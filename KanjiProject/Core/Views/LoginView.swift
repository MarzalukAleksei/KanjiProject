//
//  LoginView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/05/20.
//

import SwiftUI

struct LoginView: View {
    @State private var login: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack {
            TextField("Login", text: $login)
                .textInputAutocapitalization(.none)
                .font(.subheadline)
                .padding(12)
                .background(Color.gray.opacity(0.5))
                .cornerRadius(10)
                .padding(.horizontal, 20)
            SecureField("Password", text: $password)
                .font(.subheadline)
                .padding(12)
                .background(Color.gray.opacity(0.5))
                .cornerRadius(10)
                .padding(.horizontal, 20)
            
            Button {
                
            } label: {
                Text("Log In")
                    .font(.largeTitle)
                    .padding(10)
                
//                    .background(Color.blue)
                    .background(Color.red)
                    
                    
            }

        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
