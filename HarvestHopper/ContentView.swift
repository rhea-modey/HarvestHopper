import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    var body: some View {
        NavigationSplitView {
            List {
                Section(header: Text("Roles")) {
                    NavigationLink(destination: ConsumerView()) {
                        Text("Consumer")
                    }
                    NavigationLink(destination: FarmerView()) {
                        Text("Farmer")
                    }
                    NavigationLink(destination: ShuttleView()) {
                        Text("Shuttle")
                    }
                }
                
                Section(header: Text("Items")) {
                    ForEach(items) { item in
                        NavigationLink {
                            Text("Item at \(item.timestamp, format: .dateTime)")
                        } label: {
                            Text(item.timestamp, format: .dateTime)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item or role")
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            newItem.timestamp = Date()
            try? modelContext.save()
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(modelContext.delete)
            try? modelContext.save()
        }
    }
}

// Placeholder Views for each role
struct ConsumerView: View {
    var body: some View {
        Text("Consumer Interface")
    }
}

struct FarmerView: View {
    var body: some View {
        Text("Farmer Interface")
    }
}

struct ShuttleView: View {
    var body: some View {
        Text("Shuttle Interface")
    }
}

// Placeholder for Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        // Add .modelContainer preview modifier if applicable
    }
}
