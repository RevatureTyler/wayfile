import SwiftUI
import SwiftData

struct DrivesView: View {
    @Environment(\.modelContext) private var context
    @Environment(DriveRecorder.self) private var recorder
    @Query(sort: \Drive.startedAt, order: .reverse) private var drives: [Drive]

    @State private var classifiedCount = 0

    private var unclassifiedCount: Int {
        drives.filter { $0.status == .unclassified }.count
    }

    var body: some View {
        NavigationStack {
            Group {
                if drives.isEmpty && !recorder.isRecording {
                    ContentUnavailableView(
                        "No drives yet",
                        systemImage: "car",
                        description: Text("Take a drive and it will show up here.")
                    )
                } else {
                    list
                }
            }
            .navigationTitle("Drives")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    recordButton
                }
            }
            .navigationDestination(for: Drive.self) { drive in
                DriveDetailView(drive: drive)
            }
        }
        .sensoryFeedback(.success, trigger: classifiedCount)
    }

    private var list: some View {
        List {
            if recorder.isRecording, let start = recorder.startedAt {
                Section {
                    TimelineView(.periodic(from: .now, by: 1)) { timeline in
                        HStack {
                            Label("Recording", systemImage: "record.circle")
                                .foregroundStyle(.red)
                            Spacer()
                            Text("\(elapsed(since: start, now: timeline.date)) · \(miles(recorder.distanceMeters))")
                                .monospacedDigit()
                        }
                        .accessibilityElement(children: .combine)
                    }
                }
            }

            if unclassifiedCount > 0 {
                Section {
                    Text("\(unclassifiedCount) drives need a label")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Section {
                ForEach(drives) { drive in
                    NavigationLink(value: drive) {
                        DriveRow(drive: drive)
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button {
                            classify(drive, as: .business)
                        } label: {
                            Label("Business", systemImage: "briefcase.fill")
                        }
                        .tint(.accentColor)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button {
                            classify(drive, as: .personal)
                        } label: {
                            Label("Personal", systemImage: "person.fill")
                        }
                        .tint(.gray)
                    }
                    .accessibilityAction(named: "Mark as business") { classify(drive, as: .business) }
                    .accessibilityAction(named: "Mark as personal") { classify(drive, as: .personal) }
                }
            } footer: {
                if !drives.isEmpty {
                    Text("Swipe right for business, left for personal.")
                }
            }
        }
    }

    private var recordButton: some View {
        Button {
            if recorder.isRecording {
                recorder.stop(into: context)
            } else {
                recorder.start()
            }
        } label: {
            if recorder.isRecording {
                Label("Stop", systemImage: "stop.circle.fill")
            } else {
                Label("Record", systemImage: "record.circle")
            }
        }
    }

    private func classify(_ drive: Drive, as status: DriveStatus) {
        drive.status = status
        classifiedCount += 1
    }
}
