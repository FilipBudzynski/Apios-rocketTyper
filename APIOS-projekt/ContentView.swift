//
//  ContentView.swift
//  APIOS-projekt
//
//  Created by Filip Budzynski on 19/06/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var words: [String] = []
    @State private var wordColors: [Color] = []
    @State private var focusedWordIndex: Int? = nil
    @State private var currentInput = ""
    @State private var regenerateWordsID = UUID()
    @State private var timer: Timer?
    @State private var isGameStarted = false
    private var currentIndex = 0
    @State private var score = 0
    @State private var wordsCount = 5
    @State private var duration: Float = 15
    
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack{
                    ForEach(words.indices, id: \.self) { index in
                        WordView(
                            parentSize: geometry.size,
                            word: $words[index],
                            color: $wordColors[index],
                            duration: Double(self.duration),
                            initialDelay: Double(index) * Double.random(in: 0.5...1.0)
                        )
                    }
                }
                .id(regenerateWordsID)
                
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        if !isGameStarted {
                            Button(action: startGame) {
                                Text("Start Game")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            .cornerRadius(10)
                            .transition(.asymmetric(
                                insertion: AnyTransition.opacity.animation(.linear(duration: 1.0)),
                                removal: AnyTransition.opacity.animation(.linear(duration: 1.0))))
                        }
                        Spacer()
                    }
                    Spacer()
                }
                
                
                
                Group {
                    HStack {
                        Spacer()
                        Text("Score: \(score)")
                            .font(.title)
                            .padding()
                        Spacer()
                        
                        TextField("Wpisz literę", text: $currentInput)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .onChange(of: currentInput) { newValue in
                                checkInput(newValue)
                            }
                    }
                    
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                
                
            }
            
        }
        .padding()
        .onAppear {
            //generateWords()
        }
        .frame(maxWidth: 600, minHeight: 700)
    }
    
    private func startGame() {
        isGameStarted = true
        generateWords()
    }
    
    private func generateWords() {
        var selectedWords: [String] = []
        var usedStartingLetters: Set<Character> = []
        
        while selectedWords.count < wordsCount {
            let randomIndex = Int.random(in: 0..<SAMPLE_WORDS.count)
            let word = SAMPLE_WORDS[randomIndex]
            let startingLetter = word.first!
            
            if !usedStartingLetters.contains(startingLetter) {
                selectedWords.append(word)
                wordColors.append(.white)
                usedStartingLetters.insert(startingLetter)
            }
        }
        
        words = selectedWords
    }
    
    private func checkInput(_ newValue: String) {
        guard !newValue.isEmpty else { return }
        let char = newValue.last!
        
        if let focusedIndex = focusedWordIndex {
            updateFocusedWord(at: focusedIndex, with: char)
        } else {
            focusOnMatchingWord(with: char)
        }
        
        currentInput = ""
    }
    
    private func resetFocus() {
        focusedWordIndex = nil
    }
    
    private func updateFocusedWord(at index: Int, with char: Character) {
        print(words.count)
        if words[index].first == char {
            words[index].removeFirst()
            if words[index].isEmpty {
                score += 1
                resetFocus()
            }
        }
        
        if words.allSatisfy({ $0.isEmpty }) {
            words.removeAll()
            wordColors.removeAll()
            wordsCount += 2
            duration = duration * 0.8
            generateWords()
            regenerateWordsID = UUID()
        }
    }
    
    private func focusOnMatchingWord(with char: Character) {
        for (index, word) in words.enumerated() {
            if word.first == char {
                focusedWordIndex = index
                wordColors[index] = .orange
                updateFocusedWord(at: index, with: char)
                break
            }
        }
    }
    
    private func generateWordsIfNeeded() {
    }
    
    private func removeWord(at index: Int) {
        words.remove(at: index)
        wordColors.remove(at: index)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
