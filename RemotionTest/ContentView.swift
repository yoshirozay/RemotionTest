//
//  ContentView.swift
//  RemotionTest
//
//  Created by Carson O'Sullivan on 5/26/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader {
            let size = $0.size
            Home(size: size)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
