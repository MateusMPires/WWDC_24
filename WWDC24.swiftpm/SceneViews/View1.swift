//
//  SwiftUIView.swift
//  
//
//  Created by Mateus Martins Pires on 16/01/24.
//

import SwiftUI

struct View1: View {

    @State var isEndAnimation = false
    
    @State var widthProgress: CGFloat? = 0.0

    var body: some View {
        NavigationStack {
            VStack {
                
                Spacer()
                
                HologramSpeaking(fullText1: "If Aliens really exist, they wouldn't see Earth as it is today. ", fullText2: "But what does that mean?", isEndAnimation: $isEndAnimation)
                    
                
                Spacer()
                
                if isEndAnimation {
                        ArrowButton(destination: View2())
                        
                } else {
                    ArrowButton(destination: View2())
                        .hidden()
                }
                
            }
            .onAppear {
                withAnimation(.spring(duration: 0.8)) {
                    widthProgress = 1.0
                }
            }
            //.background(.red)
            .background(content: {
                Image("Background")
            })
        }
       
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    View1()
}

