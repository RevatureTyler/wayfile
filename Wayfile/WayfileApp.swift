import SwiftUI
import SwiftData

@main
struct WayfileApp: App {
    @State private var recorder = DriveRecorder()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(recorder)
        }
        .modelContainer(for: Drive.self)
    }
}
