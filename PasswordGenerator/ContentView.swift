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
    @State private var includeLowercase = true
    @State private var lowercase = "abcdefghijklmnopqrstuvwxyz"
    @State private var includeSpecial = false
    @State private var special = "!@.-_*"
    @State private var avoidRepeats = false
    @State private var length = 8.0
    @State private var isEditing = false
    @State private var password = ""
    @State private var passwordBlank = true
    
    func generatePassword() {
        var letters = ""
        if includeLowercase {
            letters += lowercase
        }
        if includeUppercase {
            letters += uppercase
        }
        if includeNumbers {
            letters += numbers
        }
        if includeSpecial {
            letters += special
        }
        
        var gotGoodPassword = false
        var newPassword = ""
        while !gotGoodPassword {
            newPassword = String((0..<Int(length)).map{ _ in letters.randomElement()! })
            // Check for repeats if avoidRepeats, if true, try again
            if avoidRepeats {
                let hasRepeats = checkForRepeats(newPassword)
                if hasRepeats {
                    continue
                }
            }
            
            // Check that all 'include' types are actually in the password
            let hasAllTypes = checkForIncluded(newPassword, includeUppercase: includeUppercase, includeLowercase: includeLowercase, includeNumbers: includeNumbers, includeSpecial: includeSpecial)
            if hasAllTypes {
                gotGoodPassword = true
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
    
    func checkForIncluded(_ str: String, includeUppercase: Bool, includeLowercase: Bool, includeNumbers: Bool, includeSpecial: Bool) -> Bool {
        if includeUppercase { // User checked includeUppercase
            var containsUppercase = false
            let uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
            for char in uppercase {
                if str.contains(char) {
                    containsUppercase = true
                    break
                }
            }
            if !containsUppercase { // checked all uppercase chars, none in str
                return false
            }
        }
        
        if includeLowercase { // User checked includeLowercase
            var containsLowercase = false
            let lowercase = "abcdefghijklmnopqrstuvwxyz"
            for char in lowercase {
                if str.contains(char) {
                    containsLowercase = true
                    break
                }
            }
            if !containsLowercase { // checked all lowercase chars, none in str
                return false
            }
        }
        
        if includeNumbers { // User checked includeNumbers
            var containsNumber = false
            let numbers = "1234567890"
            for char in numbers {
                if str.contains(char) {
                    containsNumber = true
                    break
                }
            }
            if !containsNumber { // checked all numbers, none in str
                return false
            }
        }
        
        if includeSpecial { // User checked includeSpecial
            var containsSpecial = false
            let special = "!@.-_*"
            for char in special {
                if str.contains(char) {
                    containsSpecial = true
                    break
                }
            }
            if !containsSpecial { // checked all special chars, none in str
                return false
            }
        }
        return true
    }
    
    func copyToClipboard(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }
    
    private func handleToggleChange(for binding: Binding<Bool>, newValue: Bool) {
            // If the toggle was just turned OFF (newValue is false)
            if !newValue {
                let checkedCount = [includeUppercase, includeLowercase, includeNumbers, includeSpecial].filter { $0 }.count

                // If, after this toggle was turned off, there are now zero true toggles,
                // revert this toggle back to true.
                if checkedCount == 0 {
                    // We need to dispatch this to the next run loop cycle
                    // to avoid modifying state during a view update.
                    DispatchQueue.main.async {
                        binding.wrappedValue = true
                    }
                    print("At least one option must be selected.")
                    // You could also present an alert here
                }
            }
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
            VStack(alignment: .leading) {
                Toggle(isOn: $includeUppercase) {
                    Text("Include uppercase letters")
                }
                .onChange(of: includeUppercase) { oldValue, newValue in
                                handleToggleChange(for: $includeUppercase, newValue: newValue)
                            }
                Toggle(isOn: $includeLowercase) {
                    Text("Include lowercase letters")
                }
                .onChange(of: includeLowercase) { oldValue, newValue in
                                handleToggleChange(for: $includeLowercase, newValue: newValue)
                            }
                Toggle(isOn: $includeNumbers) {
                    Text("Include numbers")
                }
                .onChange(of: includeNumbers) { oldValue, newValue in
                                handleToggleChange(for: $includeNumbers, newValue: newValue)
                            }
                Toggle(isOn: $includeSpecial) {
                    Text("Include special characters")
                }
                .onChange(of: includeSpecial) { oldValue, newValue in
                                handleToggleChange(for: $includeSpecial, newValue: newValue)
                            }
            }
            .onAppear {
                if !includeUppercase && !includeLowercase && !includeNumbers && !includeSpecial {
                    includeLowercase = true
                }
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
