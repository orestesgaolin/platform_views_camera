//
//  SwiftUIView.swift
//  camera_view_ios
//
//  Created by Dominik Roszkowski on 20/08/2022.
//

import SwiftUI

@available(iOS 13.0, *)
struct SwiftUIView: View {
    var body: some View {
        VStack(alignment: .center) {
            Text("Hello from SwiftUI")
                .font(.headline)
            Text("within Flutter")
                .font(.body)
        }
    }
}

@available(iOS 13.0, *)
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
