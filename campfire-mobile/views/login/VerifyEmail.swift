//
//  VerifyEmail.swift
//  campfire-mobile
//
//  Created by Toni on 6/18/23.
//

import GoogleSignIn
import GoogleSignInSwift
import SwiftUI

struct VerifyEmail: View {
    // setting up view dismiss == going back to previous screen
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var model: AuthModel
    @EnvironmentObject var currentUser: CurrentUserModel
    @State private var validEmail: Bool = false

    var body: some View {
        
        if (validEmail && model.createAccount) {
            CreateUsername()
        }
        else if (validEmail && model.login) {
            NavigationBar()
                .environmentObject(currentUser)
                .onAppear {
                    currentUser.setCollectionRefs()
                    currentUser.getProfile()
                    currentUser.getUser()
                }
        }
        else {
            GradientBackground()
                .overlay(
                    VStack {
                        Spacer()                        
                        VStack {
                            VStack {
                                Image(systemName: "graduationcap.circle.fill")
                                    .font(.system(size: 100))
                                    .foregroundColor(.white)
                                    .padding(.bottom, 10)
                                
                                Text("verify your email:").font(.custom("LexendDeca-Bold", size: 20))
                                    .frame(alignment: .center)
                                    .foregroundColor(Color.white).padding(10).multilineTextAlignment(.center)
                                
                                Text(model.email) // email variable
                                    .font(.custom("LexendDeca-Bold", size: 20))
                                    .frame(width: 380, height: 10, alignment: .center)
                                    .foregroundColor(.white)
                                    .accentColor(.white).multilineTextAlignment(.center)
                                    .padding(.bottom, 30)
                                
                                // MARK: - Buttons redirecting to email verification
                                
//                                LFButton(text: "Microsoft", icon: Image("microsoftlogo"))
//                                    .padding(5)
                                
                                if model.createAccount {
                                    LFButton(text: "Google", icon: Image("glogo2"))
                                        .onTapGesture {
                                            Task {
                                                do {
                                                    try await model.signUpGoogle()
                                                    validEmail = true
                                                } catch {
                                                    print(error)
                                                }
                                            }
                                        }
                                }
                                else if model.login {
                                    LFButton(text: "Google", icon: Image("glogo2"))
                                        .onTapGesture {
                                            Task {
                                                do {
                                                    try await model.signInGoogle()
                                                    validEmail = true
                                                } catch {
                                                    print(error)
                                                }
                                            }
                                        }
                                }
                            }
                            Spacer()
                        }
                        
                    })
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: BackButton(dismiss: self.dismiss, color: .white))
        }
    }
}

//struct VerifyEmail_Previews: PreviewProvider {
//    static var previews: some View {
//        VerifyEmail()
//    }
//}
