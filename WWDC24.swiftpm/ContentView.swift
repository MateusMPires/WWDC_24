import SwiftUI

// Global variable for width and height
var width = UIScreen.main.bounds.width
var height = UIScreen.main.bounds.height

struct ContentView: View {
    @State var bool: Bool? = false

    
    var body: some View {
        View8_FindEarth(showAsteroid: $bool)
            .preferredColorScheme(.dark)
    }
        
}
