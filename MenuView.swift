import SwiftUI
import CoreData

struct MenuView: View {
    @Environment(\.managedObjectContext) private var context

    @State private var searchText = ""
    @State private var selectedCategory: MenuCategory? = nil
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var orderedTitle = ""
    @State private var showOrderAlert = false

    var body: some View {
        VStack(spacing: 8) {
            LittleLemonLogo()

            HStack {
                Text("Dinner Menu").font(.title2.bold())
                if isLoading { ProgressView().padding(.leading, 4) }
            }

            searchField
            categoryChips

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }

            DishList(search: searchText, category: selectedCategory) { dish in
                orderedTitle = dish.title ?? "this dish"
                showOrderAlert = true
            }
            .refreshable { await loadMenu() }
        }
        .task { await loadMenu() }
        .alert("Order confirmed", isPresented: $showOrderAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your order for \(orderedTitle) has been placed.")
        }
    }

    private var searchField: some View {
        HStack {
            Image(systemName: "magnifyingglass").foregroundColor(.secondary)
            TextField("Search dishes", text: $searchText)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill").foregroundColor(.secondary)
                }
            }
        }
        .padding(10)
        .background(Color.gray.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal)
    }

    private var categoryChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                chip("All", isOn: selectedCategory == nil) { selectedCategory = nil }
                ForEach(MenuCategory.allCases) { category in
                    chip(category.rawValue, isOn: selectedCategory == category) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    private func chip(_ title: String, isOn: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isOn ? Color.lemonGreen : Color.gray.opacity(0.2))
                .foregroundColor(isOn ? .white : .primary)
                .clipShape(Capsule())
        }
    }

    @MainActor
    private func loadMenu() async {
        isLoading = true
        defer { isLoading = false }
        do {
            try await MenuService.refresh(in: context)
            errorMessage = nil
        } catch {
            errorMessage = "Couldn't update the menu, showing saved items. (\(error.localizedDescription))"
        }
    }
}