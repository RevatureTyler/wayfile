import SwiftUI
import CoreLocation

struct SettingsView: View {
    @Environment(DriveRecorder.self) private var recorder

    private var accessText: String {
        switch recorder.authorization {
        case .notDetermined: "Not asked yet"
        case .restricted: "Restricted"
        case .denied: "Off"
        case .authorizedWhenInUse: "While using the app"
        case .authorizedAlways: "Always"
        @unknown default: "Unknown"
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    LabeledContent("Access", value: accessText)
                    if recorder.authorization == .notDetermined {
                        Button("Allow location") { recorder.requestPermission() }
                    } else if recorder.authorization == .denied {
                        Button("Open Settings") {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                            }
                        }
                    }
                } header: {
                    Text("Location")
                } footer: {
                    Text("Wayfile uses your location only to measure drives you record.")
                }

                Section("Your data") {
                    Text("Drives are stored on this phone only.")
                }

                Section("About") {
                    LabeledContent("Version", value: "0.1.0 (milestone 0)")
                }
            }
            .navigationTitle("Settings")
        }
    }
}
