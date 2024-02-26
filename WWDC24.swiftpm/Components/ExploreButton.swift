//
//  SwiftUIView.swift
//  
//
//  Created by Mateus Martins Pires on 05/02/24.
//

import SwiftUI

struct ExploreButton: View {
    
    @State var rotation: CGFloat = 0.0
    
    var buttonColor: Color = .blue
    
    var buttonTitle: String = ""
    var body: some View {
        ZStack {
            Rectangle()
                .stroke(Color.blue)
                .frame(width: width * 0.2, height: height * 0.1)
                .shadow(color:.white.opacity(0.5), radius: 10, x: 0, y: 0)
            
            Rectangle()
                .frame(width: width * 0.3, height: height * 0.3)
                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [buttonColor, buttonColor, Color.white, buttonColor]), startPoint: .top, endPoint: .bottom))
                .rotationEffect(.degrees(rotation))
                .mask {
                    Rectangle()
                        .stroke(style: StrokeStyle(lineWidth: 2))
                        .frame(width: width * 0.199, height: height * 0.099)
                }
            
            Rectangle()
                .frame(width: width * 0.195, height: height * 0.095)
                .foregroundStyle(buttonColor.opacity(0.3))
                .shadow(color:.white.opacity(0.5), radius: 10, x: 0, y: 0)
            
            Text(buttonTitle)
                .font(FontManager.customFont(font: .orbitron, fontSize: .regular))
                .foregroundStyle(Color.white)
        }
        .onAppear {
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}

#Preview {
    ExploreButton()
}
