//
//  File.swift
//  
//
//  Created by Mateus Martins Pires on 05/02/24.
//
//
//

import SwiftUI
import SpriteKit

struct View8_FindEarth: View {
    @State var changeScene: Bool = false
    @ObservedObject var scene = SpriteKitGameScene()
    
    @State var screenSize: CGSize = .zero
    
    var body: some View {
        NavigationStack {
            ZStack{
                Color.blue
                    .ignoresSafeArea()
                SpriteView(scene: scene)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
            }
            .navigationDestination(isPresented: $changeScene) {
                View9()
            }
        }
        .navigationBarBackButtonHidden()
        .getSize { size in
            screenSize = size
            // config scene
            scene.size = screenSize
            scene.scaleMode = .aspectFill
        }
        .onChange(of: scene.changeScene ){ value in
                changeScene = value
                print("Valor mudado")
            
        }
    }
}


#Preview {
    View8_FindEarth(changeScene: (false))
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
