//
//  SwiftUIView.swift
//  
//
//  Created by Mateus Martins Pires on 05/02/24.
//

import SwiftUI

struct HologramSpeaking: View {
    @State private var displayedText: String = ""
    @State var fullText1 = ""
    @State var fullText2 = ""
    @State var timer: Timer?
    @Binding var isEndAnimation: Bool

    
    init(fullText1: String, fullText2: String, isEndAnimation: Binding<Bool>) {
            self.fullText1 = fullText1
            self.fullText2 = fullText2
            self._isEndAnimation = isEndAnimation
        }
    
    var body: some View {
                        
            HStack {
                Image("Hologram")
                    .resizable()
                    .scaledToFill()
                    .frame(width: width * 0.08, height: width * 0.1)
                    .padding()
                
                Text(displayedText)
                    .font(FontManager.customFont(font: .roboto, fontSize: .regular))
                    .padding()
                    .frame(width: width * 0.6)
                    .onAppear {
                        startTypingAnimation()
                    }
            }
            .overlay {
                Image("TextBalloon")
                    .resizable()
                    .frame(width: width * 0.75, height: width * 0.16)
            }
            .padding()
    }
    
    func startTypingAnimation() {
        var index = 0
        let initialDelay = 1.0 // Segundos de atraso antes de começar a segunda string
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            if index < fullText1.count {
                displayedText.append(fullText1[fullText1.index(fullText1.startIndex, offsetBy: index)])
            } else if index - fullText1.count >= Int(initialDelay / 0.05) {
                // Inicia a segunda string após o atraso inicial
                let index2 = index - fullText1.count - Int(initialDelay / 0.05)
                if index2 < fullText2.count {
                    displayedText.append(fullText2[fullText2.index(fullText2.startIndex, offsetBy: index2)])
                } else {
                    
                    // Após 2 segundos, isEndAnimation = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.isEndAnimation = true
                    }
                }
            }
            
            index += 1
        }
    }
}

//#Preview {
//    TwoStringTypingTextAnimation()
//}
