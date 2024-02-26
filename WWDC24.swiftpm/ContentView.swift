import SwiftUI

// Global variable for width and height
var width: CGFloat = 0
var height: CGFloat = 0


struct ContentView: View {
    
    init() {
        width = UIScreen.main.bounds.width
        height = UIScreen.main.bounds.height
    }
    
    var body: some View {
        View1()
            .preferredColorScheme(.dark)
    }
        
}
