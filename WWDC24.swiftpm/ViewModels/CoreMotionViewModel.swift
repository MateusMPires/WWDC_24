//
//  CoreMotionViewModel.swift
//  CoreMotion_Learning
//
//  Created by Mateus Martins Pires on 05/02/24.
//

import Foundation
import CoreMotion

class CoreMotionViewModel: ObservableObject {
   
    @Published public var rotationValueX: Double = 0.0
    @Published public var rotationValueY: Double = 0.0
    @Published public var rotationValueZ: Double = 0.0

    private let motionManager = CMMotionManager()
    
    // Properties to hold the sensor values
    @Published var rotationRate: CMRotationRate = CMRotationRate()
    
    private let rotationRateThreshold: Double = 2.956108801299706
    
    init() {
        startGiroscope()
    }
    
    func startGiroscope() {
        
        motionManager.startDeviceMotionUpdates()
        
        if motionManager.isDeviceMotionAvailable && motionManager.isGyroAvailable {
            motionManager.gyroUpdateInterval = 0.01
            
            motionManager.startGyroUpdates(to: .main) { [weak self] (gyroData, error) in
                guard let self = self else { return }
                getRotation(gyroData: gyroData)
            }
        }
       
    }
    
    private func getRotation(gyroData: CMGyroData?){
            if let gyroData = gyroData {
                // Get rotation rate data
                self.rotationRate = gyroData.rotationRate
                
                let scaleFactor: Double = 100.0
                let rotationDelta = rotationRate.z * scaleFactor
                
                // Update publisher with the new sensor data
                self.rotationValueX = rotationRate.x
                self.rotationValueY = rotationRate.y
                self.rotationValueZ += rotationDelta

                
                print("X: \(gyroData.rotationRate.x)")
                print("Y: \(gyroData.rotationRate.y)")
                print("Z: \(gyroData.rotationRate.z)")
                
                #warning("Tirar isso aqui se for testar o FindEarth")
                // Check if the rotationRate.z has reached the threshold
//                if gyroData.rotationRate.z >= rotationRateThreshold {
//                    stopUpdates()
//                }
            }
        }
    
    // Function responsible for stopping the sensor updates
        func stopUpdates() {
            motionManager.stopDeviceMotionUpdates()
            motionManager.stopGyroUpdates()
            rotationValueZ = 0.0
        }
}
