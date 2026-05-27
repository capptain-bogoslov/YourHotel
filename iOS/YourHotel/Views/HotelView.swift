//
//  HotelView.swift
//  YourHotel
//
//  Created by Batsioulas, Theologos on 18/5/26.
//
import SwiftUI

struct HotelView: View {
    var body: some View {
        ScrollView {
            
            DisclosureGroup {
                
                HotelFacilityCard(image: "hotel1", title: "Double Superior")
                
                HotelFacilityCard(image: "hotel1", title: "Double Deluxe")
                
                HotelFacilityCard(image: "hotel1", title: "Premium Deluxe")
                
                HotelFacilityCard(image: "hotel1", title: "Junior Suite")

                HotelFacilityCard(image: "hotel1", title: "Family Suite")
                
                HotelFacilityCard(image: "hotel1", title: "Executive Suite")

                
            } label: {
                Text("Our Rooms")
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
    
    var image: String
    var title: String
    
    var body: some View {
        Button {
            print("tile tapped!")
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
            .padding(4)
            .frame(maxWidth: .infinity, maxHeight: 100)
        }
        .buttonStyle(.plain)
    }
}
