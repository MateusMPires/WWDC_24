//
//  SwiftUIView.swift
//  
//
//  Created by Mateus Martins Pires on 23/01/24.
//

import SwiftUI

struct View5: View {
    
    @State var isEndAnimation: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Spacer()
                
                HologramSpeaking(fullText1: "See our planet Earth at the moment from other points of the universe.", fullText2: "", isEndAnimation: $isEndAnimation)
                    
                
                Spacer()
                
                NavigationLink(destination: View6()) {
                   ExploreButton(buttonTitle: "Explore")
                        .frame(width: width * 0.2, height: height * 0.1, alignment: .center)
                        .frame(maxWidth: .infinity, alignment: .bottomTrailing)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 60))
                }


                //.background(Color.red)
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
