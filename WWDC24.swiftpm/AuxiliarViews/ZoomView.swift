//
//  GyroView.swift
//  CoreMotion_Learning
//
//  Created by Mateus Martins Pires on 04/02/24.
//

import SwiftUI
import SceneKit

struct ZoomView: View {
    
    @ObservedObject private var viewModelCM = CoreMotionViewModel()
    
    @State var isZoomMaxed: Bool = false
    
    @State var rotationLocked: CGFloat = 0.5
    
    @State var isRingSelected: Bool = false
    
    // These variables are used on SceneView1 and SceneKitViewController to adjust some atributtes of SceneKitViewController
    @State var isUserInteractionEnabled: Bool? = .init(false)
    @State var scene: SCNScene? = .init(named: "Pangea4Scene.scn")
    @State var isRotatingEnabled: Bool? = .init(true)
    
    var degrees: [String] = ["0.5","1.0","1.5","2.0","2.5","3.0","3.5","4.0","4.5","5.0","5.5","6.0","6.5"]
        
    // Valor mínimo de zoom
    let minZoom: CGFloat = 0.1
    
    // Valor máximo de zoom
    let maxZoom: CGFloat = 0.9
    
    var body: some View {
        NavigationStack {
            VStack {
                            
                Text("Earth detected!")
                    .font(FontManager.customFont(font: .orbitron, fontSize: .title))
                    .padding()
                    //.font(.title)
                          
                Text("Rotate your device to adjust your telescope's zoom and focus")
                        .font(FontManager.customFont(font: .roboto, fontSize: .regular))
                
                ZStack(alignment: .center) {
                    
                    SceneKitViewController(scene: $scene, isInteractionEnabled: $isUserInteractionEnabled, isRotationEnabled: $isRotatingEnabled)
                        .frame(height: 350)
                        //.background(Color.red)
                        .scaleEffect(clampZoomValue(-viewModelCM.rotationValueZ * 0.00009), anchor: .center)
                        .blur(radius: clampBlurValue(-viewModelCM.rotationValueZ * 0.00009, minBlur: 3, maxBlur: 0))
                        .onChange(of: clampZoomValue(-viewModelCM.rotationValueZ * 0.00009)) { newValue in
                                                if newValue == maxZoom {
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                                isZoomMaxed = true
                                                        viewModelCM.stopUpdates()
                                                            }
                                                }
                                            }
                    
                    zoomRing
                        .frame(alignment: .center)
                        .onTapGesture {
                            isRingSelected.toggle()
                            verifyTap()
                        }
                }
                
                Spacer()
                
                ArrowButton(destination: View12())
            }
            .navigationDestination(isPresented: $isZoomMaxed) {
                View9()
            }
            .background {
                Image("StarsBackground")
                    .opacity(0.4)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    ZoomView()
}

extension ZoomView {
    
    var zoomRing: some View {
        GeometryReader { proxy in
            ZStack(alignment: .center) {
                
                Circle()
                    .stroke(isRingSelected ? Color.mint.opacity(1) : Color.gray.opacity(0.3), lineWidth: 4)
                    .frame(width: proxy.size.width * 0.37)
                
                ForEach(0..<60, id: \.self) { i in
                    Rectangle()
                        .fill(Color.primary)
                        .frame(width: 2, height: (i % 5) == 0 ? 15 : 5)
                        .offset(y: (proxy.size.width) / 5)
                        .rotationEffect(.init(degrees: Double(i * 6)))
                }
                
                ForEach(0..<12, id: \.self) { i in
                    Text("\(degrees[i])")
                        .offset(y: (-proxy.size.width) / 4.4)
                        .rotationEffect(.init(degrees: -Double(i * 30)))
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .rotationEffect(.degrees(clampRotationValue(
                viewModelCM.rotationValueZ <= 0 ? -viewModelCM.rotationValueZ / 180 : 0.5,
                minRotation: 0, // Substitua pelo valor mínimo desejado
                maxRotation: 55   // Substitua pelo valor máximo desejado
            )))
        }
    }
    
    func verifyTap() {
        if isRingSelected {
            viewModelCM.startGiroscope()
        } else {
            viewModelCM.stopUpdates()
        }
    }
    
    // Garante que o valor do zoom esteja dentro de limites específicos
    func clampZoomValue(_ value: CGFloat) -> CGFloat {
        return max(min(value, maxZoom), minZoom)
    }
    
    // Garante que o valor da rotação esteja dentro de limites específicos
    func clampRotationValue(_ value: Double, minRotation: Double, maxRotation: Double) -> Double {
        return max(min(value, maxRotation), minRotation)
    }
    
    // Garante que o valor da blur esteja dentro de limites específicos
    func clampBlurValue(_ value: Double, minBlur: Double, maxBlur: Double) -> Double {
        return max(min(value, maxBlur), minBlur)
    }
}
