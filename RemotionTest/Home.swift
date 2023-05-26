//
//  Home.swift
//  RemotionTest
//
//  Created by Carson O'Sullivan on 5/26/23.
//

import SwiftUI

struct Home: View {
    var size: CGSize
    /// View Properties
    @State private var isExpanded: Bool = false
    @State private var scale: CGFloat = 1
    /// Offsets
    @State private var baseOffset: Bool = false
    @State private var secondaryOffset: Bool = false
    /// Images  will First Visible on the Base offset and continues to secondary Offset
    @State private var showImages: [Bool] = [false, false]
    var body: some View {
        VStack {
            /// Share Button
            /// Since we have 5 Buttons
            let shareButtons: CGFloat = 5
            /// Applying Padding
            let padding: CGFloat = 30
            let circleSize = min((size.width - padding) / shareButtons, 80)
            ZStack {
                GroupedShareButtons(size: circleSize, fillColor: false)
            }
            .frame(height: circleSize)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: isExpanded) { newValue in
            if newValue {
                /// First Displaying Base Offset Image
                withAnimation(.easeInOut(duration: 0.3).delay(0.1)) {
                    showImages[0] = true
                }
                /// Next Displaying Secondary Offset Image
                withAnimation(.easeInOut(duration: 0.3).delay(0.2)) {
                    showImages[1] = true
                }
            } else {
                /// No Delay for Hiding Image
                withAnimation(.easeInOut(duration: 0.15)) {
                    showImages[0] = false
                    showImages[1] = false
                }
            }
        }
        .rotationEffect(Angle(degrees: 90))
    }
    
    /// Share Button's
    @ViewBuilder
    func GroupedShareButtons(size: CGFloat, fillColor: Bool = true) -> some View {
        Group {
            ShareButton(size: size, tag: 0, imageName: "person1", showImage: showImages[1]) {
                return (baseOffset ? -size : 0) + (secondaryOffset ? -size : 0)
            }
            .onTapGesture {
                print("person1")
            }
            
            ShareButton(size: size, tag: 1, imageName: "person2", showImage: showImages[0]) {
                return (baseOffset ? -size : 0)
            }
            .onTapGesture {
                print("person2")
            }
            
            ShareButton(size: size, tag: 2, imageName: "person3", showImage: false) {
                return 0
            }
            /// Making it Top of all Views, for intial Tap
            .zIndex(100)
            .onTapGesture(perform: toggleShareButton)
            
            ShareButton(size: size, tag: 3, imageName: "person4", showImage: showImages[0]) {
                return (baseOffset ? size : 0)
            }
            .onTapGesture {
                print("person4")
            }
            
            ShareButton(size: size, tag: 4, imageName: "person5", showImage: showImages[1]) {
                return (baseOffset ? size : 0) + (secondaryOffset ? size : 0)
            }
            .onTapGesture {
                print("person5")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    /// Individual Share Button
    @ViewBuilder
    func ShareButton(size: CGFloat, tag: Int, imageName: String, showImage: Bool, offset: @escaping () -> CGFloat) -> some View {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .rotationEffect(Angle(degrees: isExpanded ? -90 : imageName == "person3" ? -90 : 90))
                .clipShape(Circle())
                .frame(width: isExpanded ? size : size/1.5, height: isExpanded ? size : size/1.5)
                .scaleEffect(scale)
                .contentShape(Circle())
                .offset(x: offset())
                .tag(tag)
                .overlay(
                       Circle()
                        .stroke(.black, lineWidth: 0.5)
                   )
    }
    
    /// Toggling Share Button
    func toggleShareButton() {
        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.4)) {
            isExpanded.toggle()
            scale = isExpanded ? 0.75 : 1
        }
        
        /// No Delay Needed for Closing
        DispatchQueue.main.asyncAfter(deadline: .now() + (isExpanded ? 0.15 : 0)) {
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.5, blendDuration: 0.8)) {
                secondaryOffset.toggle()
            }
        }
        
        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.8)) {
            baseOffset.toggle()
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
