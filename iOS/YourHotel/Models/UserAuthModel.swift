//
//  UserAuthModel.swift
//  YourHotel
//
//  Created by Batsioulas, Theologos on 19/1/25.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

@MainActor
class UserAuthModel: ObservableObject {
    
    @Published var userLoggedIn: Bool = false
    @Published var user: User? = nil

    init() {
        
        Task {
            await checkAuthentication()
        }
    }
    
    //check user authentication status and receive user data
    func checkAuthentication() async {
        if Auth.auth().currentUser != nil {
            do {
                self.user = try await getUserDataAsync()
                if user != nil {
                    self.userLoggedIn = true
                }
            } catch {
                print("error: \(error.localizedDescription)")
            }
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
    
    
    func verifyOTP(otpCode: String, room: String, phone: String) async {
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {
            print("No verification ID found.")
            return
        }

        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: otpCode)

        do {
            //TODO: retrieve result to get additional user info
            try await Auth.auth().signIn(with: credential)
            
            await addUserInFirestore(phone: phone, room: room)
        } catch {
            print("error: \(error)")
        }
    }
    
    //add user in firestore
    func addUserInFirestore(phone: String? = nil, email: String? = nil, room: String) async {
        guard let userId = Auth.auth().currentUser?.uid else {
            self.userLoggedIn = false
            return }
        
        //get user fcm token
        let fcmToken = UserDefaults.standard.string(forKey: "FCMToken") ?? ""
        
        let db = Firestore.firestore()

        //add user in table "users"
        do {
            try await db.collection("users").document(userId).setData([
                "FCMToken" : fcmToken,
                "phone": phone ?? "",
                "email" : email ?? "",
                "authentication_method" : phone == nil ? "email" : "phone",
                "date_created" : DateHandler.shared.getDateFromDate(date: Date.now, format: "dd/MM/yyyy"),
                "room" : room
            ])

            do {
                self.user = try await getUserDataAsync()
                if user != nil {
                    self.userLoggedIn = true
                }
            } catch {
                print("error: \(error.localizedDescription)")
            }
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
    
    //get user data from firestore
    func getUserDataAsync() async throws -> User? {
        guard let userId = Auth.auth().currentUser?.uid else {
            self.userLoggedIn = false
            return nil
        }

        let db = Firestore.firestore()
        do {
            let userDocument = try await db.collection("users").document(userId).getDocument()
            
            let user = try userDocument.data(as: User.self)
            return user
        } catch {
            throw error
        }
    }
    
    //send a request to Firestore
    func sendRequestToFirestore(request: String) async throws {
        
        guard let userId = Auth.auth().currentUser?.uid, let user = self.user else {
            throw CustomError.userNotFound
        }
        
        let db = Firestore.firestore()
        do {
            
            try await db.collection("requests").document(user.room).setData([
                "requests": FieldValue.arrayUnion([[
                "request" : request,
                "userId" : userId,
                "user" : user.phone.isEmpty ? user.email : user.phone,
                "date": Timestamp(date: Date())
                ]])
            ], merge: true)
            
        } catch {
            print("error: \(error.localizedDescription)")
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

