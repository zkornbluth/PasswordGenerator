//
//  ContentView.swift
//  PasswordGenerator
//
//  Created by Zach Kornbluth on 7/29/25.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @State private var includeNumbers = false
    @State private var numbers = "1234567890"
    @State private var includeUppercase = false
    @State private var uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    @State private var lowercase = "abcdefghijklmnopqrstuvwxyz"
    @State private var includeSpecial = false
    @State private var special = "~`!@#$%^&*()_-+={[}]|:;\\\"'<,>.?/"
    @State private var avoidRepeats = false
    @State private var length = 8.0
    @State private var isEditing = false
    @State private var password = ""
    @State private var passwordBlank = true
    
    func generatePassword() {
        var letters = lowercase
        if includeUppercase {
            letters += uppercase
        }
        if includeNumbers {
            letters += numbers
        }
        if includeSpecial {
            letters += special
        }
        var hasRepeats = true // Guarantee we run the loop once
        var newPassword = "" // local variable here so we don't save a bad password
        while hasRepeats {
            newPassword = String((0..<Int(length)).map{ _ in letters.randomElement()! })
            if avoidRepeats {
                hasRepeats = checkForRepeats(newPassword)
            } else { // Don't actually care about repeats, so just exit the loop and use this password
                hasRepeats = false
            }
        }
        password = newPassword
        passwordBlank = false
        copyToClipboard(password)
    }
    
    func checkForRepeats(_ str: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "(.)\\1\\1")
        // regex for the same character three times in a row
        return regex.firstMatch(in: str, range: NSRange(str.startIndex..., in: str)) != nil
    }
    
    func copyToClipboard(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Text("Length: \(Int(length))")
                    .alignmentGuide(.trailing) {d in d[.trailing]}
                Spacer()
            }
            Slider(
                value: $length,
                in: 8...25,
                step: 1
            ) {
                Text("")
            } minimumValueLabel: {
                Text("8")
            } maximumValueLabel: {
                Text("25")
            } onEditingChanged: { editing in
                isEditing = editing
            }
            Spacer()
            Toggle(isOn: $includeUppercase) {
                Text("Include uppercase letters")
            }
            Toggle(isOn: $includeNumbers) {
                Text("Include numbers")
            }
            Toggle(isOn: $includeSpecial) {
                Text("Include special characters")
            }
            Toggle(isOn: $avoidRepeats) {
                Text("Avoid repeating characters (3+)")
            }
            Spacer()
            HStack {
                Spacer()
                Button(action: generatePassword) {
                    Text("Generate")
                }
                Spacer()
            }
            .padding()
            HStack {
                Spacer()
                Text(passwordBlank ? " " : password)
                Button(action: {copyToClipboard(password)}) {
                    Text("Copy")
                }
                .opacity(passwordBlank ? 0 : 1)
                .disabled(passwordBlank)
                Spacer()
            }
            .frame(height: 20)
        }
        .padding()
        .frame(width: 300, height: 300)
    }
}

#Preview {
    ContentView()
        .navigationTitle("Password Generator")
}
