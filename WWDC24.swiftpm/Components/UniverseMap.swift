//
//  SwiftUIView.swift
//  
//
//  Created by Mateus Martins Pires on 23/01/24.
//

import SwiftUI

struct UniverseMap: View {
    
    let size: CGFloat = 350
    let count: Int = 10
    
    var body: some View {
        ZStack (alignment: .center){
            ForEach(0..<count, id: \.self) { i in
                    Circle()
                    .stroke(style: StrokeStyle(lineWidth: 2))
                    .frame(
                        width: size * ((3.5 / Double(count)) * Double(i)),
                        height: size * ((3.5 / Double(count)) * Double(i))
                    )
                    .rotation3DEffect(.init(degrees: 50), axis: (x: 1.0, y: 0, z: 0))
            }
            
            Circle()
                .frame(width: width * 0.02)
                .foregroundStyle(Color.blue)
                .offset(x: UIScreen.main.bounds.minX - 30, y: UIScreen.main.bounds.midY - 400)
            
            Circle()
                .frame(width: width * 0.02)
                .foregroundStyle(Color.red)
                .offset(x: UIScreen.main.bounds.midX - 230, y: UIScreen.main.bounds.midY - 400)
        }
        //.frame(width: width, height: height * 0.8)
        //.background(Color.red)
    }
}

#Preview {
    UniverseMap()
}
