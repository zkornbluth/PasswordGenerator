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
        MenuBarExtra {
                    ContentView()
                        .frame(width: 300, height: 300)
                        .overlay(alignment: .topTrailing) {
                                    Button(
                                        "Quit",
                                        systemImage: "xmark.circle.fill"
                                    ) {
                                        NSApp.terminate(nil)
                                    }
                                    .labelStyle(.iconOnly)
                                    .buttonStyle(.plain)
                                    .padding(6)
                                }
                                .frame(width: 300, height: 300)
        } label: {
            Label {
                    Text("Password Generator")
                } icon: {
                    let image: NSImage = {
                        let ratio = $0.size.height / $0.size.width
                        $0.size.height = 18
                        $0.size.width = 18 / ratio
                        return $0
                    }(NSImage(named: "MenuBarIcon")!)
                    
                    Image(nsImage: image)
                }
        }
        .menuBarExtraStyle(.window)
    }
}
