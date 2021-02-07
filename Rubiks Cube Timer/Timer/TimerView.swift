//
//  Timer.swift
//  Rubiks Cube Timer
//
//  Created by Havish Netla on 2/1/21.
//

import SwiftUI
import AudioToolbox


class Flags: ObservableObject {
    @Published var finishedLoading: Bool = false
    @Published var hasStarted: Bool = false
    @Published var hasFinished: Bool = false
    @Published var scramble: String = ""
    @Published var prevScramble: String = ""
}

struct TimerView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Solve.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Solve>
    
    
    @ObservedObject var timerManager = TimerManager()
    let generatorNew = Scrambler(moves: ["F", "B", "L", "R", "U", "D", "u", "d", "l", "r", "f", "b"], suffixes: ["2", "'"], len: 30)
    
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
                    // flags.scramble = generator.formatScramble(scramble: generator.generateScramble())
                    
                    flags.scramble = generatorNew.generateScramble()
                    print("here")
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
    
    @State var showingDetail = false

    var body: some View {
        let combined = delayPress.sequenced(before: longPress)
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom), content:{
            VStack(alignment: .center, spacing: nil, content: {
                HStack {
                    Spacer()
                    VStack {
                        Button(action: {
                            self.showingDetail.toggle()
                        }, label: {
                            Text("Button")
                        }).sheet(
                            isPresented: self.$showingDetail,
                        ) {
                            CubePicker()
                        }
                        
                        
                        Text(flags.scramble).font(.title2).fontWeight(.medium).foregroundColor(.white).multilineTextAlignment(.center)
                            .onTapGesture {
                                flags.scramble = generatorNew.generateScramble()
                            }
                    }
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
                //flags.scramble = generator.formatScramble(scramble: generator.generateScramble())
                flags.scramble = generatorNew.generateScramble()

            })
            
            VStack(alignment: .leading) {
                Text("Average: ").bold() + Text(average())
                Text("Ao5: ").bold() + Text(ao5())
                Text("Ao12: ").bold() + Text(ao12())
                Text("Best: ").bold() + Text(best())
            }.padding()
            .padding(.bottom)
        })
    }
    func asd() {
        print("asd")
    }
    private func addItem() {
        withAnimation {
            let newItem = Solve(context: viewContext)
            newItem.timestamp = Date()
            newItem.time = timerManager.elapsed
            newItem.scramble = flags.prevScramble
            
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
    
    func average() -> String {
        if items.count == 0 {
            return "-"
        }
        
        var average = 0.0
        
        for i in items {
            average += i.time
        }
        
        return String(format: "%.2f", average / Double(items.count))
    }
    
    func ao5() -> String {
        if items.count < 5 {
            return "-"
        }
        
        var average = 0.0
        
        for i in 0..<5 {
            average += items[i].time
        }
        
        return String(format: "%.2f", average / 5.0)
    }
    
    func ao12() -> String {
        if items.count < 12 {
            return "-"
        }
        
        var average = 0.0
        
        for i in 1..<12 {
            average += items[i].time
        }
        
        return String(format: "%.2f", average / 12.0)
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
}

struct Timer_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
