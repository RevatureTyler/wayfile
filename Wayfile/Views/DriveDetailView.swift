import SwiftUI
import SwiftData

struct DriveDetailView: View {
    @Bindable var drive: Drive
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var confirmDelete = false

    private var statusBinding: Binding<DriveStatus> {
        Binding(get: { drive.status }, set: { drive.status = $0 })
    }

    private var timesAreValid: Bool { drive.endedAt > drive.startedAt }

    var body: some View {
        Form {
            Section("Type") {
                Picker("Type", selection: statusBinding) {
                    ForEach(DriveStatus.allCases) { status in
                        Label(status.title, systemImage: status.symbol).tag(status)
                    }
                }
                .pickerStyle(.inline)
                .labelsHidden()
            }

            Section("Details") {
                TextField("Purpose", text: $drive.purpose)
                TextField("Category", text: $drive.category)
                TextField("Notes", text: $drive.notes, axis: .vertical)
                    .lineLimit(1...4)
            }

            Section("Trip") {
                LabeledContent("Distance", value: miles(drive.distanceMeters))
                DatePicker("Start", selection: $drive.startedAt)
                DatePicker("End", selection: $drive.endedAt)
                if !timesAreValid {
                    Label("The end time must be after the start time.", systemImage: "exclamationmark.triangle.fill")
                        .font(.footnote)
                        .foregroundStyle(.red)
                }
            }

            Section {
                Button("Delete drive", role: .destructive) {
                    confirmDelete = true
                }
            }
        }
        .navigationTitle("Drive")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog("Delete this drive?", isPresented: $confirmDelete, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                context.delete(drive)
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}
