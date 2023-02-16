//
//  OnboardingView.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 11.11.22.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        TabView {
            PageView(
                title: "Search audio",
                subtitle: "You can search audio in search list",
                imageName: "magnifyingglass",
                
                showDismissButton: false
            )
            PageView(
                title: "Add in library",
                subtitle: "Add your favourite audio tracks in library",
                imageName: "rectangle.stack",
                showDismissButton: false
            )
            PageView(
                title: "Create albums",
                subtitle: "Create and put in your audio tracks",
                imageName: "square.stack",
                showDismissButton: false
            )
            PageView(
                title: "Listen music",
                subtitle: "Start listening audio in our app",
                imageName: "music.note",
                showDismissButton: true
            )
        }
        .tabViewStyle(PageTabViewStyle())
        .background(Color.black)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

