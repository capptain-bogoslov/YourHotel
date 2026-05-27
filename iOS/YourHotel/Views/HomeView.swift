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
    @State var tabSelected: Int = 0
    let minDragTranslationForSwipe: CGFloat = 50
    private let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)


    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {

                TabView(selection: $tabSelected) {
                    Group {
                        ZStack {
                            HomeContent(tabSelected: $tabSelected)
                        }
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("home")
                        }
                        .tag(0)
                        .onChange(of: tabSelected) { _ in
                            impactFeedbackGenerator.impactOccurred()
                        }
                        
                        ZStack {
                            HotelView()
                        }
                        .tabItem {
                            Image(systemName: "building.2.fill")
                            Text("hotel")
                        }
                        .tag(1)
                        .onChange(of: tabSelected) { _ in
                            impactFeedbackGenerator.impactOccurred()
                        }
                        
                        ZStack {
                            HomeContent(tabSelected: $tabSelected)
                        }
                        .tabItem {
                            Image(systemName: "calendar")
                            Text("calendar")
                        }
                        .tag(2)
                        .onChange(of: tabSelected) { _ in
                            impactFeedbackGenerator.impactOccurred()
                        }
                        
                        ZStack {
                            HomeContent(tabSelected: $tabSelected)
                        }
                        .tabItem {
                            Image(systemName: "fork.knife")
                            Text("services")
                        }
                        .tag(3)
                        .onChange(of: tabSelected) { _ in
                            impactFeedbackGenerator.impactOccurred()
                        }
                        
                        ZStack {
                            ProfileView()
                                .ignoresSafeArea(.all, edges: .top)
                        }
                        .tabItem {
                            Image(systemName: "person.fill")
                            Text("profile")
                        }
                        .tag(4)
                        .onChange(of: tabSelected) { _ in
                            impactFeedbackGenerator.impactOccurred()
                        }
                        
                    }
                    .toolbarBackground(.visible, for: .tabBar)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        impactFeedbackGenerator.impactOccurred()
                        tabSelected = 0
                    }) {
                        
                        Image("logo_single")
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                            .foregroundColor(.primary)
                            .padding(6)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        
                    }) {
                        Image(systemName: "bell")
                            .font(.title3)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                        // 1. The Menu acts as the container
                        Menu {

                            Button(action: { print("contact us tapped") }) {
                                Label("Contact Us", systemImage: "bubble.left")
                            }
                            
                            Button(action: { print("Feedback tapped") }) {
                                Label("Give feedback", systemImage: "star")
                            }
                            
                            Button(action: { print("Privacy policy tapped") }) {
                                Label("Privacy Policy", systemImage: "hand.raised")
                            }
                            
                            Divider()
                            
                            Button(action: { print("About us tapped") }) {
                                Label("About us", systemImage: "info")
                            }
                            
                        } label: {

                            Image(systemName: "filemenu.and.pointer.arrow")
                                .font(.title3)
                        }
                    }
            }
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


struct HomeContent: View {
    
    @EnvironmentObject var auth: UserAuthModel
    @State var user: User? = nil
    @State var request: String = ""
    @State var error: String? = nil
    @State var requestSent: Bool = false
    @State var isLoading: Bool = false
    @State var requests: [RoomRequest] = []
    @Binding var tabSelected: Int
    
    var body: some View {
        VStack(spacing: 0) {
            if auth.userLoggedIn {
                
                if let user = self.user {
                    
                    Text("Welcome user of room \(user.room)")
                    
//                    Text("Existing Requests")
//                    
//                    ScrollView {
//                        ForEach(self.requests, id: \.self) { request in
//                            Text(request.requestMessage)
//                        }
//                        
//                    }
//                    .frame(maxWidth: .infinity)
//                    .background(Color.primaryColor)
//                    .padding(10)
//                    
//                    TextField("Enter request", text: $request)
//                        .padding(.vertical, 20)
//                        .padding(.horizontal, 5)
//                        .frame(maxWidth: .infinity)
//                        .background(request.isEmpty ? Color.gray.opacity(0.1) : Color.clear)
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 10)
//                                .stroke(Color.gray, lineWidth: 1)
//                        )
//                    
//                    Button {
//                        self.isLoading = true
//                        Task {
//                            do {
//                                try await auth.sendRequestToFirestore(request: request)
//                                self.requestSent.toggle()
//                                self.isLoading = false
//                            } catch {
//                                self.error = error.localizedDescription
//                            }
//                        }
//
//                    } label: {
//                        Text("Send a Request")
//                            .fontWeight(.heavy)
//                            .font(.title2)
//                            .padding(10)
//                    }
//                    .foregroundColor(.white)
//                    .background(LinearGradient(colors:  [Color.primaryColor, Color.tertiary], startPoint: .top, endPoint: .bottom))
//                    .cornerRadius(10)
//                    .disabled(request.isEmpty || isLoading)
//                    .overlay {
//                        RoundedRectangle(cornerRadius: 10)
//                            .stroke(.black, lineWidth: 1)
//                            .opacity(0.5)
//                    }
//                    
//                    
//                    if isLoading {
//                        ProgressView()
//                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
//                            .scaleEffect(2)
//                    } else {
//                        if requestSent {
//                            Text("Request Sent")
//                                .fontWeight(.bold)
//                                .font(.title3)
//                                .foregroundStyle(.green)
//                        }
//                    }
                }
                
            }
            ScrollView {
                HStack {
                    Text("Meet")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Image("logo1line")
                        .resizable()
                        .scaledToFit()
                        .font(.title)
                    
                    Spacer()
                    
                    Button {
                        tabSelected = 1
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.body)
                    }
                }
                .padding(.horizontal, 16)
                
                AsymmetricScrollView()
                
                Spacer()
            }
//            .padding(.horizontal, 16)
            
