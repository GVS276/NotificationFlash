//
//  ProfileHeaderView.swift
//
//  Created by GVS276 on 25.04.2022.
//

import SwiftUI

struct ProfileHeaderView<Content, Header>: View where Content: View, Header: View
{
    private let toolbarSize: CGFloat = 42
    private let collapsingToolbarSize: CGFloat = 300
    
    @State private var frame: CGRect? = nil
    @ViewBuilder let content: Content
    @ViewBuilder let header: Header
    
    var title: String
    var showBack: Bool = false
    var body: some View
    {
        ScrollView(.vertical, showsIndicators: false)
        {
            VStack
            {
                content
                    .frame(minHeight: self.getMinHeight())
            }
            .offset(y: self.collapsingToolbarSize)
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: ContentPreferenceKey.self, value: geometry.frame(in: .global))
                }.onPreferenceChange(ContentPreferenceKey.self) { value in
                    self.frame = value
                }
            )
            
            GeometryReader { geometry in
                ZStack
                {
                    header
                        .opacity(Double(min(((100 - self.getOffsetPercentage(geometry)) / 100), 1.0)))
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(Color.white)
                .overlay(self.bodyToolbar().offset(x: self.showBack ? self.getOffsetPercentage(geometry) * 42 / 100 : 0), alignment: .bottomLeading)
                .clipped()
                .offset(y: self.getOffset(geometry))
            }
            .frame(height: self.collapsingToolbarSize)
            .offset(y: -(self.frame?.height ?? UIScreen.main.bounds.height))
        }
        .edgesIgnoringSafeArea(.top)
    }
    
    private func bodyToolbar() -> some View
    {
        HStack
        {
            Text(self.title)
                .foregroundColor(.black)
                .font(.system(size: 18, weight: .bold))
                .lineLimit(1)
            Spacer()
        }
        .frame(height: self.toolbarSize)
        .padding(.horizontal, 20)
    }
    
    private func getMinHeight() -> CGFloat
    {
        let offscreen = (self.getOffscreen() / 1.5) - 10
        if self.showBack
        {
            let height = UIScreen.main.bounds.height
            return height - offscreen
        } else {
            let height = UIScreen.main.bounds.height - 60
            return height - offscreen
        }
    }
    
    private func getOffscreen() -> CGFloat
    {
        let toolbar = (self.toolbarSize * 2) + 10
        return self.collapsingToolbarSize - toolbar
    }
    
    private func getOffsetPercentage(_ geometry: GeometryProxy) -> CGFloat
    {
        let offscreen = self.getOffscreen()
        let offset = geometry.frame(in: .global).minY
        let correctOffset = offset <= -offscreen ? -offscreen : offset >= 0 ? 0 : offset
        return correctOffset * 100 / -offscreen
    }
    
    private func getOffset(_ geometry: GeometryProxy) -> CGFloat
    {
        let offscreen = self.getOffscreen()
        let offset = geometry.frame(in: .global).minY
        
        if offset < -offscreen {
            let position = abs(min(-offscreen, offset))
            return position - offscreen
        }
        
        if offset > 0
        {
            return -offset
        }
        
        return 0
    }
}

struct ContentPreferenceKey: PreferenceKey
{
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
