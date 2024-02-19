//
//  SwiftUIView.swift
//  
//
//  Created by Mateus Martins Pires on 23/01/24.
//

import SwiftUI

struct View6: View {
    
    @State var isEndAnimation: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Text("This is a map of the Observable Universe")
                    .font(FontManager.customFont(font: .orbitron, fontSize: .title))
                //.background(Color.blue)
                    .padding()
                
                Spacer()
                
                Image("UniverseMap")
                    .resizable()
                //.scaledToFit()
                //.aspectRatio(contentMode: .fit)
                    .frame(width: width * 0.8, height: height * 0.8)
                    .scaleEffect(1.5)
                //.background(Color.red)
                    .overlay {
                        NavigationLink(destination: View7()) {
                            ExploreButton()
                        }
                        .scaleEffect(0.7)
                        .offset(x: width * 0.35, y: height * 0.107)
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
    View6()
}
