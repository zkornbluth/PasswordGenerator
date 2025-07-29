//
//  PasswordGeneratorApp.swift
//  PasswordGenerator
//
//  Created by Zach Kornbluth on 7/29/25.
//

import SwiftUI

@main
struct PasswordGeneratorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .navigationTitle("Password Generator")
                .frame(width: 300, height: 300)
        }
        .defaultSize(CGSize(width: 300, height: 300))
    }
}
