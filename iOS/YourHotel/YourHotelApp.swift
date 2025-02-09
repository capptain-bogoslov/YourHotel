//
//  YourHotelApp.swift
//  YourHotel
//
//  Created by Batsioulas, Theologos on 15/12/24.
//

import SwiftUI
import SwiftUI
import FirebaseCore
import UserNotifications
import FirebaseMessaging

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        //Configure Firebase
        FirebaseApp.configure()
        return true
    }
}


@main
struct YourHotelApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var userAuth: UserAuthModel = UserAuthModel()

    var body: some Scene {
        WindowGroup {
            SplashScreen()
//                .environmentObject(userAuth)

        }
    }
}
