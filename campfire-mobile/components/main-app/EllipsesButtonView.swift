//
//  EllipsesButtonView.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 8/10/23.
//

import SwiftUI

struct EllipsesButtonView: View {
    @ObservedObject var equalIds: PosterIdEqualCurrentUserId
    @State private var selectedAction: String? = nil   // Tracks the selected action

    var body: some View {
        VStack(spacing: 10) {

            // Report Post
            Button(action: {
                // Action for reporting the post
                selectedAction = "report"
            }) {
                HStack {
                    Text("report post")
                        .font(.custom("LexendDeca-SemiBold", size: 20))
                        .padding(.leading, 16)  // Padding to move text away from edge
                    Spacer()
                    if selectedAction == "report" {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Theme.Peach)
                            .bold()
                            .font(.system(size: 25))
                            .padding(.trailing, 40)
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
                            .padding(.leading, 16)  // Padding to move text away from edge
                        Spacer()
                        if selectedAction == "delete" {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Theme.Peach)
                                .bold()
                                .font(.system(size: 25))
                                .padding(.trailing, 30)
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())  // Makes the button appearance neutral
            }
        }
    }
}






struct EllipsesButtonView_Previews: PreviewProvider {
    static var previews: some View {
        EllipsesButtonView(equalIds: PosterIdEqualCurrentUserId())
    }
}

class PosterIdEqualCurrentUserId: ObservableObject {
    @Published var isEqual: Bool = false
    @Published var showAlert: Bool = false
}
