//
//  NotificationsHandler.swift
//  YourHotel
//
//  Created by Batsioulas, Theologos on 15/9/26.
//

// MARK: - Models
import SwiftUI
import FirebaseFirestore
import FirebaseCore


struct NotificationItem: Identifiable, Hashable, Codable {
    let id: String
    let month: String
    let key: Int
    let title: String
    let message: String
    let timestamp: Date
    let forCustomers: Bool
    let active: Bool
    let type: NotificationType
    
    
    enum NotificationType: String, Codable {
        case info
        case warning
        case error
        case success
    }
 

    init?(month: String, key: String, raw: Any) {
        guard
            let dict = raw as? [String: Any],
            let title = dict["title"] as? String,
            let message = dict["message"] as? String,
            let ts = dict["timestamp"] as? Timestamp,
            let forCustomers = dict["forCustomers"] as? Bool,
            let active = dict["active"] as? Bool,
            let type = dict["type"] as? String,
            let keyInt = Int(key)
        else { return nil }
 
        self.id = "\(month)-\(key)"
        self.month = month
        self.key = keyInt
        self.title = title
        self.message = message
        self.timestamp = ts.dateValue()
        self.forCustomers = forCustomers
        self.active = active
        self.type = NotificationType(rawValue: type) ?? .info
    }
}



// MARK: - Local Storage Manager
@Observable
final class LocalNotificationStorage {
    private let userDefaults = UserDefaults.standard
    private let notificationsKey = "app_notifications"
    private let readNotificationsKey = "read_notifications"
    
    var notifications: [NotificationItem] = []
    var readNotifications: [String] = []


    init() {
        loadNotifications()
        getReadNotifications()
    }

    func addLocalNotification(_ notification: NotificationItem) {
        var current = notifications
        current.insert(notification, at: 0)
        notifications = current
        saveNotifications()
    }
    
    func markAsRead(_ id: String) {
        readNotifications.append(id)
        UserDefaults.standard.set(readNotifications, forKey: "key")
    }
    
    func getReadNotifications() {
        readNotifications = UserDefaults.standard.array(forKey: "key") as? [String] ?? []
    }
    
    func deleteNotification(_ id: String) {
        notifications.removeAll { $0.id == id }
        saveNotifications()
    }
    
    func clearAll() {
        notifications = []
        saveNotifications()
    }
    
    private func saveNotifications() {
        if let encoded = try? JSONEncoder().encode(notifications) {
            userDefaults.set(encoded, forKey: notificationsKey)
        }
    }
    
    private func loadNotifications() {
        if let data = userDefaults.data(forKey: notificationsKey),
           let decoded = try? JSONDecoder().decode([NotificationItem].self, from: data) {
            notifications = decoded
        }
    }
}

// MARK: - Firestore Manager
@Observable
final class FirestoreNotificationManager {
    private let db = Firestore.firestore()
    
    @Published var notifications: [NotificationItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchNotifications(for month: String = "") async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
 
        do {
            let snapshot = try await db.collection("notifications").document(month).getDocument()
 
            var results: [NotificationItem] = []
            
            if let userData = snapshot.data() {
                for (key, rawValue) in userData {
                    if let item = NotificationItem(month: month, key: key, raw: rawValue) {
                        results.append(item)
                    }
                }
            }
 
            // Sort however makes sense for you; here: by month, then by key.
            results.sort { ($0.month, $0.key) < ($1.month, $1.key) }
            self.notifications.append(contentsOf: results)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
}

// MARK: - Combined Notifications Manager
@MainActor
final class NotificationsManager: ObservableObject {
    let localStorage = LocalNotificationStorage()
    let firestoreManager = FirestoreNotificationManager()
    
    @Published var notifications: [NotificationItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
 
    private let db = Firestore.firestore()
 
    init() {
        
        //1. Get notifications for last 2 months from Firestore
        let currentMonth = Calendar.current.component(.month, from: Date())
        let previousMonth = Calendar.current.component(.month, from: Calendar.current.date(byAdding: .month, value: -1, to: Date())!)
        Task {
            await firestoreManager.fetchNotifications(for: String(currentMonth))
            await firestoreManager.fetchNotifications(for: String(previousMonth))
            
            //2. Get local+remote and sorted notifications
            updateNotifications()
        }
    }
    
    
    func updateNotifications() {
        var combinedNotifications = firestoreManager.notifications + localStorage.notifications
        let readNotifications = localStorage.readNotifications
        let userCreationDate = UserDefaults.standard.object(forKey: "creation_date") as? Date ?? Date()
        combinedNotifications.sort { $0.timestamp > $1.timestamp }
        let filtered = combinedNotifications.filter( { !readNotifications.contains($0.id) && $0.timestamp > userCreationDate })
        self.notifications = filtered
    }

}

// MARK: - View
//struct NotificationsView: View {
//    @Environment(NotificationsManager.self) private var notificationsManager
//    
//    var body: some View {
//        NavigationStack {
//            if notificationsManager.allNotifications.isEmpty {
//                VStack {
//                    Image(systemName: "bell.slash")
//                        .font(.system(size: 50))
//                        .foregroundStyle(.gray)
//                    Text("No Notifications")
//                        .font(.headline)
//                }
//                .frame(maxHeight: .infinity, alignment: .center)
//            } else {
//                List {
//                    ForEach(notificationsManager.allNotifications) { notification in
//                        NotificationRow(notification: notification)
//                            .swipeActions(edge: .trailing) {
//                                Button(role: .destructive) {
//                                    Task {
//                                        await notificationsManager.deleteNotification(notification.id)
//                                    }
//                                } label: {
//                                    Label("Delete", systemImage: "trash")
//                                }
//                            }
//                            .swipeActions(edge: .leading) {
//                                Button {
//                                    Task {
//                                        await notificationsManager.markAsRead(notification.id)
//                                    }
//                                } label: {
//                                    Label("Read", systemImage: "envelope.circle")
//                                }
//                                .tint(.blue)
//                            }
//                    }
//                }
//            }
//        }
//        .navigationTitle("Notifications")
//        .toolbar {
//            ToolbarItem(placement: .primaryAction) {
//                Badge(value: 7)//notificationsManager.unreadCount)
//            }
//        }
//    }
//}

// MARK: - Notification Row
struct NotificationRow: View {
    let notification: NotificationItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(notification.title)
                        .font(.headline)
                        .bold()
                    
                    Text(notification.message)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    typeIcon
                    
                    Text(notification.timestamp.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 8)
        .opacity(1.0)
    }
    
    @ViewBuilder
    private var typeIcon: some View {
        switch notification.type {
        case .info:
            Image(systemName: "info.circle.fill")
                .foregroundStyle(.blue)
        case .warning:
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundStyle(.orange)
        case .error:
            Image(systemName: "xmark.circle.fill")
                .foregroundStyle(.red)
        case .success:
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
        }
    }
}
