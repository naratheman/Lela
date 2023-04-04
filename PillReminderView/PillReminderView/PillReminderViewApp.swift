//
//  PillReminderViewApp.swift
//  PillReminderView
//
//  Created by Narada Utoro Dewo on 4/4/23.
//

import SwiftUI

@main
struct PillReminderApp: App {
    var body: some Scene {
        WindowGroup {
            PillReminderView()
        }
    }
}

struct Pill: Identifiable {
    var id = UUID()
    var name: String
    var dosage: String
    var frequency: String
    var needsFood: Bool
}
import SwiftUI
import UserNotifications

struct PillReminderView: View {
    // Array of pill objects
    @State var pills: [Pill] = [
        Pill(name: "Aspirin", dosage: "81mg", frequency: "Once a day", needsFood: false),
        Pill(name: "Ibuprofen", dosage: "200mg", frequency: "Twice a day", needsFood: true),
        Pill(name: "Acetaminophen", dosage: "500mg", frequency: "Three times a day", needsFood: false)
    ]
    
    // Modal state for adding a new pill
    @State var isAddingPill = false
    
    var body: some View {
        VStack {
            Text("Pill Reminder")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            List {
                ForEach(pills) { pill in
                    VStack(alignment: .leading) {
                        Text("\(pill.name) - \(pill.dosage)")
                            .font(.headline)
                        Text("\(pill.frequency) - \(pill.needsFood ? "Requires food" : "Does not require food")")
                            .font(.subheadline)
                    }
                    .contextMenu {
                        Button(action: {
                            self.deletePill(pill: pill)
                        }, label: {
                            Text("Delete")
                            Image(systemName: "trash")
                        })
                    }
                }
            }
            
            Button(action: {
                self.isAddingPill = true
            }, label: {
                Text("Add")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            })
            .sheet(isPresented: $isAddingPill, content: {
                AddPillView(onAddPill: { newPill in
                    self.pills.append(newPill)
                    self.isAddingPill = false
                    self.scheduleReminder(for: newPill)
                })
            })
            .padding()
        }
        .onAppear {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
        }
    }
    
    // Function to delete a pill from the list
    func deletePill(pill: Pill) {
        if let index = self.pills.firstIndex(where: { $0.id == pill.id }) {
            self.pills.remove(at: index)
        }
    }
    
    // Function to schedule a reminder notification for a pill
    func scheduleReminder(for pill: Pill) {
        let content = UNMutableNotificationContent()
        content.title = "Time to take your \(pill.name)"
        content.body = "It's time to take your \(pill.name) - don't forget!"
        content.sound = .default
        
        let frequency = pill.frequency.lowercased()
        let timesPerDay = Int(String(frequency.first ?? "1")) ?? 1
        
        for i in 1...timesPerDay {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(i * 60), repeats: false)
            let request = UNNotificationRequest(identifier: "\(pill.id.uuidString)-\(i)", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
    }
}
