//
//  File.swift
//  
//
//  Created by Mateus Martins Pires on 05/02/24.
//

import Foundation
import SwiftUI

struct TypingTextAnimation: View {
    @State private var displayedText: String = ""
    
    @State var timer: Timer?
    
    var fullText = ""
    
    var body: some View {
        
        Text(displayedText)
            .padding()
            .onAppear {
                startTypingAnimation()
            }
    }
    
   func startTypingAnimation() {
        var index = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            guard index < fullText.count else {
                timer.invalidate()
                return
            }
            displayedText.append(fullText[fullText.index(fullText.startIndex, offsetBy: index)])
            index += 1
        }
    }
}
