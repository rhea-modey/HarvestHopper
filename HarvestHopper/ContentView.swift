import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                NavigationLink(destination: ConsumerView()) {
                    RoleButton(text: "Consumer", color: .blue)
                }
                NavigationLink(destination: FarmerView()) {
                    RoleButton(text: "Farmer", color: .green)
                }
                NavigationLink(destination: ShuttleView()) {
                    RoleButton(text: "Shuttle", color: .orange)
                }
            }
            .padding()
            .navigationBarTitle("Select Role", displayMode: .inline)
            .background(Image("lofiBackground").resizable().scaledToFill()) // Assuming you have a lo-fi themed background image
        }
    }
}

struct RoleButton: View {
    var text: String
    var color: Color
    
    var body: some View {
        Text(text)
            .fontWeight(.medium)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(color.opacity(0.8))
            .cornerRadius(10)
            .shadow(radius: 5) // Adds a subtle shadow for depth
    }
}

struct ThemedButtonStyle: ButtonStyle {
    var color: Color
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(color.opacity(configuration.isPressed ? 0.5 : 0.8))
            .cornerRadius(10)
            .shadow(radius: 5)
    }
}

struct ThemeView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 20) { content }
            .padding()
            .background(Image("lofiBackground").resizable().scaledToFill()) // Background image
            .cornerRadius(15)
            .padding()
    }
}


struct ConsumerView: View {
    @State private var location: String = ""
    
    var body: some View {
        ThemeView {
            TextField("Enter your location", text: $location)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Get Shuttle ETA") {
                // Fetch shuttle ETA
            }
            .buttonStyle(ThemedButtonStyle(color: Color.blue))
            
            Text("Shuttle ETA: 10 minutes").padding()
        }
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
