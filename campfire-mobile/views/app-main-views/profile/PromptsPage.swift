//
//  PromptsPage.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 7/13/23.
//

import SwiftUI

struct PromptsPage: View {
    
    var body: some View {
        VStack {
            Text("choose your prompt")
                .font(.custom("LexendDeca-Bold", size: 20))
                .padding(.top, 20)
            ChoosePrompt()
        }
    }
}


struct ChoosePrompt: View {

    let promptList = ["my school moment", "my party face", "top study spot", "weekend outing", "just another day at the office", "work hard play hard!", "one thing you didn't know about me", "welcome to my TedTalk", "mondays are so...", "im totally sober", "cheers🥂"]

    @State private var selectedPromptIndex: Int?

    var body: some View {
             
        ScrollView {
            ForEach(0..<promptList.count, id: \.self) { index in
                Button(action: {
                    if self.selectedPromptIndex == index {
                        self.selectedPromptIndex = nil
                        } else {
                            self.selectedPromptIndex = index
                        }
                }) {
                    HStack {
                        Text(promptList[index])
                            .foregroundColor(Theme.TextColor)
                            .font(.custom("LexendDeca-Regular", size: 17))
                            .padding(.leading, 40)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()

                        if selectedPromptIndex == index {
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








struct PromptsPage_Previews: PreviewProvider {
    static var previews: some View {
        PromptsPage()
    }
}
