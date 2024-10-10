//
//  ContentView.swift
//  SnakeGame
//
//  Created by Juan Cante Jr. on 10/8/24.
//

import SwiftUI

struct ContentView: View {
    
    enum direction {
        case up, down, left, right
    }
    
    let minx = UIScreen.main.bounds.minX
    let maxx = UIScreen.main.bounds.maxX
    let miny = UIScreen.main.bounds.minY
    let maxy = UIScreen.main.bounds.maxY
    
    @State var startPos: CGPoint = .zero
    @State var isStarted = true
    @State var gameOver = false
    @State var dir = direction.down
    @State var posArray = [CGPoint(x:0, y:0)]
    @State var foodPos = CGPoint(x:0, y:0)
    let snakeSize:CGFloat = 10
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack{
            //background color
            Color(red: 0.7, green: 0.9, blue: 0.3)
            
            ZStack{
                ForEach(0..<posArray.count, id:\.self){index in
                    Rectangle()
                        .frame(width: self.snakeSize, height: self.snakeSize)
                        //snake color
                        .foregroundColor(Color(red: 0.1, green: 0.3, blue: 0.6))
                        .position(self.posArray[index])
                }
                if self.gameOver {
                    VStack(spacing: 10) {
                        Text("Game Over")
                        Text("Score: \(posArray.count-1)")
                        Button(action:{AppState.shared.gameID = UUID()}){
                            Text("New Game")
                                .foregroundColor(Color(red: 0.1, green: 0.3, blue: 0.6))
                        }
                    }.font(.largeTitle)
                }
            }.onAppear(){
                self.foodPos = changeRectPosition()
                self.posArray[0] = changeRectPosition()
            }
            .gesture(DragGesture()
                .onChanged{gesture in
                    if self.isStarted{
                        self.startPos = gesture.location
                        self.isStarted.toggle()
                    }
                }
                .onEnded{gesture in
                    let xDist = abs(gesture.location.x - self.startPos.x)
                    let yDist = abs(gesture.location.y - self.startPos.y)
                    if self.startPos.y < gesture.location.y && yDist > xDist {
                        self.dir = direction.down
                    } else if self.startPos.y > gesture.location.y && yDist > xDist {
                        self.dir = direction.up
                    } else if self.startPos.x > gesture.location.x && yDist < xDist {
                        self.dir = direction.right
                    } else if self.startPos.x < gesture.location.x && yDist < xDist {
                        self.dir = direction.left
                    }
                    self.isStarted.toggle()
                }
            )
            .onReceive(timer) { (_) in
                if !self.gameOver {
                    self.changeDirection()
                    if self.posArray[0] == self.foodPos {
                        self.posArray.append(self.posArray[0])
                        self.foodPos = self.changeRectPosition()
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    func changeDirection() {
        if self.posArray[0].x < minx || self.posArray[0].x > maxx && !gameOver {
            gameOver.toggle()
        } else if self.posArray[0].y < miny || self.posArray[0].y > maxy && !gameOver {
            gameOver.toggle()
        }
        
        var prev = posArray[0]
        if dir == .down {
            self.posArray[0].y += snakeSize
        } else if dir == .up {
            self.posArray[0].y -= snakeSize
        } else if dir == .left {
            self.posArray[0].x += snakeSize
        } else {
            self.posArray[0].x -= snakeSize
        }
        
        for index in 1..<posArray.count {
            let current = posArray[index]
            posArray[index] = prev
            prev = current
        }
    }
    func changeRectPosition() -> CGPoint {
        let rows = Int(maxx / snakeSize)
        let columns = Int(maxy / snakeSize)
        
        let randomX = Int.random(in: 1..<rows) * Int(snakeSize)
        let randomY = Int.random(in: 1..<columns) * Int(snakeSize)
        
        return CGPoint(x: randomX, y: randomY)
    }

}

#Preview {
    ContentView()
}
