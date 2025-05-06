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
                .tag(0)
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
                .tag(4)
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
    
    @EnvironmentObject var auth: UserAuthModel
    @State var user: User? = nil
    @State var request: String = ""
    @State var error: String? = nil
    @State var requestSent: Bool = false
    @State var isLoading: Bool = false
    
    var body: some View {
        VStack(spacing: 10) {
            if auth.userLoggedIn {
                
                if let user = self.user {
                    Text("Welcome user of room \(user.room)")
                    
                    TextField("Enter request", text: $request)
                        .padding(.vertical, 20)
                        .padding(.horizontal, 5)
                        .frame(maxWidth: .infinity)
                        .background(request.isEmpty ? Color.gray.opacity(0.1) : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    
                    Button {
                        self.isLoading = true
                        Task {
                            do {
                                try await auth.sendRequestToFirestore(request: request)
                                self.requestSent.toggle()
                                self.isLoading = false
                            } catch {
                                self.error = error.localizedDescription
                            }
                        }

                    } label: {
                        Text("Send a Request")
                            .fontWeight(.heavy)
                            .font(.title2)
                            .padding(10)
                    }
                    .foregroundColor(.white)
                    .background(LinearGradient(colors:  [Color.primaryColor, Color.tertiary], startPoint: .top, endPoint: .bottom))
                    .cornerRadius(10)
                    .disabled(request.isEmpty || isLoading)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.black, lineWidth: 1)
                            .opacity(0.5)
                        
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                .scaleEffect(2)
                        } else {
                            if requestSent {
                                Text("Request Sent")
                                    .fontWeight(.bold)
                                    .font(.title3)
                                    .foregroundStyle(.green)
                            }
                        }
                    }

                } else {
                    Text("User not received")
                }
                
                
            } else {
                Text("Not logged in")
            }
        }
        .onReceive(auth.$user) { value in
            if let user = value {
                self.user = user
            }
        }
    }
}
