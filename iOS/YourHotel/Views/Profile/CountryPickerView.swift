//
//  CountryPhoneInputView.swift
//  YourHotel
//
//  Created by Batsioulas, Theologos on 27/3/25.
//

import SwiftUI

struct CountryPickerView: View {
    @EnvironmentObject private var auth: UserAuthModel
    @State private var selectedCountry: Country = Country.defaultCountry()
    @State private var isSheetPresented = false
    @State private var phone: String = ""
    @State private var disableButton: Bool = true
    @Binding  var codeSent: Bool
    @State private var buttonStatus: AnimatedButtonState = .normal
    @Binding var phoneComplete: String
    
    var body: some View {
        GeometryReader { geometry in

        VStack {
            HStack {
                Button(action: {
                    isSheetPresented.toggle()
                }) {
                    HStack {
                        Text(selectedCountry.flag)
                        Text(selectedCountry.dialCode)
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 5)
                    .frame(width: UIScreen.main.bounds.width / 3)
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                }
                .sheet(isPresented: $isSheetPresented) {
                    CountrySelectionSheet(selectedCountry: $selectedCountry)
                }

                TextField("Enter mobile number", text: $phone)
                    .keyboardType(.phonePad)
                    .padding(.vertical, 20)
                    .padding(.horizontal, 5)
                    .frame(maxWidth: .infinity)
                    .background(phone.isEmpty ? Color.gray.opacity(0.1) : Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            }
            .padding(.horizontal, 10)
            
            CustomAnimatedButton(buttonStatus: $buttonStatus, buttonType: .sendCode, buttonAction: sendCode)
                .padding(20)
                .opacity(disableButton ? 0.4 : 1.0)
                .disabled(disableButton)
            
        }
    }
    .onChange(of: phone) { newValue in
        disableButton = newValue.count < 5
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.clear) // Ensures gesture detection
    .contentShape(Rectangle()) // Expands tappable area
    .onTapGesture {
        hideKeyboard()
    }
    }
    
    func sendCode() {
        Task {
            let result = await auth.sendVerificationCode(phoneNumber: "\(selectedCountry.dialCode)\(phone)")
            if result {
                self.phoneComplete = "\(selectedCountry.dialCode)\(phone)"
                self.buttonStatus = .receiveResult
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.codeSent = result
                }
            }
        }

    }
}

struct CountrySelectionSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedCountry: Country
    @State private var searchText: String = ""
    
    var filteredCountries: [Country] {
        let lowercasedSearch = searchText.lowercased()
        return Country.allCountries.filter { country in
            searchText.isEmpty || country.name.lowercased().contains(lowercasedSearch)
        }
    }

    var body: some View {
        NavigationView {
            List(filteredCountries) { country in
                HStack {
                    if selectedCountry.code == country.code {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                    Text(country.flag)
                        .padding(.leading, selectedCountry.code == country.code ? 0 : 25)
                    Text(country.name)
                        .fontWeight(selectedCountry.code == country.code ? .bold : .regular)
                    Spacer()
                    Text(country.dialCode)
                        .foregroundColor(.gray)

                }
                .contentShape(Rectangle()) // Makes the whole row tappable
                .onTapGesture {
                    selectedCountry = country
                    dismiss()
                }
            }
            .navigationTitle("Select Country")
            .searchable(text: $searchText, prompt: "Search Country")
        }
    }
}

struct Country: Identifiable {
    let id = UUID()
    let name: String
    let dialCode: String
    let flag: String
    let code: String
    
    static func defaultCountry() -> Country {
        let region = Locale.current.region?.identifier ?? "US"
        return Country.allCountries.first(where: { $0.code == region }) ?? Country.allCountries.first!
    }
    
    static var allCountries: [Country] {
        var countries = [Country]()
        
        for localeCode in Locale.Region.isoRegions.map({ $0.identifier }) {
            guard
                let name = Locale.current.localizedString(forRegionCode: localeCode),
                let dialCode = Constants.countryDialCodes[localeCode]
            else { continue }
            
            let flag = localeCode
                .unicodeScalars
                .map { String(UnicodeScalar(127397 + $0.value)!) }
                .joined()
            
            countries.append(Country(
                name: name,
                dialCode: dialCode,
                flag: flag,
                code: localeCode
            ))
        }
        
        return countries.sorted { $0.name < $1.name }
    }
}
