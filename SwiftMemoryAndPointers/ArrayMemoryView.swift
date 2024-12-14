//
//  ArrayMemoryView.swift
//  SwiftMemoryAndPointers
//
//  Created by Zakk Hoyt on 2024-12-14.
//

import SwiftUI

struct ArrayMemoryView: View {
    let watcher = ArrayWatcher()
    
    var body: some View {
        VStack {
            HStack {
                Button("appendByte") {
                    watcher.appendByte()
                }
                Button("insertByteIntoRandomIndex") {
                    watcher.insertByteAtRandomIndex()
                }
                Button("removeLastByte") {
                    watcher.removeLastByte()
                }
                Button("removeByteFromRandomIndex") {
                    watcher.removeByteFromRandomIndex()
                }
            }
            TextEditor(text: Binding(get: { watcher.currentMemoryDescription }, set: { _ in }))
        }
        .padding()
    }
}

#Preview {
    ArrayMemoryView()
}


#warning("TODO: zakkhoyt - @Observable, @State both have interesting effects")

#warning("TODO: zakkhoyt - Use this project to show how @state works")
//@Observable
class ArrayWatcher {
    var currentMemoryDescription: String = ""
    var bytes = [UInt8](repeating: 0x00, count: 0)
    
    init() {
        currentMemoryDescription = debugDescription
    }
    
    func appendByte() {
        let byte = nextByte
        bytes.append(byte)
        let index = bytes.count - 1
        
        print("Appended byte: \(byte.hexString) at index: \(index)")
        printMemory()
    }
    
    func insertByteAtRandomIndex() {
        let byte = nextByte
        let index = bytes.isEmpty ? 0 : Int.random(in: 0..<bytes.count)
        bytes.insert(byte, at: index)
        
        print("Inserted byte: \(byte.hexString) into index: \(index)")
        printMemory()
    }
    
    func removeLastByte() {
        guard !bytes.isEmpty else {
            print("There are no bytes to remove")
            return
        }
        
        let index = bytes.count - 1
        let byte = bytes.removeLast()
        
        print("Removed byte: \(byte.hexString) from index: \(index)")
        printMemory()
    }
    
    func removeByteFromRandomIndex() {
        guard !bytes.isEmpty else {
            print("There are no bytes to remove")
            return
        }
        
        let index = Int.random(in: 0..<bytes.count)
        let byte = bytes.remove(at: index)
        
        print("Removed byte: \(byte.hexString) from index: \(index)")
        printMemory()
    }
    
    
    func printMemory() {
//        print(self.debugDescription)
        currentMemoryDescription = debugDescription
        print(currentMemoryDescription)
    }
    
    
    private var lastKnownBaseAddress: String?
    
    private var _nextByte: UInt8 = 0xFF
    private var nextByte: UInt8 {
        get {
            // increment on each read, looping instead of overflowing.
            _nextByte &+= 1
            return _nextByte
        }
    }
}

extension ArrayWatcher: CustomDebugStringConvertible {
    var debugDescription: String {
        defer {
            self.lastKnownBaseAddress = bytes.withUnsafeBufferPointer {
                guard let baseAddress = $0.baseAddress else { return nil }
                return "\(baseAddress)"
            }
        }
        
        let currentBaseAddress: String? = bytes.withUnsafeBufferPointer {
            guard let baseAddress = $0.baseAddress else { return nil }
            return "\(baseAddress)"
        }
        
        
        var headerLines: [String] = [
            "---- ---- ---- ---- ---- ---- ---- ---- "
        ]
        
#warning("TODO: zakkhoyt - tacck prev/current baseAddress, bufferSize, # of inserts")
        if let lastKnownBaseAddress, let currentBaseAddress, currentBaseAddress != lastKnownBaseAddress {
            headerLines.append(
                """
                🔻🔻 baseAddress has changed 🔻🔻 
                    • previous: \(lastKnownBaseAddress)
                    • current : \(currentBaseAddress)
                """
            )
        }
        
#warning("TODO: zakkhoyt - multiline memory bytes, or truncating")
        let bodyLines: [String] = bytes.withUnsafeBufferPointer { (ptr: UnsafeBufferPointer<UInt8>) in
            guard let baseAddress = ptr.baseAddress else { return [] }
            return (0..<bytes.count).reduce(
                into: ["baseAddress: \(baseAddress)"]
            ) { partialResult, i in
                let address = baseAddress.advanced(by: i)
                partialResult.append("\(address) -> [\(i)]: \(address.pointee)")
            }
        }
        let footerLines: [String] = ["bytes.count: \(bytes.count)"]
        return [ headerLines, bodyLines, footerLines ]
            .map { $0.joined(separator: "\n") }
            .joined(separator: "\n")
        
    }
}



extension UInt8 {
    var hexString: String {
        String(format: "0x%02X", self)
    }
}

extension UInt32 {
    var hexString: String {
        String(format: "0x%08X", self)
    }
}
