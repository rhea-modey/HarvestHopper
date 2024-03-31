import SwiftUI
import MapKit
import CoreLocation



struct ContentView: View {
    
    @StateObject private var viewModel = AppViewModel()
    //@StateObject private var locationManager = LocationManager()
    @ObservedObject var locationManager = LocationManager()
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
                NavigationLink(destination: ShuttleView(locationManager: locationManager)) {
                    RoleButton(text: "Shuttle", color: .orange)
                }
            }
            .padding()
            .environmentObject(viewModel) // Provide the view model as an environment object
            .environmentObject(locationManager)
            
            .background(Image("image").resizable().scaledToFill()) // Assuming you have a lo-fi themed background image
        
            
         
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

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.7796, longitude: -78.6382),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        region = MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    }
}


struct ConsumerView: View {
    @ObservedObject var locationManager = LocationManager()
    //@EnvironmentObject var locationManager: LocationManager

    @State private var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 35.7796, longitude: -78.6382), // Default to Raleigh
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )

    @State private var location: String = ""
    
    var body: some View {
        
        ThemeView {
            TextField("Enter your location", text: $location)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Map(coordinateRegion: $locationManager.region, showsUserLocation: true)
                            .frame(height: 300)
                            .cornerRadius(15)
                            .padding()


            
            Button("Get Shuttle ETA") {
                // Fetch shuttle ETA
            }
            .buttonStyle(ThemedButtonStyle(color: Color.blue))
            
            Text("Shuttle ETA: 10 minutes").padding()
        }
        .navigationTitle("Consumer")
        .background(Image("bottom3").resizable().scaledToFill())
    }
}

struct MapView: UIViewRepresentable {
    var pickupLocations: [String]

    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        // Remove previous annotations
        view.removeAnnotations(view.annotations)
        
        // Add new annotations for pickup locations
        for location in pickupLocations {
            let annotation = MKPointAnnotation()
            annotation.title = location
            view.addAnnotation(annotation)
        }
        
        // Center the map on the first pickup location
        if let firstLocation = pickupLocations.first,
           let coordinate = getLocationCoordinates(from: firstLocation) {
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            view.setRegion(region, animated: true)
        }
    }
    
    private func getLocationCoordinates(from address: String) -> CLLocationCoordinate2D? {
        let geocoder = CLGeocoder()
        var coordinates: CLLocationCoordinate2D?
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let placemark = placemarks?.first {
                coordinates = placemark.location?.coordinate
            }
        }
        return coordinates
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
                excessInfo = "" // Clear the text field after submission
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            List {
                ForEach(viewModel.excessProduceInfo, id: \.self) { info in
                    Text(info)
                }
            }
            .padding()
        }
        .navigationTitle("Farmer")
        .background(
            Image("bottom3")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        )
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Submission Confirmed"),
                message: Text("Your excess produce info has been submitted successfully."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct ShuttleView: View {
    @EnvironmentObject var viewModel: AppViewModel
    var locationManager: LocationManager
    
    private var regionBinding: Binding<MKCoordinateRegion> {
            Binding<MKCoordinateRegion>(
                get: { locationManager.region },
                set: { locationManager.region = $0 }
            )
        }
    
    var body: some View {
        VStack {
            
            if let countdown = viewModel.shuttleCountdown {
                            ForEach(viewModel.excessProduceInfo.indices, id: \.self) { index in
                                Text("Assigned Pickup: \(viewModel.excessProduceInfo[index]), ETA: \(countdown / 60) minutes")
                                    .padding()
                            }
                

                Map(coordinateRegion: regionBinding, showsUserLocation: true)
                                    .edgesIgnoringSafeArea(.all)
                                    .frame(height: 300)
                                    .cornerRadius(15)
                                    .padding()

                } else {
                    Text("No current pickups")
                        .padding()
                }
            
        }
        .navigationTitle("Shuttle")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image("bottom3")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        )
    }
    
  
}



class AppViewModel: ObservableObject {
    @Published var excessProduceInfo: [String] = [] // Change to array
    @Published var shuttleCountdown: Int? = nil
    @Published var timer: Timer?
    @Published var submissionConfirmed: Bool = false

    func submitProduceInfo(info: String) {
        excessProduceInfo.append(info) // Append to the array
        shuttleCountdown = 600 // 10 minutes in seconds
        submissionConfirmed = true // Confirm submission
        startCountdownTimer()
    }
    
    private func startCountdownTimer() {
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


