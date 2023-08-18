//
//  EditFieldPage.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/27/23.
//

import SwiftUI

struct EditFieldPage: View {
    let maxCharacterLength: Int
    @State private var newName: String = ""
    @State private var isEditing: Bool = false
    @EnvironmentObject var currentUser: CurrentUserModel
    @Environment(\.dismiss) private var dismiss
    var unallowedCharacters: [String]?
    
    var field: String
    @State var currentfield: String

    var body: some View {
        ZStack {
            Theme.ScreenColor
                .ignoresSafeArea(.all)
            VStack {
                Text("current \(field):")
                    .font(.custom("LexendDeca-SemiBold", size: 20))
                    .padding(.bottom, -10)
                Text(currentfield)
                    .font(.custom("LexendDeca-Bold", size: 20))
                    .padding()
                    .multilineTextAlignment(.center)
                
                if newName != currentfield && newName != "" {
                    Button(action: {
                        saveName()
                        currentUser.profile.name = newName
                    }) {
                        HStack {
                            Image(systemName: "checkmark")
                                .font(.custom("LexendDeca-Bold", size: 20))
                                .foregroundColor(Theme.Peach)
                            Text("change field?")
                                .font(.custom("LexendDeca-Bold", size: 20))
                                .foregroundColor(Theme.Peach)
                        }
                    }
                }
                
             
                LimitedTextField(text: $newName, maxCharacterLength: maxCharacterLength, unallowedCharacters: unallowedCharacters)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(Theme.Peach))
                    .padding()
            }
            .padding(.top, 50)
        }
        .navigationBarItems(leading: BackButton(dismiss: self.dismiss, color: Theme.ButtonColor))
        .navigationBarBackButtonHidden(true)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }

    private func saveToFireBase() {
        let docRef = currentUser.profileRef.document(currentUser.profile.userID)
        
        docRef.setData([field: newName], merge: true) { error in
            if let error = error {
                print("Error updating document: \(error.localizedDescription)")
            } else {
                print("Document updated!")
            }
        }
    }

    private func saveName() {
        currentfield = newName
        saveToFireBase()
        newName = ""
        isEditing = false
    }
}


struct LimitedTextField: View {
    @Binding var text: String
    let maxCharacterLength: Int
    let unallowedCharacters: [String]?

    var body: some View {
        TextField("Enter text (max \(maxCharacterLength) characters)", text: $text)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .onChange(of: text) { newValue in
                if let unallowedChars = unallowedCharacters {
                    text = newValue.filter { !unallowedChars.contains(String($0)) }
                }

                if newValue.count > maxCharacterLength {
                    text = String(newValue.prefix(maxCharacterLength))
                }
            }
    }
}
//
//struct EditFieldPage_Previews: PreviewProvider {
//    static var previews: some View {
//        EditFieldPage(maxCharacterLength: 10, field: "name", currentfield: "David")
//    }
//}
