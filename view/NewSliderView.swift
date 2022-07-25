//
//  NewSliderView.swift
//
//  Created by GVS276 on 19.07.2022.
//

import SwiftUI

struct NewSliderView: UIViewRepresentable
{
    private var value: Binding<Float>
    private var step: Float
    private var bounds: ClosedRange<Float>
    private var thumbColor: Color
    private var minTrackColor: Color
    private var maxTrackColor: Color
    
    init(value: Binding<Float>, in bounds: ClosedRange<Float> = 0...1, step: Float = 1,
         thumbColor: Color = .white, minTrackColor: Color = .blue, maxTrackColor: Color = .gray)
    {
        self.value = value
        self.step = step
        self.bounds = bounds
        self.thumbColor = thumbColor
        self.minTrackColor = minTrackColor
        self.maxTrackColor = maxTrackColor
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(value: self.value, step: self.step)
    }
    
    func makeUIView(context: Context) -> UISlider
    {
        let newValue = roundf(self.value.wrappedValue / self.step)
        let slider = UISlider()
        slider.value = newValue
        slider.thumbTintColor = UIColor(self.thumbColor)
        slider.minimumTrackTintColor = UIColor(self.minTrackColor)
        slider.maximumTrackTintColor = UIColor(self.maxTrackColor)
        slider.minimumValue = self.bounds.lowerBound
        slider.maximumValue = self.bounds.upperBound

        slider.addTarget(
            context.coordinator,
            action: #selector(Coordinator.valueChanged(_:)),
            for: .valueChanged
        )

        return slider
    }
    
    func updateUIView(_ uiView: UISlider, context: Context)
    {
        let newValue = roundf(self.value.wrappedValue / self.step)
        uiView.value = newValue
    }
    
    class Coordinator: NSObject
    {
        var value: Binding<Float>
        var step: Float

        init(value: Binding<Float>, step: Float) {
            self.step = step
            self.value = value
        }

        @objc func valueChanged(_ sender: UISlider) {
            let newValue = roundf(sender.value / self.step)
            self.value.wrappedValue = newValue
        }
    }
}
