import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: ConsumerView()) {
                    Text("Consumer")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(10)
                }
                NavigationLink(destination: FarmerView()) {
                    Text("Farmer")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
                NavigationLink(destination: ShuttleView()) {
                    Text("Shuttle")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationBarTitle("Select Role", displayMode: .inline)
        }
    }
}

struct ConsumerView: View {
    @State private var location: String = ""
    
    var body: some View {
        VStack {
            TextField("Enter your location", text: $location)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Get Shuttle ETA") {
                // Implement functionality to fetch shuttle ETA
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            // Display ETA information here
            Text("Shuttle ETA: 10 minutes")
                .padding()
        }
        .padding()
        .navigationTitle("Consumer")
    }
}

struct FarmerView: View {
    @State private var excessInfo: String = ""
    
    var body: some View {
        VStack {
            TextField("Enter excess produce info", text: $excessInfo)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Submit Excess Info") {
                // Implement functionality to submit excess info
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            Text("Shuttle to farm ETA: 10 minutes")
                .padding()
        }
        .padding()
        .navigationTitle("Farmer")
    }
}

struct ShuttleView: View {
    // This could be a list or detailed view showing assigned pickups
    var body: some View {
        VStack {
            // Placeholder for received excess info and locations
            Text("Assigned Pickups")
                .padding()
            
            // Details for each assignment could be listed here
            Text("Farm XYZ: 10 minutes away")
                .padding()
        }
        .padding()
        .navigationTitle("Shuttle")
    }
}
