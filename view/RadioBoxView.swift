//
//  RadioBoxView.swift
//
//  Created by GVS276 on 01.06.2021.
//

import SwiftUI

struct RadioBoxView: View
{
    let items : [String]

    @State var selectedId: String = ""
    let callback: (String) -> ()
    
    var body: some View
    {
        VStack(spacing: 15)
        {
            ForEach(0..<items.count) { index in
                RadioButton(id: self.items[index],
                            selectedId: self.selectedId,
                            callback: onCallback)
            }
        }
    }
    
    func onCallback(id: String)
    {
        selectedId = id
        callback(id)
    }
}

struct RadioButton: View
{
    let id : String
    let selectedId : String
    let callback: (String)->()
    
    // settings:
    private let size: CGFloat = 20
    private let textSize: CGFloat = 16
    
    var body: some View
    {
        Button(action: {
            callback(id)
        }, label: {
            HStack(alignment: .center, spacing: 10)
            {
                Image(systemName: selectedId == id ? "largecircle.fill.circle" : "circle")
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                    .foregroundColor(selectedId == id ? .blue : .black)
                
                Text(id)
                    .foregroundColor(UIColors.colorAppTextHint)
                    .font(Font.system(size: textSize))
                
                Spacer()
            }
        })
    }
}
