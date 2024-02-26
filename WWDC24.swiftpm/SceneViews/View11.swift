//
//  SwiftUIView.swift
//  
//
//  Created by Mateus Martins Pires on 05/02/24.
//

import SwiftUI

struct View11: View {
    @State var isEndAnimation: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Text("Let's take a look from a closer point.")
                    .font(FontManager.customFont(font: .orbitron, fontSize: .title))
                //.background(Color.blue)
                    .padding()
                
                Spacer()
                
                Image("UniverseMapBlue")
                    .resizable()
                //.scaledToFit()
                //.aspectRatio(contentMode: .fit)
                    .frame(width: width * 0.8, height: height * 0.8)
                    .scaleEffect(1.5)
                //.background(Color.red)
                    .overlay {
                        NavigationLink(destination: ZoomView()) {
                            ExploreButton(buttonColor: .cyan, buttonTitle: "View from here")
                        }
                        .scaleEffect(0.7)
                        .offset(x: width * 0.165, y: height * -0.17)
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
    View11()
}
