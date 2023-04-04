//
//  AddPillView.swift
//  PillReminderView
//
//  Created by Narada Utoro Dewo on 4/4/23.
//

import SwiftUI

struct AddPillView: View {
    // Binding to track the pill name entered by the user
    @State private var pillName: String = ""
    
    // Binding to track the pill dosage entered by the user
    @State private var pillDosage: String = ""
    
    // Binding to track the pill frequency entered by the user
    @State private var pillFrequency: String = ""
    
    // Binding to track whether the pill requires food entered by the user
    @State private var pillNeedsFood: Bool = false
    
    // Closure to call when the user taps the "Add" button
    var onAddPill: (Pill) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Pill Details")) {
                    TextField("Name", text: $pillName)
                    TextField("Dosage", text: $pillDosage)
                    TextField("Frequency", text: $pillFrequency)
                    Toggle("Requires food", isOn: $pillNeedsFood)
                }
                
                Button(action: {
                    // Create a new pill object and call the onAddPill closure
                    let newPill = Pill(name: pillName, dosage: pillDosage, frequency: pillFrequency, needsFood: pillNeedsFood)
                    self.onAddPill(newPill)
                }, label: {
                    Text("Add")
                })
            }
            .navigationBarTitle("Add Pill")
        }
    }
}

