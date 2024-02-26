//
//  GyroView.swift
//  CoreMotion_Learning
//
//  Created by Mateus Martins Pires on 05/02/24.
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
    @State var scene: SCNScene? = .init(named: "IceageUVGeoOriginScene.scn")
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
                          
                Text("Rotate your device to the right to adjust the telescope zoom.")
                        .font(FontManager.customFont(font: .roboto, fontSize: .regular))
                
                ZStack(alignment: .center) {
                    
                    SceneKitViewController(scene: $scene, isInteractionEnabled: $isUserInteractionEnabled, isRotationEnabled: $isRotatingEnabled)
                        .frame(height: 350)
                        .scaleEffect(clampZoomValue(-viewModelCM.rotationValueZ * 0.00009), anchor: .center)
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
                    .hidden()
            }
            .navigationDestination(isPresented: $isZoomMaxed) {
                View12()
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
                    .stroke(Color.blue.opacity(0.3), lineWidth: 4)
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
                minRotation: 0,
                maxRotation: 55
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
    
    func clampZoomValue(_ value: CGFloat) -> CGFloat {
        return max(min(value, maxZoom), minZoom)
    }
    
    func clampRotationValue(_ value: Double, minRotation: Double, maxRotation: Double) -> Double {
        return max(min(value, maxRotation), minRotation)
    }
    
    func clampBlurValue(_ value: Double, minBlur: Double, maxBlur: Double) -> Double {
        return max(min(value, minBlur), maxBlur)
    }
}
