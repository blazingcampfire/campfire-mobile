import SwiftUI
import SDWebImageSwiftUI

struct FireGIF: View {
    
    let fireGIF = "icons8-fire.gif"
    
    @State var isAnimating = true
    var body: some View {
        VStack {
            AnimatedImage(name: fireGIF, isAnimating: $isAnimating)
                .frame(width: 100, height: 100)
        }
    }
}
