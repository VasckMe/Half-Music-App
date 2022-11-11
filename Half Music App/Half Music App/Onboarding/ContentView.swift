//
//  ContentView.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 11.11.22.
//

import SwiftUI

struct ContentView: View {
    @State var shouldShowOnBoarding: Bool = false
    
    var body: some View {
        VStack {
            NavigationView {
                VStack {
                    Text("Main app")
                        .padding()
                }
                .navigationTitle("Home")
            }
            .fullScreenCover(isPresented: $shouldShowOnBoarding) {
                OnboardingView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
