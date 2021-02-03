import SwiftUI
import Foundation

struct SimpleLongPressGestureView: View {
    @GestureState var isDetectingLongPress = false

    var longPress: some Gesture {
        LongPressGesture(minimumDuration: 3)
            .updating($isDetectingLongPress) { currentState, gestureState, transaction in
                gestureState = currentState
            }
    }

    var body: some View {
        Circle()
            .fill(self.isDetectingLongPress ? Color.red : Color.green)
            .frame(width: 100, height: 100, alignment: .center)
            .gesture(longPress)
    }
}
