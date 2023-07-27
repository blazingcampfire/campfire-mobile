////
////  TestCamPage.swift
////  campfire-mobile
////
////  Created by Femi Adebogun on 7/15/23.
////
//
//import SwiftUI
//import SwiftUICam
//
//struct TestCamPage: View {
//    @ObservedObject var events = UserEvents()
//    var body: some View {
//        ZStack {
//            CameraView(events: events, applicationName: "campfire-mobile")
//                .edgesIgnoringSafeArea(.all)
//            CameraPage(events: events)
//                .edgesIgnoringSafeArea(.top)
//        }
//        .edgesIgnoringSafeArea(.all)
//    }
//}
//
//struct TestCamPage_Previews: PreviewProvider {
//    static var previews: some View {
//        TestCamPage(events: UserEvents())
//    }
//}
