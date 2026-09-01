import ActivityKit
import SwiftUI
import WidgetKit

/// Matches `AppColors.focusLight` / `playLight` in the Flutter app.
private struct TimerChrome {
  let tint: Color
  let panel: Color
  let icon: String

  init(mode: String) {
    let isPlay = mode == "play"
    tint = isPlay
      ? Color(red: 0.878, green: 0.482, blue: 0.298)
      : Color(red: 0.294, green: 0.545, blue: 0.831)
    panel = isPlay
      ? Color(red: 0.18, green: 0.10, blue: 0.07)
      : Color(red: 0.07, green: 0.12, blue: 0.20)
    icon = isPlay ? "gamecontroller.fill" : "book.fill"
  }
}

private func countingTimer(startedAt: Date, displayUntil: Date) -> Text {
  let end = max(displayUntil, startedAt.addingTimeInterval(1))
  return Text(
    timerInterval: startedAt...end,
    countsDown: false,
    showsHours: true
  )
  .monospacedDigit()
}

@main
struct TimerLiveActivity: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: TimerActivityAttributes.self) { context in
      LockScreenTimerView(context: context)
    } dynamicIsland: { context in
      let chrome = TimerChrome(mode: context.attributes.mode)
      let startedAt = context.state.startedAt
      let displayUntil = context.state.displayUntil

      return DynamicIsland {
        DynamicIslandExpandedRegion(.leading) {
          Image(systemName: chrome.icon)
            .foregroundStyle(chrome.tint)
            .imageScale(.medium)
        }
        DynamicIslandExpandedRegion(.trailing) {
          countingTimer(startedAt: startedAt, displayUntil: displayUntil)
            .font(.body.weight(.semibold))
            .foregroundStyle(chrome.tint)
            .lineLimit(1)
            .minimumScaleFactor(0.6)
        }
        DynamicIslandExpandedRegion(.center) {
          Text(context.attributes.title)
            .font(.caption.weight(.semibold))
        }
      } compactLeading: {
        Image(systemName: chrome.icon)
          .foregroundStyle(chrome.tint)
          .font(.system(size: 12, weight: .semibold))
      } compactTrailing: {
        countingTimer(startedAt: startedAt, displayUntil: displayUntil)
          .font(.system(size: 12, weight: .semibold))
          .foregroundStyle(chrome.tint)
          .lineLimit(1)
          .minimumScaleFactor(0.5)
          .frame(maxWidth: 52, alignment: .trailing)
      } minimal: {
        Image(systemName: chrome.icon)
          .foregroundStyle(chrome.tint)
          .font(.system(size: 12, weight: .semibold))
      }
      .keylineTint(chrome.tint)
    }
  }
}

private struct LockScreenTimerView: View {
  let context: ActivityViewContext<TimerActivityAttributes>

  var body: some View {
    let chrome = TimerChrome(mode: context.attributes.mode)

    HStack(spacing: 12) {
      Image(systemName: chrome.icon)
        .font(.title2)
        .foregroundStyle(chrome.tint)
      VStack(alignment: .leading, spacing: 2) {
        Text(context.attributes.title)
          .font(.subheadline.weight(.semibold))
          .foregroundStyle(.white.opacity(0.92))
        countingTimer(
          startedAt: context.state.startedAt,
          displayUntil: context.state.displayUntil
        )
        .font(.title.weight(.bold))
        .foregroundStyle(chrome.tint)
      }
      Spacer()
    }
    .padding()
    .activityBackgroundTint(chrome.panel.opacity(0.92))
  }
}
