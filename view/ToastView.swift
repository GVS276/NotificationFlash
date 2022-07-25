//
//  ToastView.swift
//
//  Created by GVS276 on 11.11.2021.
//

import SwiftUI

class Toast: ObservableObject
{
    static let shared = Toast()
    @Published var showToast = false
    @Published var textToast = ""
    
    func show(text: String)
    {
        self.textToast = text
        withAnimation {
            self.showToast = true
        }
    }
}

struct ToastView: View
{
    @StateObject private var model = Toast.shared
    
    var body: some View {
        HStack
        {
            Text(self.model.textToast)
                .lineLimit(6)
                .multilineTextAlignment(.center)
                .padding(15)
                .foregroundColor(Color.white)
                .font(Font.system(
                        size: 16,
                        design: .default))
                .background(Rectangle()
                                .fill(Color.black)
                                .opacity(0.5)
                                .cornerRadius(20))
        }
        .padding(.bottom, 25)
        .padding(.horizontal, 15)
        .transition(AnyTransition.opacity.animation(.linear(duration: 0.5)))
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    self.model.showToast = false
                }
            }
        })
        .removed(!self.model.showToast)
    }
}
