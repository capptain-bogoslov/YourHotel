//
//  UserAuthModel.swift
//  YourHotel
//
//  Created by Batsioulas, Theologos on 19/1/25.
//

import Foundation
import FirebaseCore
import FirebaseAuth

class UserAuthModel: ObservableObject {
    
    @Published var userLoggedIn: Bool = false

    init() {
        if let user = Auth.auth().currentUser {
            self.userLoggedIn = true
        }
        
    }

    func sendVerificationCode(phoneNumber: String) async -> Bool {
        // Enable debug mode (ONLY for testing)
        if let authSettings = Auth.auth().settings {
            authSettings.isAppVerificationDisabledForTesting = false
        } else {
            print("Error: Firebase Auth settings are nil.")
        }

        // Localize message.
        Auth.auth().languageCode = Locale.current.language.languageCode?.identifier //"fr";
        
        do {
            let verificationId = try await PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber)
            UserDefaults.standard.set(verificationId, forKey: "authVerificationID")
            return true
        } catch {
            print("Error: in phone verification \(error.localizedDescription).")
            return false

        }
    }
    
    
    func verifyOTP(otpCode: String) {
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {
            print("No verification ID found.")
            return
        }

        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: otpCode)

        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                print("Verification failed: \(error.localizedDescription)")
            } else {
                self.userLoggedIn = true
                print("User logged in successfully!")
            }
        }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
            self.userLoggedIn = false
            print("user signed out")
        } catch {
            print("Error in sign out")
        }
    }
    
    // Function to get the authentication token
//    func fetchAuthToken() async {
//        
//        do {
//            let uid = try await Auth.auth().createUser(withEmail: "adam@eden.com", password: "123456")
//            
//            // Firebase function URL
//            let functionURL = URL(string: "https://generateauthtoken-llabs2fhda-uc.a.run.app")!
//            
//            // Prepare the request
//            var request = URLRequest(url: functionURL)
//            request.httpMethod = "POST"
//            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            
//            // Request body
//            let requestBody: [String: Any] = [
//                "uid": uid.user.uid,
//                "customClaims": [
//                    "admin": true,
//                    "premiumUser": true
//                ]
//            ]
//            
//            // Convert the request body to JSON data
//            do {
//                let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
//                request.httpBody = jsonData
//            } catch {
//                print("Error serializing JSON: \(error.localizedDescription)")
//                return
//            }
//            
//            // Perform the network request
//            let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                // Handle errors
//                if let error = error {
//                    return
//                }
//                
//                // Check the response and data
//                guard let data = data,
//                      let httpResponse = response as? HTTPURLResponse,
//                      httpResponse.statusCode == 200 else {
//                    let statusError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid server response"])
//                    return
//                }
//                
//                // Parse the response JSON
//                do {
//                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                       let token = json["token"] as? String {
//                        print(token)
//                    } else {
//                        let parseError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to parse token"])
//                    }
//                } catch {
//                }
//            }
//            
//            task.resume()
//            
//        } catch {
//            print("error")
//        }
//
//    }
}

