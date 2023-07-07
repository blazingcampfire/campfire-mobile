//
//  ProfilePictureView.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/20/23.
//

import SwiftUI

struct ProfilePictureView: View {
    
    var profilePicture: String?
    
    var body: some View {
        Button(action: {
            
        }, label: {
            ZStack(alignment: .bottomTrailing) {
                
                Image(systemName: "person.fill")
                    .resizable()
                    .foregroundColor(Theme.Peach)
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .scaleEffect(0.9)
                
                
                
                    .background(Color.white)
                    .clipShape(Circle())
                
                Image(systemName: "plus")
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
                    .background(Theme.Peach)
                    .clipShape(Circle())
            }
        })
    }
}

struct ProfilePictureView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePictureView()
    }
}
