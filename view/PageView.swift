//
//  PageView.swift
//
//  Created by GVS276 on 29.03.2022.
//

import SwiftUI

struct PageView<Content: View>: UIViewControllerRepresentable
{
    let count: Int
    @Binding var currentPage: Int
    var callback: (_ previous: Int) -> ()
    @ViewBuilder let content: (Int) -> Content
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, callback: self.callback)
    }

    func makeUIViewController(context: Context) -> UIPageViewController
    {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator
        return pageViewController
    }

    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context)
    {
        let current = self.currentPage > self.count ? self.count - 1 : self.currentPage
        let visibleViewController = pageViewController.viewControllers?.first
        
        if let view = visibleViewController
        {
            if let index = context.coordinator.controllers.firstIndex(of: view), current != index
            {
                pageViewController.setViewControllers(
                    [context.coordinator.controllers[current]], direction: .forward, animated: false)
            }
        } else {
            pageViewController.setViewControllers(
                [context.coordinator.controllers[current]], direction: .forward, animated: false)
        }
    }
    
    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate
    {
        var parent: PageView
        var controllers = [UIViewController]()
        var callback: (_ previous: Int) -> ()
        
        init(_ parent: PageView, callback: @escaping (_ previous: Int) -> ())
        {
            self.parent = parent
            self.callback = callback
            for i in 0..<self.parent.count
            {
                let view = UIHostingController(rootView: self.parent.content(i))
                view.view.backgroundColor = .clear
                self.controllers.append(view)
            }
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
        {
            guard let index = self.controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index == 0 {
                return nil
            }
            return self.controllers[index - 1]
        }
                
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
        {
            guard let index = self.controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index == self.controllers.count - 1 {
                return nil
            }
            return self.controllers[index + 1]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
        {
            if completed,
               let visibleViewController = pageViewController.viewControllers?.first,
               let index = self.controllers.firstIndex(of: visibleViewController)
            {
                self.callback(self.parent.currentPage)
                self.parent.currentPage = index
            }
        }
    }
}
