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

    var field: String
    var currentfield: String

    var body: some View {
        ZStack {
            Theme.ScreenColor
                .ignoresSafeArea(.all)
            VStack {
                Text("current \(field): \(currentfield)")
                    .font(.custom("LexendDeca-Bold", size: 20))
                    .padding()

                TextField("enter new \(field)", text: $newName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                if isEditing {
                    HStack {
                        Button(action: {
                            cancelEditing()
                        }) {
                            Label("cancel", systemImage: "xmark")
                                .font(.custom("LexendDeca-Bold", size: 15))
                                .foregroundColor(.red)
                                .padding()
                        }

                        Button(action: {
                            saveName()
                        }) {
                            Label("save", systemImage: "checkmark")
                                .font(.custom("LexendDeca-Bold", size: 15))
                                .foregroundColor(.green)
                                .padding()
                        }
                    }
                } else {
                    Button(action: {
                        isEditing = true
                    }) {
                        Label("edit", systemImage: "pencil")
                            .font(.custom("LexendDeca-Bold", size: 18))
                            .foregroundColor(Theme.Peach)
                            .padding()
                    }
                }

                Spacer()
            }.padding(.top, 50)
        }
    }

    private func cancelEditing() {
        newName = currentfield
        isEditing = false
    }

    private func saveName() {
        // must save new info
        isEditing = false
    }
}

struct EditFieldPage_Previews: PreviewProvider {
    static var previews: some View {
        EditFieldPage(field: "name", currentfield: "David")
    }
}
