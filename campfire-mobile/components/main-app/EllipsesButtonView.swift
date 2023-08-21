//
//  EllipsesButtonView.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 8/10/23.
//

import SwiftUI

struct EllipsesButtonView: View {
    @ObservedObject var equalIds: PosterIdEqualCurrentUserId
    @EnvironmentObject var individualPostModel: IndividualPost
    @Environment(\.dismiss) private var dismiss
    @State private var selectedAction: String? = nil   // Tracks the selected action
    let optionsList = ["spam", "abuse", "threatens safety", "other"]
    @State private var option = "spam"
    var body: some View {
        VStack {

            // Report Post
            Button(action: {
                // Action for reporting the post
                selectedAction = "report"
            }) {
                VStack {
                    HStack {
                        Text("report post")
                            .font(.custom("LexendDeca-SemiBold", size: 20))
                            .padding(.leading, 16)
                            .padding(.top, 10)
                        // Padding to move text away from edge
                        Spacer()
                    }
                    if selectedAction == "report" {
                        ScrollView {
                            ForEach(0..<optionsList.count, id: \.self) { index in
                                Button(action: {
                                    self.option = optionsList[index]
                                }) {
                                    HStack {
                                        Text(optionsList[index])
                                            .foregroundColor(Theme.TextColor)
                                            .font(.custom("LexendDeca-Regular", size: 17))
                                            .padding(.leading, 16)
                                            .multilineTextAlignment(.leading)
                                        
                                        Spacer()
                                        
                                        if option == optionsList[index] {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(Theme.Peach)
                                                .bold()
                                                .font(.system(size: 22))
                                                .padding(.trailing, 15)
                                        }
                                    }
                                    .padding(.vertical, 5)
                                }
                            }
                        }
                        Button(action: {
                            individualPostModel.reportPost(issue: option)
                            dismiss()
                        }, label: {
                                Text("confirm")
                                .foregroundColor(.white)
                                .font(.custom("LexendDeca-Bold", size: 15))
                                .padding()
                            
                        })
                        .background(Theme.Peach)
                        .buttonStyle(PlainButtonStyle())
                        .cornerRadius(10)// Makes the button appearance neutral
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())  // Makes the button appearance neutral
            // Delete Post (if condition met)
            if equalIds.isEqual {
                Button(action: {
                    // Action for deleting the post
                    selectedAction = "delete"
                    equalIds.showAlert = true
                }) {
                    HStack {
                        Text("delete post")
                            .font(.custom("LexendDeca-SemiBold", size: 20))
                            .padding(.leading, 16)
                            .padding(.top, 10)// Padding to move text away from edge
                        Spacer()
                        if selectedAction == "delete" {
                            Button(action: {
                                individualPostModel.deletePostDocument()
                            }, label: {
                                Text("confirm")
                                .foregroundColor(.white)
                                .font(.custom("LexendDeca-Bold", size: 15))
                                .padding()
                            })
                            .background(Theme.Peach)
                            .buttonStyle(PlainButtonStyle())
                            .cornerRadius(10)// Makes the button appearance neutral
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())  // Makes the button appearance neutral
            }
            Spacer()
        }
    }
}

class PosterIdEqualCurrentUserId: ObservableObject {
    @Published var isEqual: Bool = false
    @Published var showAlert: Bool = false
}
