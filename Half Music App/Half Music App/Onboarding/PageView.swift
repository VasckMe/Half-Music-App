//
//  PageView.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 11.11.22.
//

import SwiftUI

struct PageView: View {
    
    let title: String
    let subtitle: String
    let imageName: String
    let showDismissButton: Bool
    
    @State private var uiViewIsPresented = false
    
    var body: some View {
        VStack {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)
                .foregroundColor(Color.white)
                .padding()
            Text(title)
                .font(.system(size: 32))
                .foregroundColor(Color.white)
                .padding()
            
            Text(subtitle)
                .font(.system(size: 24))
                .foregroundColor(Color(.secondaryLabel))
                .padding()
            
            if showDismissButton {
                Button {
                    uiViewIsPresented.toggle()
                } label: {
                    Text("Get Started")
                        .foregroundColor(Color.white)
                        .font(.system(size: 20, weight: .semibold))
                        .frame(width: 150, height: 50)
                        .background(Color(ColorConstants.globalTintColor))
                        .cornerRadius(10)
                }
                
                .fullScreenCover(isPresented: $uiViewIsPresented) {
                    ViewControllerRepresentation()
                        .edgesIgnoringSafeArea(.all)
                }
            }
        }
    }
}

struct PageView_Previews: PreviewProvider {
    static var previews: some View {
        PageView(
            title: "Title",
            subtitle: "Subtitle",
            imageName: "house",
            showDismissButton: false
        )
    }
}
