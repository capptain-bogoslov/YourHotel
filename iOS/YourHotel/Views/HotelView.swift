//
//  HotelView.swift
//  YourHotel
//
//  Created by Batsioulas, Theologos on 18/5/26.
//
import SwiftUI

struct HotelView: View {
    
    @State private var section1Expanded = false
    @State private var section2Expanded = false
    @State private var section3Expanded = false
    @State private var section4Expanded = false

    enum Constants {
        static let doubleSuperior = "https://sonia-resort.com/rooms/double-superior-sea-view/"
        static let doubleDeluxe = "https://sonia-resort.com/rooms/double-deluxe-sea-view/"
        static let premiumDeluxe = "https://sonia-resort.com/rooms/premium-deluxe-sea-view/"
        static let juniorSuite = "https://sonia-resort.com/rooms/junior-suite-garden-view/"
        static let familySuite = "https://sonia-resort.com/rooms/family-suite-sea-view/"
        static let executiveSuite = "https://sonia-resort.com/rooms/executive-suite-sea-view/"
        static let poolBar = "https://sonia-resort.com/aegean-pool-bar/"
        static let beachBar = "https://sonia-resort.com/aura-beach-bar/"
        static let restaurant = "https://sonia-resort.com/mediterranean-restaurant/"
        static let panorama = "https://sonia-resort.com/panorama-bistro/"
        static let beach = "https://sonia-resort.com/beach/"
        static let pools = "https://sonia-resort.com/pools/"
        static let meliaSpa = "https://sonia-resort.com/melia-spa/"
        static let fitness = "https://sonia-resort.com/fitness-center/"
        static let garden = "https://sonia-resort.com/aura-beach-bar/"
        static let services = "https://sonia-resort.com/facilities-services/"
        static let entertainment = "https://sonia-resort.com/entertainment/"
    }
    
    var body: some View {
        ScrollView {
            
            DisclosureGroup(isExpanded: $section1Expanded) {
                Group {
                    HotelFacilityCard(image: "superior", title: "Double Superior", url: Constants.doubleSuperior)
                    
                    HotelFacilityCard(image: "double_deluxe", title: "Double Deluxe", url: Constants.doubleDeluxe)
                    
                    HotelFacilityCard(image: "premium_deluxe", title: "Premium Deluxe", url: Constants.premiumDeluxe)
                    
                    HotelFacilityCard(image: "junior_suite", title: "Junior Suite", url: Constants.juniorSuite)
                    
                    HotelFacilityCard(image: "family_suite", title: "Family Suite", url: Constants.familySuite)
                    
                    HotelFacilityCard(image: "executive_suite", title: "Executive Suite", url: Constants.executiveSuite)
                }
                .frame(height: 100)

                
            } label: {
                HStack {
                    Text("Our Rooms")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                    Spacer()
                }
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        section1Expanded.toggle()
                    }
                }
            }
            
            DisclosureGroup {
                
                Group {
                    HotelFacilityCard(image: "aegean", title: "Aegean Pool Bar", url: Constants.poolBar)
                    
                    HotelFacilityCard(image: "panorama", title: "Aura Beach Bar", url: Constants.beachBar)
                    
                    HotelFacilityCard(image: "meditteranean", title: "Meditteranean Restaurant", url: Constants.restaurant)
                    
                    HotelFacilityCard(image: "panorama", title: "Panorama Bistro", url: Constants.panorama)

                }
                .frame(height: 100)
                
            } label: {
                Text("Restaurants & Bars")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
            }
            
            
            DisclosureGroup {
                
                Group {
                    HotelFacilityCard(image: "beach", title: "Beach", url: Constants.beach)
                    
                    HotelFacilityCard(image: "pool", title: "Pools", url: Constants.pools)
                }
                .frame(height: 100)
                
            } label: {
                Text("Beach & Pools")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
            }
            
            DisclosureGroup {
                
                Group {
                    HotelFacilityCard(image: "melia", title: "Melia Spa", url: Constants.meliaSpa)
                    
                    HotelFacilityCard(image: "gym", title: "Fitness Center", url: Constants.fitness)
                    
                    HotelFacilityCard(image: "garden", title: "Garden", url: Constants.garden)
                }
                .frame(height: 100)
                
            } label: {
                Text("Wellness")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
            }
            
            DisclosureGroup {
                
                Group {
                    HotelFacilityCard(image: "services", title: "Hotel Services", url: Constants.services)
                    
                    HotelFacilityCard(image: "entertainment", title: "Entertainment", url: Constants.entertainment)
                }
                .frame(height: 100)

                
            } label: {
                Text("Services")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
            }
            
            Spacer()
            
        }
        .padding(.horizontal, 16)
    }
}


struct HotelFacilityCard: View {
    @Environment(\.openURL) var openURL
    var image: String
    var title: String
    var url: String
    
    var body: some View {
        Button {
            if let url = URL(string: url) {
                openURL(url)
            }
        } label: {
            ZStack(alignment: .bottomLeading) {
                Image(image)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: 100)
                    .background(Color.gray.opacity(0.3))
                    .clipped()
                
                LinearGradient(
                    colors: [.black.opacity(0.85), .black.opacity(0.4), .clear],
                    startPoint: .bottom,
                    endPoint: .top
                )
                
                VStack(alignment: .leading, spacing: 4) {
                    
                    Text(title)
                        .font(.callout)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .lineLimit(2)
                }
                .padding(12)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .frame(height: 100)
        .padding(.vertical, 4)
        .contentShape(RoundedRectangle(cornerRadius: 12))
    }
}
