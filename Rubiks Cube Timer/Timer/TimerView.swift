//
//  Timer.swift
//  Rubiks Cube Timer
//
//  Created by Havish Netla on 2/1/21.
//

import SwiftUI

struct TimerView: View {
    @ObservedObject var timerManager = TimerManager()
    
    @State var bColor = Color.white
    
    @State var hasStarted = false
    @State var isReleased = false
    @State var test = false
    @State var loading = false
        
    @GestureState var testing = false
    
    var delayPress: some Gesture {
        LongPressGesture(minimumDuration: 0.5)
            .updating($testing) { currentState, gestureState, transaction in
                gestureState = currentState
                if isReleased {
                    hasStarted = false
                    isReleased = false
                    loading = false
                    
                    timerManager.stop()
                    
//                    print("hasStarted: ", hasStarted, "isReleased: ", isReleased, "loading", loading, "testing: ", testing)
                } else {
                    loading = true
                }
                //print("hasStarted: ", hasStarted, "isReleased: ", isReleased, "loading", loading, "testing: ", testing)
            }
            .onEnded({ _ in
                print(".onEnded()")
                loading = false
                hasStarted = true
                
                if isReleased {
                    isReleased = false
                }
            })
    }
    
    var longPress: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged({ currentState in
//                loading = false
//                hasStarted = true

                //timerManager.reset()
                
                timerManager.reset()
            })
            .onEnded ({ finished in
                if isReleased {
                    timerManager.stop()
                    hasStarted = false
                    isReleased = false
                    loading = false
                } else {
                    timerManager.start()
                    
                    isReleased = true
                    hasStarted = true
                }
            })
    }
    

    
    var body: some View {
        let combined = delayPress.sequenced(before: longPress)

        VStack(alignment: .center, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
            Spacer()
            Text(isReleased ? "true" : "false")
            HStack {
                Spacer()
                Text("\(timerManager.elapsed)")
                    .font(.system(size: 60))
                    .fontWeight(.semibold)

                Spacer()
            }
            Spacer()
        })
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
//        .background(isDetectingLongPress ? Color.red : (completedLongPress ? Color(UIColor.green) : Color(UIColor.systemBackground)))
        .background(
            testing ? Color.green : Color.red
            //hasStarted ? Color.green : Color.red
        )
        /*
         isReleased ? Color.gray :
         ($testing.wrappedValue ? Color.red :
         (!hasStarted ? Color.gray :
             (isReleased ? Color.gray : Color.green)))
         */
        .gesture(combined)
        .onTapGesture {
            print("stop")
            //test = "testing"
        }
    }
}

struct Timer_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
