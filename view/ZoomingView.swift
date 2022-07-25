//
//  ZoomingView.swift
//
//  Created by GVS276 on 29.03.2022.
//

import SwiftUI

struct ZoomingView<Content: View>: UIViewRepresentable
{
    @ViewBuilder
    let content: Content
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(hostingController: UIHostingController(rootView: self.content))
    }
    
    func makeUIView(context: Context) -> UIScrollView
    {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.delegate = context.coordinator
        scrollView.maximumZoomScale = 10
        scrollView.minimumZoomScale = 1
        scrollView.bouncesZoom = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false

        let hostedView = context.coordinator.hostingController.view!
        hostedView.backgroundColor = .clear
        hostedView.translatesAutoresizingMaskIntoConstraints = true
        hostedView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hostedView.frame = scrollView.bounds
        scrollView.addSubview(hostedView)
        
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context)
    {
        context.coordinator.hostingController.rootView = self.content
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate
    {
        var hostingController: UIHostingController<Content>

        init(hostingController: UIHostingController<Content>)
        {
            self.hostingController = hostingController
        }

        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return hostingController.view
        }
    }
}