            if !auth.userLoggedIn {
                Spacer()
                
                SignInPromptView(tabSelected: $tabSelected)
                
                Spacer()
            }
            
        }
        .onReceive(auth.$user) { value in
            if let user = value {
                self.user = user
                Task {
                    await auth.getRoomRequests(room: user.room)
                }
            }
        }
        .onReceive(auth.$room) { room in
            if let validRoom = room {
                self.requests = validRoom.requests
                
            }
        }
    }
}


struct SignInPromptView: View {
    
    @Binding var tabSelected: Int
    
    var body: some View {
        HStack {
            Text("Sign in to get access to exclusive services, offers and hotel information")
                .font(.subheadline)
                .fontWeight(.semibold)
                                
            Button {
                tabSelected = 4
            } label: {
                Label("Sign In", systemImage: "door.left.hand.open")
                    .font(.body)
                    .fontWeight(.black)
                    .padding()
                
            }
            .frame(height: 40)
            .foregroundColor(.white)
            .background(LinearGradient(colors:  [Color.primaryColor, Color.surfaceVariant], startPoint: .top, endPoint: .bottom))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(.red)
    }
}



import SwiftUI

struct AsymmetricScrollView: View {
    var body: some View {
        GeometryReader { screenGeo in
            let screenWidth = screenGeo.size.width
            let totalScrollWidth = screenWidth * 2
            let totalHeight: CGFloat = 350
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    
                    ImageTileButton(description: "Our Rooms", imageName: "image1")
                        .frame(width: totalScrollWidth * 0.20, height: totalHeight * 1.0)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        
                        HStack(spacing: 0) {
                            ImageTileButton(description: "Restaurants & Bars", imageName: "image2")
                                .frame(width: totalScrollWidth * 0.20)
                            
                            ImageTileButton(description: "Wellness", imageName: "image3")
                                .frame(width: totalScrollWidth * 0.40)
                        }
                        .frame(height: totalHeight * 0.65)
                        
                        HStack(spacing: 0) {
                            ImageTileButton(description: "Beach & Pools", imageName: "image4")
                                .frame(width: totalScrollWidth * 0.45)
                            
                            ImageTileButton(description: "Events", imageName: "image5")
                                .frame(width: totalScrollWidth * 0.15)
                        }
                        .frame(height: totalHeight * 0.35)
                    }
                    .frame(width: totalScrollWidth * 0.60, height: totalHeight)
                    
                    ImageTileButton(description: "Facilities & Services", imageName: "image6")
                        .frame(width: totalScrollWidth * 0.20, height: totalHeight * 1.0)
                }
                .frame(width: totalScrollWidth, height: totalHeight)
            }
            .frame(height: totalHeight)
        }
        .frame(height: 400)
    }
}

// Reusable Image Tile Component with Spacing, Image, Gradient, and Description
struct ImageTileButton: View {
    let description: String
    let imageName: String // Pass your asset image name here
    
    var body: some View {
        Button {
            print("tile tapped!")
        } label: {
            ZStack(alignment: .bottomLeading) {
                Image("hotel1")//imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.3))
                
                LinearGradient(
                    colors: [.black.opacity(0.85), .black.opacity(0.4), .clear],
                    startPoint: .bottom,
                    endPoint: .top
                )
                
                VStack(alignment: .leading, spacing: 4) {
                    
                    Text(description)
                        .font(.callout)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .lineLimit(2)
                }
                .padding(12)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(4)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .buttonStyle(.plain)
    }
}
