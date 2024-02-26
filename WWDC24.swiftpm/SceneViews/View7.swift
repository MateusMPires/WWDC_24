//
//  SwiftUIView.swift
//  
//
//  Created by Mateus Martins Pires on 05/02/24.
//

import SwiftUI

struct View7: View {
    var body: some View {
        NavigationStack {
            
                VStack {
                    Text("You are now in NGC-015 exoplanet")
                        .font(FontManager.customFont(font: .orbitron, fontSize: .title))
                        .padding()
                    
                    //Spacer()
                    
                    Text("230 million light years away from Earth.")
                        .font(FontManager.customFont(font: .roboto, fontSize: .regular))
                    
                    Spacer()
                    
                    ZStack (alignment: .bottomTrailing){
                        
                    Image("Exoplanet")
                            .resizable()
                        //.stroke(lineWidth: 3)
                            .frame(width: width * 0.6, height: height * 0.69)
                            .rotationEffect(.degrees(90))
                            .clipShape(Circle())
                        
                    Spacer()
                    
                            NavigationLink(destination: View8_FindEarth()) {
                                ExploreButton(buttonTitle: "See from here")
                            }
                            //.offset(x: width * 0.3, y: -height * 0.5)
                            .frame(width: width * 0.2, height: height * 0.1, alignment: .center)
                            .offset(x: width * 0.15, y: height * 0.02)
                    }
                    .frame(width: width)
                    
                    Spacer()
                }
                .background(content: {
                    Image("Background")
                })
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    View7()
}
