//
//  Timer.swift
//  Rubiks Cube Timer
//
//  Created by Havish Netla on 2/1/21.
//

import SwiftUI
import AudioToolbox
import PartialSheet
import SSToastMessage

class Flags: ObservableObject {
    @Published var finishedLoading: Bool = false
    @Published var hasStarted: Bool = false
    @Published var hasFinished: Bool = false
    @Published var scramble: String = ""
    @Published var prevScramble: String = ""
}

struct TimerView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var partialSheetManager: PartialSheetManager
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Solve.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Solve>
    
    
    @ObservedObject var timerManager = TimerManager()
    let generator = ScrambleGenerator()
    
    @GestureState var isLoading = false
    @ObservedObject var flags = Flags()
    let impactMed = UIImpactFeedbackGenerator(style: .heavy)
    
    var delayPress: some Gesture {
        LongPressGesture(minimumDuration: 0.5)
            .updating($isLoading) { currentState, gestureState, transaction in
                gestureState = currentState
                if flags.hasStarted {
                    flags.hasFinished = true
                    flags.finishedLoading = false
                    flags.hasStarted = false
                    
                    timerManager.stop()
                    
                    flags.prevScramble = flags.scramble
                    
                    flags.scramble = generator.generateScramble(puzzle: Puzzle(rawValue: Int32(puzzleSelection))!)
                    UIApplication.shared.isIdleTimerDisabled = false
                    addItem()
                } else {
                    flags.hasFinished = false
                }
            }
            .onEnded({ _ in
                UIApplication.shared.isIdleTimerDisabled = true
                flags.finishedLoading = true
                impactMed.impactOccurred()
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
    @Binding var puzzleSelection: Int
    @Binding var sessionSelection: String
    
    @State var currPuzzle: Puzzle = Puzzle.threebythree
    
    var body: some View {
        let combined = delayPress.sequenced(before: longPress)
        HStack {
            ZStack {
                VStack {
                    CubePickerButton(puzzleSelection: $puzzleSelection, sessionSelection: $sessionSelection).padding(.top)
                    Text(flags.scramble).font(.title2).fontWeight(.medium).multilineTextAlignment(.center).padding(.top)
                        .onTapGesture {
                            flags.scramble = generator.generateScramble(puzzle: .threebythree)
                        }
                    
                    Spacer()
                    
                    HStack {
                        //Spacer()
                        StatsView(items: items.filter({$0.puzzle == Int32(puzzleSelection) && $0.session == sessionSelection})).padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 30))
                    }.padding(.bottom)
                }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                
                Spacer()
                
                Text("\(timerManager.formatedTime())")
                    .font(.system(size: 60))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(
                        isLoading ? (flags.hasFinished ? Color.primary : Color.red) :
                            (!flags.finishedLoading ? Color.primary :
                                (flags.hasStarted ? Color.primary : Color.green)
                            )
                    )
                Spacer()
                
            }
            .onAppear(perform: {
                //flags.scramble = generator.formatScramble(scramble: generator.generateScramble())
                flags.scramble = generator.generateScramble(puzzle: .threebythree)
            })
//            .background(
//                isLoading ? (flags.hasFinished ? Color.clear : Color.red) :
//                    (!flags.finishedLoading ? Color.clear :
//                        (flags.hasStarted ? Color.clear : Color.green)
//                    )
//            )
        }
        .contentShape(Rectangle())
        .background(Color.gray.opacity(0.0))
        .gesture(combined)
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Solve(context: viewContext)
            newItem.timestamp = Date()
            newItem.time = timerManager.elapsed
            newItem.scramble = flags.prevScramble
            newItem.puzzle = Int32(puzzleSelection)
            newItem.session = sessionSelection
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct StatsView: View {
    var items: [FetchedResults<Solve>.Element]
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Deviation: ").bold() + Text(deviation())
                Text("Mean: ").bold() + Text(mean())
                Text("Best: ").bold() + Text(best())
                Text("Count: ").bold() + Text(count() == "100" ? "💯" : count())
            }
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text("Ao5: ").bold() + Text(averageOf(count: 5))
                Text("Ao12: ").bold() + Text(averageOf(count: 12))
                Text("Ao50: ").bold() + Text(averageOf(count: 50))
                Text("Ao100: ").bold() + Text(averageOf(count: 100))
            }
        }
    }
    func count() -> String {
        return String(items.count)
    }
    
    func mean() -> String {
        if items.count == 0 {
            return "-"
        }
        
        var average = 0.0
        
        for i in 0..<items.count {
            average += items[i].time
        }
        
        return String(format: "%.2f", average / Double(items.count))
    }
    
    func deviation() -> String {
        if items.count == 0 {
            return "-"
        }
        
        var average = 0.0
        
        for i in 0..<items.count {
            average += items[i].time
        }
        
        var newAvg = 0.0
        for i in items {
            newAvg += pow((average - i.time), 2.0)
        }
        
        
        return String(format: "%.2f", sqrt(newAvg / Double(items.count)))
        
    }
    
    func averageOf(count: Int) -> String {
        if items.count < count {
            return "-"
        }
        
        var average = 0.0
        
        for i in 0..<count {
            average += items[i].time
        }
        
        return String(format: "%.2f", average / Double(count))
    }
    
    func best() -> String {
        if items.count == 0 {
            return "-"
        }
        
        var max = Double.infinity
        
        for i in items {
            if i.time < max {
                max = i.time
            }
        }
        
        return String(format: "%.2f", max)
    }
    
    func worst() -> String {
        if items.count == 0 {
            return "-"
        }
        
        var min = 0.0
        
        for i in items {
            if i.time > min {
                min = i.time
            }
        }
        
        return String(format: "%.2f", min)
    }
}

struct Timer_Previews: PreviewProvider {
    @State static var a = 0
    @State static var b: String = "Default"
    
    static var previews: some View {
        TimerView(puzzleSelection: $a, sessionSelection: $b)
    }
}
