////
////  NavBar.swift
////  campfire-mobile
////
////  Created by Femi Adebogun on 6/26/23.
////
//
//import SwiftUI
//import SwiftUICam
//
//struct NavBar: View {
//    @State var selectedIndex = 0
//
//    let tabBarImages = ["fireplace", "map", "camera", "magnifyingglass", "person.fill"]
//    let tabBarTitles = ["Feed", "Map", "Camera", "Search", "Profile"]
//
//    init() {
//        UITabBar.appearance().barTintColor = .systemBackground
//    }
//
//    var body: some View {
//        VStack(spacing: 0) {
//            ZStack {
//                switch selectedIndex {
//                case 0:
//                    TabView {
//                        TheFeed()
//                    }
//                    .edgesIgnoringSafeArea(.bottom)
//
//                //  NavigationView {
//                //    TheFeed()
//                // }
//                case 1:
//                    NavigationView {
//                        MapPage()
//                    }
//                case 2:
//                    NavigationView {
//                        CameraPage(events: UserEvents())
//                    }
//                case 3:
//                    NavigationView {
//                        SearchPage()
//                    }
//                case 4:
//                    NavigationView {
//                        ProfilePage()
//                    }
//
//                default:
//                    NavigationView {
//                        Text("okkk")
//                    }
//                }
//            }
//
//            //     Spacer()
//            //       Spacer()
//
//            //    Divider()
//            HStack(spacing: -37) { // Adjust spacing between buttons
//                ForEach(0 ..< 5) { num in
//                    Spacer() // Add Spacer to distribute buttons evenly
//                    Button(action: {
//                        selectedIndex = num
//                    }, label: {
//                        VStack(spacing: 5) {
//                            if num == 2 {
//                                ZStack {
//                                    Circle()
//                                        .fill(Color.red)
//                                        .frame(width: 60, height: 60)
//                                        .overlay(
//                                            Image("newlogo")
//                                                .resizable()
//                                                .aspectRatio(contentMode: .fit)
//                                                .frame(width: 40, height: 40)
//                                                .offset(x: 0, y: -5)
//                                        )
//                                }
//                            } else {
//                                Image(systemName: tabBarImages[num])
//                                    .font(.system(size: 20, weight: .semibold))
//                                    .foregroundColor(selectedIndex == num ? Color(.red) : .init(white: 0.7))
//                                    .offset(x: 0, y: 0) // Adjust vertical offset
//                            }
//
//                            if num == 2 {
//                            } else {
//                                Text(tabBarTitles[num])
//                                    .font(.system(size: 12)) // Adjust font size
//                                    .foregroundColor(selectedIndex == num ? .red : .gray)
//                            }
//                        }
//                    })
//                    Spacer()
//                }
//            }
//        }
//        .padding(-15)
//        // .edgesIgnoringSafeArea(.bottom)
//    }
//}
//
//struct NavBar_Previews: PreviewProvider {
//    static var previews: some View {
//        NavBar()
//    }
//}
