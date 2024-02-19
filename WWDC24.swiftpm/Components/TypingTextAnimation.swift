//
//  File.swift
//  
//
//  Created by Mateus Martins Pires on 16/01/24.
//

import Foundation
import SwiftUI

struct TypingTextAnimation: View {
    @State private var displayedText: String = ""
    
    @State var timer: Timer?
    
    var fullText = ""
    
    var body: some View {
        
//        let cfURL = Bundle.main.url(forResource: "RobotoMono-Regular", withExtension: "ttf")! as CFURL
//            let _ = CTFontManagerRegisterFontsForURL(cfURL, CTFontManagerScope.process, nil)
        
        Text(displayedText)
            //.font(.custom("RobotoMono-Regular", size: 24))
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
