import SwiftUI

struct LittleLemonLogo: View {
    var body: some View {
        Group {
            if UIImage(named: "littleLemonLogo") != nil {
                Image("littleLemonLogo").resizable().scaledToFit()
            } else {
                Text("LITTLE LEMON")
                    .font(.system(size: 28, weight: .bold, design: .serif))
                    .foregroundColor(.lemonGreen)
            }
        }
        .frame(height: 50)
        .padding(.top, 8)
    }
}