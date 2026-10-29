import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            DrivesView()
                .tabItem { Label("Drives", systemImage: "car.fill") }
            SummaryView()
                .tabItem { Label("Summary", systemImage: "chart.bar.fill") }
            SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape.fill") }
        }
    }
}
