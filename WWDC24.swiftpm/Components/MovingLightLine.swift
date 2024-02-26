//
//  SwiftUIView.swift
//  
//
//  Created by Mateus Martins Pires on 05/02/24.
//

import SwiftUI

struct MovingLightLine: View {
    @State private var progress: CGFloat = 1.0
    
    var body: some View {

        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                
                customRectangle()
                    .frame(width: geometry.size.width)
                    .overlay(alignment: .leading) {
                        Rectangle()
                            .frame(width: progress * geometry.size.width, height: 5)
                            .foregroundStyle(Color("LightBackgroundColor"))
                    }
                
                
                
            }
            .onAppear {
                withAnimation(.linear(duration: 2.5)) {
                    progress = 0.0
                }
            }
        }
        .frame(height: 4)
    }
    
    @ViewBuilder
    func customRectangle() -> some View {
        GeometryReader { _ in
                Rectangle()
                .trim(from: 0, to: 0.474)
                .stroke(.linearGradient(colors: [
                    .yellow,
                    .yellow.opacity(0.8),
                    .yellow.opacity(0.7),
                    .yellow.opacity(0.3)
                ], startPoint: .trailing, endPoint: .leading), style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, miterLimit: 1, dash: [10], dashPhase: 1))
        }
        .frame(height: 3)
    }
    
    var staticLight: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                
                customRectangle()
                    .frame(width: geometry.size.width)
                    .overlay(alignment: .leading) {
                        Rectangle()
                            .frame(width: progress * geometry.size.width, height: 5)
                            .foregroundStyle(Color("LightBackgroundColor"))
                    }
                
                
                
            }
            .onAppear {
                withAnimation(.linear(duration: 3.0)) {
                    progress = 1.0
                }
            }
        }
        .frame(height: 4)
    }
}

#Preview {
    MovingLightLine()
}
