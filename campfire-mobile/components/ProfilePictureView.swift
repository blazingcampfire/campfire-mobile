//
//  ProfilePictureView.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/20/23.
//

import SwiftUI

struct ProfilePictureView: View {
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Button(action: {
                
            }, label: {
                Image(systemName: "person.fill")
                    .resizable()
                    .foregroundColor(Theme.Apricot)
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .scaleEffect(0.9)

            })
            
            .background(Color.white)
            .clipShape(Circle())
            
            Image(systemName: "plus")
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
                .background(Color.gray)
                .clipShape(Circle())
        }
    }
}

struct ProfilePictureView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePictureView()
    }
}
