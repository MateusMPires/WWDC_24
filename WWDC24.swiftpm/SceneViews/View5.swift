//
//  SwiftUIView.swift
//  
//
//  Created by Mateus Martins Pires on 05/02/24.
//

import SwiftUI

struct View5: View {
    
    @State var isEndAnimation: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Spacer()
                
                HologramSpeaking(fullText1: "Now let's see what Earth looks like at this moment from other points in the universe.", fullText2: "", isEndAnimation: $isEndAnimation)
                    
                
                Spacer()
                
                if isEndAnimation {
                    NavigationLink(destination: View6()) {
                       ExploreButton(buttonTitle: "Explore")
                            .frame(width: width * 0.2, height: height * 0.1, alignment: .center)
                            .frame(maxWidth: .infinity, alignment: .bottomTrailing)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 60))
                    }
                } else {
                    ExploreButton(buttonTitle: "Explore")
                         .frame(width: width * 0.2, height: height * 0.1, alignment: .center)
                         .frame(maxWidth: .infinity, alignment: .bottomTrailing)
                         .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 60))
                         .hidden()
                }
    
            }
            .background(content: {
                Image("Background")
            })
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    View5()
}
