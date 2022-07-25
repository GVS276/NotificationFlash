//
//  CheckBoxView.swift
//
//  Created by GVS276 on 18.03.2022.
//

import SwiftUI

struct CheckBoxView: View
{
    @Binding var checked: Bool
    
    var body: some View {
        Image(systemName: checked ? "checkmark.square.fill" : "square")
            .resizable()
            .frame(width: 20, height: 20)
            .foregroundColor(checked ? .blue : .secondary)
            .onTapGesture {
                self.checked.toggle()
            }
    }
}
