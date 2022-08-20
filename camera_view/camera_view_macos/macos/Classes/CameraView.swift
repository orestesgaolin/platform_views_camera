//
//  CameraView.swift
//  camera_view_macos
//
//  Created by Dominik Roszkowski on 19/07/2022.
//

import SwiftUI

@available(macOS 11.00, *)
struct CameraView: View {
    
    @State var size: CGFloat = 1.0

    var image: CGImage?
    private let label = Text("Camera feed")
    
    var repeatingAnimation: Animation {
        Animation
            .easeInOut(duration: 2) //.easeIn, .easyOut, .linear, etc...
            .repeatForever()
    }
    
    var body: some View {

        VStack(alignment: .center) {
            Text("Hello from SwiftUI")
                .font(.headline)
            Text("within Flutter")
                .font(.body)
            ContentView()
        }
    }

}

@available(macOS 11.00, *)
struct CameraView_Previews: PreviewProvider {
    @available(macOS 11.00.0, *)
    static var previews: some View {
        CameraView()
    }
}
