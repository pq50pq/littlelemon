import SwiftUI

struct DishRow: View {
    let dish: Dish

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: dish.image ?? "")) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(width: 64, height: 64)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 2) {
                Text(dish.title ?? "Unnamed dish").font(.headline)
                Text(dish.descriptionText ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            Spacer()
            Text("$" + (dish.price ?? "0")).font(.subheadline.bold())
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}