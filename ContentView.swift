import SwiftUI

struct ContentView: View {
    @State private var menuItems: [MenuItem] = []
    @State private var searchText: String = ""
    @State private var showAlert: Bool = false
    @State private var selectedItemTitle: String = ""
    
    var filteredItems: [MenuItem] {
        let items = searchText.isEmpty 
            ? menuItems 
            : menuItems.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        
        return items.sorted { $0.title < $1.title }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search menu...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                List(filteredItems) { item in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.title).font(.headline)
                            Text(item.description).font(.subheadline).foregroundColor(.gray).lineLimit(2)
                            Text("$\(item.price)").font(.caption).bold()
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedItemTitle = item.title
                        showAlert = true
                    }
                }
            }
            .navigationTitle("Little Lemon Menu")
            .onAppear {
                fetchMenuData { fetchedItems in
                    self.menuItems = fetchedItems
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Order Confirmation"),
                    message: Text("Would you like to order \(selectedItemTitle)?"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}