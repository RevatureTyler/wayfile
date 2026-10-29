import SwiftUI
import SwiftData

struct SummaryView: View {
    @Query private var drives: [Drive]

    private var thisMonth: [Drive] {
        drives.filter { Calendar.current.isDate($0.startedAt, equalTo: .now, toGranularity: .month) }
    }

    private func total(_ status: DriveStatus) -> Double {
        thisMonth.filter { $0.status == status }.reduce(0) { $0 + $1.distanceMeters }
    }

    var body: some View {
        NavigationStack {
            List {
                Section("This month") {
                    LabeledContent("Business", value: miles(total(.business)))
                    LabeledContent("Personal", value: miles(total(.personal)))
                    LabeledContent("Unclassified", value: miles(total(.unclassified)))
                }
                Section {
                    Text("Deduction estimates and tax-ready reports are coming in the next milestone.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Summary")
        }
    }
}
