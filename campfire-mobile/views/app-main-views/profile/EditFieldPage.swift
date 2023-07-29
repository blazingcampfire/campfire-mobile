//
//  EditFieldPage.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/27/23.
//

import SwiftUI

struct EditFieldPage: View {
    
    @State private var newName: String = ""
    @State private var isEditing: Bool = false
    @EnvironmentObject var profileModel: ProfileModel

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
                
                TextField("enter new \(field)", text: $newName, onEditingChanged: { editing in
                    isEditing = editing
                }, onCommit: {
                    saveName()
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                
                if newName != currentfield && newName != "" {
                    Button(action: {
                        saveName()
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
            }
            .padding(.top, 50)
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    func saveToFireBase() {
        let docRef = ndProfiles.document(profileModel.profile!.userID)
        
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

struct EditFieldPage_Previews: PreviewProvider {
    static var previews: some View {
        EditFieldPage(field: "name", currentfield: "David")
    }
}
