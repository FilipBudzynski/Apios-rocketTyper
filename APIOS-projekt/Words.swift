//
//  Words.swift
//  APIOS-projekt
//
//  Created by Filip Budzynski on 19/06/2024.
//

import SwiftUI

let SAMPLE_WORDS = [
    "apple", "ant", "ball", "banana", "cat", "car", "dog", "desk", "elephant",
    "fish", "fox", "grape", "goat", "hat", "horse", "ice cream", "island", "jam",
    "jellyfish", "kite", "king", "lemon", "lion", "monkey", "mouse", "nest", "notebook",
    "orange", "ostrich", "pear", "peacock", "queen", "rabbit", "snake", "star", "table",
    "tiger", "umbrella", "unicorn", "vase", "violin", "whale", "xylophone", "yak", "zebra"
]

func getRandomWord() -> String {
    let randomIndex = Int.random(in: 0..<SAMPLE_WORDS.count)
    return SAMPLE_WORDS[randomIndex]
}

struct WordView: View {
    @State private var destination: CGPoint
    @State private var show: Bool = true
    @Binding var word: String
    @Binding var color: Color
    var duration: Double
    var parentSize: CGSize
    let initialDelay: Double

    init(parentSize: CGSize, word: Binding<String>, color: Binding<Color>, duration: Double, initialDelay: Double) {
        self.parentSize = parentSize
        self._word = word
        self._color = color
        self.duration = duration
        let randomX = CGFloat.random(in: 0...(parentSize.width))
        destination = CGPoint(x: randomX, y: 0)
        self.initialDelay = initialDelay
    }
    
    @State private var isVisible: Bool = false
    
    var body: some View {
        VStack{
            if isVisible{
                Text(word)
                    .font(.none)
                    .padding()
                    .foregroundColor(color)
                    .offset(x: destination.x, y: destination.y)
                    .onAppear {
                        self.destination.x = parentSize.width / 2 - 50
                        self.destination.y = parentSize.height - 100
                    }
                    .animation(.linear(duration: self.duration), value: destination)
            }
        }
        .onAppear(){
            DispatchQueue.main.asyncAfter(deadline: .now() + initialDelay) {
                self.isVisible = true
            }
        }
    }
}
