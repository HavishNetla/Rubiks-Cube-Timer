//
//  Timer.swift
//  Rubiks Cube Timer
//
//  Created by Havish Netla on 2/1/21.
//

import SwiftUI


class Flags: ObservableObject {
    @Published var finishedLoading: Bool = false
    @Published var hasStarted: Bool = false
    @Published var hasFinished: Bool = false
}

struct TimerView: View {
    @ObservedObject var timerManager = TimerManager()
    
    @State var bColor = Color.white
    
    //@State var hasStarted = false
    @State var isReleased = false
    @State var test = false
    @State var loading = false
        
    @GestureState var isLoading = false
    @State var finishedLoading = false
    @State var hasStarted = false
    
    @ObservedObject var flags = Flags()
    
    var delayPress: some Gesture {
        LongPressGesture(minimumDuration: 0.5)
            .updating($isLoading) { currentState, gestureState, transaction in
                gestureState = currentState
                
                if flags.hasStarted {
                    flags.hasFinished = true
                    flags.finishedLoading = false
                    flags.hasStarted = false
                    
                    timerManager.stop()
                } else {
                    flags.hasFinished = false
                }
            }
            .onEnded({ _ in
                flags.finishedLoading = true
            })
    }
    
    var longPress: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged({ currentState in
                //inishedLoading = true
            })
            .onEnded ({ finished in
                flags.hasStarted = true
                timerManager.reset()
                timerManager.start()
            })
    }
    

    
    var body: some View {
        let combined = delayPress.sequenced(before: longPress)

        VStack(alignment: .center, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
            Spacer()
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
        .background(
            isLoading ? (flags.hasFinished ? Color.gray : Color.red) :
                (!flags.finishedLoading ? Color.gray :
                    (flags.hasStarted ? Color.gray : Color.green)
                )
        )
        .gesture(combined)
       
    }
}

struct Timer_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
