import SwiftUI

struct DriveRow: View {
    let drive: Drive

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: drive.status.symbol)
                .foregroundStyle(drive.status == .business ? Color.accentColor : Color.secondary)
                .frame(minWidth: 28)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text(drive.startedAt, format: .dateTime.weekday().month().day().hour().minute())
                    .font(.headline)
                Text("\(miles(drive.distanceMeters)) · \(drive.status.title)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                if !drive.purpose.isEmpty {
                    Text(drive.purpose)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .accessibilityElement(children: .combine)
    }
}
