//
//  HarvestHopperApp.swift
//  HarvestHopper
//
//  Created by Rhea Modey on 3/30/24.
//


import SwiftUI
import SwiftData

@main
struct HarvestHopperApp: App {
    @StateObject private var viewModel = AppViewModel()
    let locationManager = LocationManager()
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
