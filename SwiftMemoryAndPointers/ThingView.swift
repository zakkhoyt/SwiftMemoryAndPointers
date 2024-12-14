//
//  ContentView.swift
//  MemoryWindow
//
//  Created by Zakk Hoyt on 2024-12-14.
//

import SwiftUI

struct ThingView: View {
    struct Thing {
        let a: UInt8 = 0
        let b: Int = 24234
        let name: String = "bill"
        let age: Double = 47.234
    }

    init() {
        let t = Thing()
        let r = UInt8.random(in: 0..<0xFF)
        var a: [UInt8] = [0xFF, 0xab, 0xcd]
        let output: [UInt8] = MyClass.uint32ToBuffer(input: 0xDEADBEEF)
        let c = MyClass()
        print("output: \(output)")
        ()
    }
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ThingView()
}


class MyClass {
#warning("TODO: zakkhoyt - size allcoated?")
    let a_0 = [UInt8]()
    
    let a_1 = [UInt8](repeating: 0x0F, count: 4)
    // initialize the buffer memory yourself
    let a_2 = [UInt8](
        unsafeUninitializedCapacity: 4
    ) { (
        buffer: inout UnsafeMutableBufferPointer<UInt8>,
        initializedCount: inout Int
    ) in
        
    }
    

    static var randomUInt8: UInt8 {
        UInt8.random(in: 0..<0xFF)
    }
    
    static func uint32ToBuffer(input: UInt32) -> [UInt8] {
        let byteCount = 4
        let arrayPointer = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: byteCount)
        (0..<byteCount).forEach { i in
//            let byte: UInt8 =  (input >> (8 * i)) & 0x000000FF
            
            let bitShift = 8*i
            let mask: UInt32 = 0xFF << bitShift
            let paddedByte: UInt32 = input & mask
            let shiftedByte: UInt32 = paddedByte >> bitShift
            let byte = UInt8(clamping: shiftedByte)

            guard let bytePointer = arrayPointer.baseAddress?.advanced(by: i) else { return }
            bytePointer.pointee = byte
            
//            arrayPointer.initializeElement(at: i, to: byte)
        }
        
//        let out: [UInt8] = arrayPointer.
//
//
        print(#"Context Menu: view memory of "arrayPointe""#)
        print(#"(lldb) frame variable"#)
        print(#"(lldb) type format add --format hex int"#)
    
        print("arrayPointer: \(arrayPointer)")
        
        return []
    }
}
