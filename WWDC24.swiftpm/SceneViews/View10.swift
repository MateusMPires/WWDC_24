//
//  SwiftUIView.swift
//  
//
//  Created by Mateus Martins Pires on 04/02/24.
//

import SwiftUI
import SceneKit

struct View10: View {
    
    @State private var timer: Timer?
    @State private var secondsRemaining: Int = 15
    @State private var isTimerExpired: Bool = false
    
    @State var widthProgress: CGFloat = 0.0
    
    @State private var isRotating = false

    // These variables are used on SceneView1 and SceneKitViewController to adjust some atributtes of SceneKitViewController
    @State var isRotatingEnabled: Bool? = .init(true)
    @State var isUserInteractionEnabled: Bool? = .init(true)
    @State var scene: SCNScene? = .init(named: "Pangea4Scene.scn")
    
    var degrees: [String] = ["0.5","1.0","1.5","2.0","2.5","3.0","3.5","4.0","4.5","5.0","5.5","6.0","6.5"]

    var body: some View {
        NavigationStack {
            
            VStack {
                Text("Interact with Earth")
                    .font(FontManager.customFont(font: .orbitron, fontSize: .title))
                    .padding()
                
                //Spacer()
                
                Text("230 million light years from Earth")
                    .font(FontManager.customFont(font: .roboto, fontSize: .regular))
                
                Spacer()
                
                HStack {
                    
                    zoomRing
                        .scaleEffect(1.3)
                        .overlay {
                            SceneKitViewController(scene: $scene, isInteractionEnabled: $isUserInteractionEnabled, isRotationEnabled: $isRotatingEnabled)
                                .frame(width: width * 0.3, height: height * 0.4)
                                //.background(Color.blue)

                                //.rotationEffect(.degrees(isRotating ? 360 : 0), anchor: .center)
                        }
                        .frame(width: width * 0.65)
                        //.background(Color.green)

                        
                    
                    //Spacer()
                            VStack {
                                Rectangle()
                                    .frame(width: width * 0.2, height: height * 0.5)
                                    .hidden()
                                
                                    .overlay {
                                        detailedBox()
                                            .frame(width: width * 0.26 * widthProgress, height: height * 0.5 * widthProgress)
                                            //.background(Color.green)
                                            .scaleEffect(1.1)
                                    }
                                
                                Spacer(minLength: 0)
                                
                            }
                            .frame(width: width * 0.3, height: height * 0.3)
                            .onAppear {
                                withAnimation(.spring(duration: 0.8)) {
                                    widthProgress = 1.0
                                }
                                withAnimation(.linear(duration: 25).repeatForever(autoreverses: false)) {
                                    isRotating = true
                                }
                            }
                    
                    
                }
                //.background(Color.red)

                Spacer()
                
                VStack {
                    Text("Time")
                        .font(FontManager.customFont(font: .roboto, fontSize: .caption))
                    
                    Text("\(secondsRemaining) seconds")
                        .font(FontManager.customFont(font: .orbitron, fontSize: .regular))
                        .onAppear {
                            startTimer()
                        }
                        .onDisappear {
                            timer?.invalidate()
                        }
                        .onTapGesture {
                            navigateToNextView()
                        }
                }
                .frame(maxWidth: .infinity, alignment: .bottomTrailing)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 60))
            }
            .navigationDestination(isPresented: $isTimerExpired) {
                View11()
            }
            .background(content: {
                Image("Background")
            })
        }
        .navigationBarBackButtonHidden()
    }
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if secondsRemaining > 0 {
                secondsRemaining -= 1
            } else {
                timer?.invalidate()
                isTimerExpired = true
            }
        }
    }
    
    func navigateToNextView() {
        timer?.invalidate()
        isTimerExpired = true
    }
    
    @ViewBuilder
    func detailedBox() -> some View {
        GeometryReader { geometry in
            VStack {
                Image("DetailedBox")
                    .resizable()
                    
            }
        }
    }

}

extension View10 {
    var zoomRing: some View {
        GeometryReader { proxy in
            ZStack(alignment: .center) {
                
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 4)
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
//            .rotationEffect(.degrees(clampRotationValue(
//                viewModelCM.rotationValueZ <= 0 ? -viewModelCM.rotationValueZ / 180 : 0.5,
//                minRotation: 0, // Substitua pelo valor mínimo desejado
//                maxRotation: 55   // Substitua pelo valor máximo desejado
//            )))
        }
    }
}

#Preview {
    View10()
}
