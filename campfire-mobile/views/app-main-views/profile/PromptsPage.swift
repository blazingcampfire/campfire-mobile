//
//  PromptsPage.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 7/13/23.
//

import SwiftUI

struct PromptsPage: View {
    @Binding var prompt: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("choose your prompt")
                .font(.custom("LexendDeca-Bold", size: 20))
                .padding(.top, 20)
            ChoosePrompt(prompt: $prompt, dismissPromptPage: {
                            presentationMode.wrappedValue.dismiss() // dismiss the prompt page
                        })
        }
    }
}


struct ChoosePrompt: View {
    let promptList = ["sooo college", "my party face", "for the boys", "top study spot", "weekend outing", "t-rizzonosaurus rex", "just another day at the office", "work hard play hard!", "one thing you didn't know about me", "welcome to my TedTalk", "mondays are so...", "im totally sober", "cheers🥂", "my proudest moment", "my hidden talent", "moments before disaster...", "my album cover", "don't show my mom", "good friends, bad ideas", "i tried", "felt cute, might delete later", "all my single ladies"]
    @State private var showConfirmButton: Bool?
    
    @Binding var prompt: String
    var dismissPromptPage: () -> Void

    var body: some View {
        ScrollView {
            ForEach(0..<promptList.count, id: \.self) { index in
                Button(action: {
                    self.prompt = promptList[index]
                    dismissPromptPage()
                }) {
                    HStack {
                        Text(promptList[index])
                            .foregroundColor(Theme.TextColor)
                            .font(.custom("LexendDeca-Regular", size: 17))
                            .padding(.leading, 40)
                            .multilineTextAlignment(.leading)

                        Spacer()

                        if prompt == promptList[index] {
                            Image(systemName: "checkmark")
                                .foregroundColor(Theme.Peach)
                                .bold()
                                .font(.system(size: 22))
                                .padding(.trailing, 40)
                        }
                    }
                    .padding(.vertical, 5)
                }
            }
        }
    }
}
