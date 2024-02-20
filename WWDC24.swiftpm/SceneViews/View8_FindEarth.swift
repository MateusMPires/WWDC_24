//
//  File.swift
//  
//
//  Created by Mateus Martins Pires on 01/02/24.
//

//
//  SkyView.swift
//  SchollarShip
//
//  Created by João Victor Bernardes Gracês on 04/12/23.
//

import SwiftUI
import SpriteKit

struct View8_FindEarth: View {
    @Binding var showAsteroid: Bool?
    @ObservedObject var scene = SpriteKitGameScene(size: CGSize(width: 500, height: 500))
    
    @State var screenSize: CGSize = .zero
    
    var body: some View {
            ZStack{
                Color.clear
                    .ignoresSafeArea()
                SpriteView(scene: scene, debugOptions: [.showsFPS, .showsNodeCount])
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
            }.getSize { size in
                screenSize = size
                // config scene
                scene.size = screenSize
                scene.scaleMode = .aspectFill
            }
            .onChange(of: scene.changeScene ){ value in
                withAnimation {
                    showAsteroid = value
                }
            }
        }
}


#Preview {
    View8_FindEarth(showAsteroid: .constant(false))
}



struct MeasureSizeModifier: ViewModifier {

    let callback: (CGSize) -> Void

    func body(content: Content) -> some View {
        content
            .background{
                GeometryReader{ geometry in
                    Color.clear
                        .onAppear{
                            callback(geometry.size)
                        }
                }
            }
    }
}
extension View {

    func getSize(_ callback: @escaping (CGSize) -> Void) -> some View{
        modifier(MeasureSizeModifier(callback: callback))
    }
}
