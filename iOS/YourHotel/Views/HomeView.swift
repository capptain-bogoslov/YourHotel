//
//  HomeView.swift
//  YourHotel
//
//  Created by Batsioulas, Theologos on 15/12/24.
//

import SwiftUI

struct HomeView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @EnvironmentObject var auth: UserAuthModel
    @State var tabSelected: Int = 1
    let minDragTranslationForSwipe: CGFloat = 50
    private let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)


    var body: some View {
        TabView(selection: $tabSelected) {
            Group {

                ZStack {
                    HomeContent()
                    
                }
//                .onTapGesture {
//                    if self.isDrawerOpen {
//                        self.isDrawerOpen.toggle()
//                    }
//                }
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("home")
                }
                .tag(1)
                .simultaneousGesture(DragGesture().onEnded({ handleSwipe(translation: $0.translation.width)
                }))
//                                .highPriorityGesture(DragGesture().onEnded({ handleSwipe(translation: $0.translation.width)
//                                }))
                .onChange(of: tabSelected) { _ in
                    impactFeedbackGenerator.impactOccurred()
                }
                
                ZStack {
                    HomeContent()
                    
                }
//                .onTapGesture {
//                    if self.isDrawerOpen {
//                        self.isDrawerOpen.toggle()
//                    }
//                }
                .tabItem {
                    Image(systemName: "building.2.fill")
                    Text("hotel")
                }
                .tag(1)
                .simultaneousGesture(DragGesture().onEnded({ handleSwipe(translation: $0.translation.width)
                }))
//                                .highPriorityGesture(DragGesture().onEnded({ handleSwipe(translation: $0.translation.width)
//                                }))
                .onChange(of: tabSelected) { _ in
                    impactFeedbackGenerator.impactOccurred()
                }
                
                
                ZStack {
                    HomeContent()
                }
//                .onTapGesture {
//                    if self.isDrawerOpen {
//                        self.isDrawerOpen.toggle()
//                    }
//                }
                .tabItem {
                    Image(systemName: "calendar")
                    Text("calendar")
                }
                .tag(2)
                .simultaneousGesture(DragGesture().onEnded({ handleSwipe(translation: $0.translation.width)
                }))

                .onChange(of: tabSelected) { _ in
                    impactFeedbackGenerator.impactOccurred()
                }
                
                ZStack {
                    HomeContent()
                }
//                .onTapGesture {
//                    if self.isDrawerOpen {
//                        self.isDrawerOpen.toggle()
//                    }
//                }
                .tabItem {
                    Image(systemName: "fork.knife")
                    Text("services")
                }
                .tag(3)
                .simultaneousGesture(DragGesture().onEnded({ handleSwipe(translation: $0.translation.width)
                }))
                .onChange(of: tabSelected) { _ in
                    impactFeedbackGenerator.impactOccurred()
                }
                
                ZStack {
                    ProfileView()
                        .ignoresSafeArea(.all, edges: .top)
                }
//                .onTapGesture {
//                    if self.isDrawerOpen {
//                        self.isDrawerOpen.toggle()
//                    }
//                }
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("profile")
                }
                .tag(0)
                .simultaneousGesture(DragGesture().onEnded({ handleSwipe(translation: $0.translation.width)
                }))
                .onChange(of: tabSelected) { _ in
                    impactFeedbackGenerator.impactOccurred()
                }
                
            }
//            .toolbarBackground(Color.secondaryColor, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .tint(Color.primaryColor)
        .onAppear {
//            Task {
//                await auth.fetchAuthToken()
//            }
            
        }
    }
    
    //swipe gesture
    private func handleSwipe(translation: CGFloat) {
        if translation > minDragTranslationForSwipe && tabSelected > 0 {
            tabSelected -= 1
        } else  if translation < -minDragTranslationForSwipe && tabSelected < 3 {
            tabSelected += 1
        }
    }
}

#Preview {
    HomeView()
}


struct HomeContent: View {
    var body: some View {
        Text("Hello")
    }
}
