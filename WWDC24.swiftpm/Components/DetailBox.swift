//
//  SwiftUIView.swift
//  
//
//  Created by Mateus Martins Pires on 05/02/24.
//

import SwiftUI

struct DetailBox: View {
    
    @State var isAnimationActive = false
    
    @State var widthProgress: CGFloat = 1.0
        
    var body: some View {
        VStack {
            GeometryReader { geometry in
                VStack {
                    Rectangle()
                        .frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.6)
                        .hidden()
                    
                        .overlay {
                            detailedBox()
                                .frame(width: geometry.size.width * 0.3 * widthProgress, height: geometry.size.height * 0.6 * widthProgress)
                        }
                    
                    Spacer()
                    
                }
                //.frame(width: width, height: height)
                .onAppear {
                    withAnimation(.spring(duration: 0.5)) {
                        //widthProgress = 1.0
                    }
                }
            }
        }
        .background(Color.orange)
    }
    
    @ViewBuilder
    func detailedBox() -> some View {
        GeometryReader { geometry in
            VStack {
                Image("DetailedBox")
                    .resizable()
                    .overlay {
                        VStack {
                            Text("Earth")
                                .font(FontManager.customFont(font: .orbitron, fontSize: .regular))
                                .foregroundStyle(Color.white)
                                .padding(.top, 38)
                            
                            Spacer()
                            
                            VStack (alignment: .leading, spacing: 50) {
                                Text("Distance in miles:")
                                    .font(FontManager.customFont(font: .orbitron, fontSize: .caption))

                                    //.foregroundStyle(Color.blue)
                                Text("Biodiversity")
                                    .font(FontManager.customFont(font: .orbitron, fontSize: .caption))
                                
                                Text("Details: mesozoic era triassic period")
                                    .font(FontManager.customFont(font: .orbitron, fontSize: .caption))

                            }
                            //.padding()
                            .background(Color.green)
                            
                            Spacer()
                        }
                    }
            }
        }
    }
}

#Preview {
    DetailBox()
}
