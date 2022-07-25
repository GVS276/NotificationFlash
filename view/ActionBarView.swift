//
//  ActionBarView.swift
//
//  Created by GVS276 on 03.07.2021.
//

import SwiftUI

class ActionBarObject: ObservableObject
{
    static let shared = ActionBarObject()
    @Published var titleActionBar = ""
    @Published var showActionBar = false
    @Published var buttons : [ActionBarButton] = []
    @Published var onClick: ((_ id: String) -> Void)?
    
    func addButton(_ iconSet: String)
    {
        let btn = ActionBarButton()
        btn.iconSet = iconSet
        self.buttons.append(btn)
    }
    
    func visibleButton(_ iconSet: String, visible: Bool)
    {
        if let index = self.buttons.firstIndex(where: {$0.iconSet == iconSet}) {
            self.buttons[index].visible = visible
        }
    }
    
    func close()
    {
        self.buttons.removeAll()
    }
}

class ActionBarButton : Identifiable
{
    let id = UUID().uuidString
    var iconSet: String = ""
    var visible: Bool = true
}

struct ActionBarView: View
{
    @StateObject private var actionBarObject = ActionBarObject.shared
    
    var body: some View
    {
        HStack(alignment: .center, spacing: 15)
        {
            Button {
                if let click = actionBarObject.onClick
                {
                    click("close")
                }
            } label: {
                Image("action_close")
            }

            Text(actionBarObject.titleActionBar)
                .foregroundColor(.black)
                .font(.system(size: 18, weight: .bold, design: .default))
                .padding(.horizontal, 10)
            
            Spacer()
            
            ForEach(actionBarObject.buttons) { button in
                Button {
                    if let click = actionBarObject.onClick
                    {
                        click(button.iconSet)
                    }
                } label: {
                    Image(button.iconSet)
                }
                .removed(!button.visible)
            }
        }
        .frame(height: 42)
        .background(.white)
        .padding(.horizontal, 20)
        .removed(!actionBarObject.showActionBar)
    }
}
