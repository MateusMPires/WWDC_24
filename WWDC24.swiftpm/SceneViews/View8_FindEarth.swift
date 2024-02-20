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
    @Binding var changeScene: Bool?
    @ObservedObject var scene = SpriteKitGameScene()
    
    @State var screenSize: CGSize = .zero
    
    var body: some View {
            ZStack{
                Color.blue
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
                    changeScene = value
                }
            }
        }
}


#Preview {
    View8_FindEarth(changeScene: .constant(false))
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
