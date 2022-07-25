//
//  SearchBarView.swift
//
//  Created by GVS276 on 21.04.2022.
//

import SwiftUI

class SearchBar: ObservableObject
{
    static let shared = SearchBar()
    @Published var showSearchBar = false
    @Published var search: String = ""
}

struct SearchBarView: View
{
    @StateObject private var searchBar = SearchBar.shared
    @State private var search: String = ""
    
    var body: some View
    {
        HStack(alignment: .center, spacing: 15)
        {
            Button {
                self.searchBar.showSearchBar = false
                self.searchBar.search = ""
            } label: {
                Image("action_back")
            }
            
            SearchTextField(text: self.$search)
                .frame(minHeight: 40)
                .padding(.horizontal, 10)
                .placeholder(shouldShow: self.search.isEmpty, title: "Enter a request", bg: .clear)
                .onChange(of: self.search) { value in
                    self.searchBar.search = value
                }
        }
        .frame(height: 42)
        .background(Color.white)
        .padding(.horizontal, 20)
        .onDisappear(perform: {
            self.search = ""
        })
        .removed(!self.searchBar.showSearchBar)
    }
}

private struct SearchTextField: UIViewRepresentable
{
    @Binding var text: String
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }
    
    func makeUIView(context: Context) -> UITextField {
        let textView = UITextField()
        textView.delegate = context.coordinator
        textView.autocapitalizationType = .none
        
        textView.textColor = UIColor.black
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = UIColor.clear
        
        textView.addTarget(context.coordinator, action: #selector(Coordinator.textViewDidChange), for: .editingChanged)
        return textView
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = self.text
        uiView.becomeFirstResponder()
    }
    
    class Coordinator: NSObject, UITextFieldDelegate
    {
        var text: Binding<String>
        
        init(text: Binding<String>) {
            self.text = text
        }
        
        @objc func textViewDidChange(_ textField: UITextField) {
            self.text.wrappedValue = textField.text ?? ""
       }
    }
}
