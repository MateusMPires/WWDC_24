//
//  SwiftUIView.swift
//  
//
//  Created by Mateus Martins Pires on 22/01/24.
//

import SwiftUI

struct RectShape: View {
    var body: some View {
        ZStack {
            Rectangle()
                .stroke(Color("Cyan"))
            
            Rectangle()
                .trim(from: 0, to: 0.2)
                .stroke(Color("Cyan"), style: StrokeStyle(lineWidth: 4))
            
            Rectangle()
                .trim(from: 0.45, to: 0.65)
                .stroke(Color("Cyan"), style: StrokeStyle(lineWidth: 4))
            
            Rectangle()
                .fill(Color("Cyan").opacity(0.3))
                .padding()
        }

    }
}

#Preview {
    RectShape()
}


// ⚠️ Isso aqui vou deixar para depois
// ⚠️ Esse vai ser o Shape da visualização de dados dos Planetas
struct RectangleGeometry: Shape {
    
    var insetAmount: Double = 50.0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: 12, y: rect.minY))
        
        path.addLine(to: CGPoint(x: insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: insetAmount - 12, y: rect.minY - 12))
        path.addLine(to: CGPoint(x: rect.maxX - insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))

        
        return path
    }
}
