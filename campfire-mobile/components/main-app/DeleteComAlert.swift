//
//  DeleteComAlert.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 8/23/23.
//

import SwiftUI

struct DeleteComAlert: View {
    @Binding var showAlert: Bool
    @ObservedObject var individualCom: IndividualComment
    @ObservedObject var individualPost: IndividualPost

    var body: some View {
        VStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 200, height: 100)
                .foregroundColor(Color.white)
                .overlay(
                    ZStack {
                        VStack {
                            HStack {
                                Text("delete comment?")
                                    .font(.custom("LexendDeca-Bold", size: 15))
                                    .foregroundColor(Theme.Peach)
                                    .padding()
                            }
                            .offset(y: 7)
                            Divider()
                            HStack {
                                Button(action: {
                                    showAlert.toggle()

                                }) {
                                    Text("cancel")
                                        .font(.custom("LexendDeca-Bold", size: 12))
                                        .foregroundColor(Theme.Peach)
                                        .padding()
                                }
                                .offset(x: -9, y: -9)
                                Divider()
                                    .frame(height: 49)
                                    .offset(y: -8)
                                Button(action: {
                                    showAlert.toggle()
                                    individualCom.deleteComment()
                                    individualPost.decreaseComNum()
                                }) {
                                    Text("delete")
                                        .font(.custom("LexendDeca-Bold", size: 12))
                                        .foregroundColor(Theme.Peach)
                                        .padding()
                                }
                                .offset(x: 9, y: -9)
                            }
                        }
                    }
                )
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 0.3)
                        )
                )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct DeleteReplyAlert: View {
    @Binding var showAlert: Bool
    @ObservedObject var individualReply: IndividualReply
    @ObservedObject var individualPost: IndividualPost

    var body: some View {
        VStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 200, height: 100)
                .foregroundColor(Color.white)
                .overlay(
                    ZStack {
                        VStack {
                            HStack {
                                Text("delete reply?")
                                    .font(.custom("LexendDeca-Bold", size: 15))
                                    .foregroundColor(Theme.Peach)
                                    .padding()
                            }
                            .offset(y: 7)
                            Divider()
                            HStack {
                                Button(action: {
                                    showAlert.toggle()
                                }) {
                                    Text("cancel")
                                        .font(.custom("LexendDeca-Bold", size: 12))
                                        .foregroundColor(Theme.Peach)
                                        .padding()
                                }
                                .offset(x: -9, y: -9)
                                Divider()
                                    .frame(height: 49)
                                    .offset(y: -8)
                                Button(action: {
                                    showAlert.toggle()
                                    individualReply.deleteReply()
                                    individualPost.decreaseComNum()
                                }) {
                                    Text("delete")
                                        .font(.custom("LexendDeca-Bold", size: 12))
                                        .foregroundColor(Theme.Peach)
                                        .padding()
                                }
                                .offset(x: 9, y: -9)
                            }
                        }
                    }
                )
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 0.3)
                        )
                )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}



struct CamDenyAlert: View {
    @Binding var showAlert: Bool

    var body: some View {
        VStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 300, height: 150)
                .foregroundColor(Color.white)
                .overlay(
                    ZStack {
                        VStack {
                            HStack {
                                Text("you need to enable camera access to use campfire!")
                                    .font(.custom("LexendDeca-Bold", size: 15))
                                    .foregroundColor(Theme.Peach)
                                    .padding()
                                    .multilineTextAlignment(.center)
                            }
                            .offset(y: 7)
                            Divider()
                            HStack {
                                Button(action: {
                                    showAlert.toggle()
                                    if let url = URL(string: UIApplication.openSettingsURLString) {
                                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                    }
                                }) {
                                    Text("open settings")
                                        .font(.custom("LexendDeca-Bold", size: 15))
                                        .foregroundColor(Theme.Peach)
                                        .padding()
                                }
                                .offset(x: 9, y: -9)
                            }
                        }
                    }
                )
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 0.3)
                        )
                )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
