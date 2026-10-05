import SwiftUI

struct MainView: View {
    var body: some View {
        MenuView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}