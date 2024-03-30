import SwiftUI

//@main
struct YourAppNameApp: App {
    @StateObject private var viewModel = AppViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}

struct ContentView: View {
    @StateObject private var viewModel = AppViewModel()
    //@EnvironmentObject var viewModel: AppViewModel
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
            //.background(Image("lofiBackground").resizable().scaledToFill()) // Assuming you have a lo-fi themed background image
        }
        .environmentObject(viewModel)
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
    @EnvironmentObject var viewModel: AppViewModel
    @State private var excessInfo: String = ""
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            TextField("Enter excess produce info", text: $excessInfo)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Submit Excess Info") {
                viewModel.submitProduceInfo(info: excessInfo)
                showAlert = true // Show alert on submission
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .navigationTitle("Farmer")
        .alert(isPresented: $showAlert) { // Use the showAlert state to present an alert
                    Alert(
                        title: Text("Submission Confirmed"),
                        message: Text("Your excess produce info has been submitted successfully."),
                        dismissButton: .default(Text("OK")) {
                            // Optionally reset form or perform an action when dismissed
                            excessInfo = "" // Reset the text field
                        }
                    )
                }

    }
}


struct ShuttleView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        VStack {
            if let info = viewModel.excessProduceInfo {
                Text("Assigned Pickups: \(info)")
                    .padding()
            }
            
            if let countdown = viewModel.shuttleCountdown {
                Text("Shuttle ETA: \(countdown / 60) minutes")
                    .padding()
            } else {
                Text("No current pickups")
                    .padding()
            }
        }
        .padding()
        .navigationTitle("Shuttle")
    }
}


class AppViewModel: ObservableObject {
    @Published var excessProduceInfo: String? = nil
    @Published var shuttleCountdown: Int? = nil
    @Published var timer: Timer?
    @Published var submissionConfirmed: Bool = false

    
    func submitProduceInfo(info: String) {
        excessProduceInfo = info
        shuttleCountdown = 600 // 10 minutes in seconds
        submissionConfirmed = true // Confirm submission
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            if let countdown = self?.shuttleCountdown, countdown > 0 {
                self?.shuttleCountdown = countdown - 1
            } else {
                self?.timer?.invalidate()
                self?.timer = nil
                self?.submissionConfirmed = false
            }
        }
    }
}
