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
    @Published var scramble: String = ""
}

struct TimerView: View {
    @ObservedObject var timerManager = TimerManager()
    let generator = ScrambleGenerator()
        
    @GestureState var isLoading = false
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
                    flags.scramble = generator.formatScramble(scramble: generator.generateScramble())
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
        
        VStack(alignment: .center, spacing: nil, content: {
            HStack {
                Spacer()
                Text(flags.scramble).font(.title2).fontWeight(.medium).foregroundColor(.white).multilineTextAlignment(.center)
                Spacer()
            }
            .padding(EdgeInsets(top: 100, leading: 20, bottom: 0, trailing: 20 ))
            Spacer()

            HStack {
                Spacer()
                Text("\(timerManager.formatedTime())")
                    .font(.system(size: 60))
                    .fontWeight(.semibold)
                    .foregroundColor(Color.white)

                Spacer()
            }.padding(.bottom, 100)
            Spacer()
        })
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .background(
            isLoading ? (flags.hasFinished ? Color.black : Color.red) :
                (!flags.finishedLoading ? Color.black :
                    (flags.hasStarted ? Color.black : Color.green)
                )
        )
        .gesture(combined)
        .edgesIgnoringSafeArea(.all)
        .onAppear(perform: {
            flags.scramble = generator.formatScramble(scramble: generator.generateScramble())
        })
    }
}

struct Timer_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
