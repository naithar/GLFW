//
//  GLFW+Monitor.swift
//  SGLFW-Test
//
//  Created by Sergey Minakov on 21.02.17.
//
//

import CGLFW
import Foundation

public extension glfw {
    
    //TODO:
    //monitor->callbacks
    
    // TODO: struct?
    public final class Monitor {
        
        public static let primary = glfw.Monitor.init(pointer: glfwGetPrimaryMonitor())! //Should never fail
        
        public static var all: [glfw.Monitor] {
            var count: Int32 = 0
            guard let pointer = glfwGetMonitors(&count) else {
                return []
            }
            
            var monitors = [Monitor]()
            for index in 0..<Int(count) {
                guard let monitorPointer = pointer.advanced(by: index).pointee,
                    let monitor = Monitor.init(pointer: monitorPointer) else { continue }
                
                monitors.append(monitor)
            }
            
            return monitors
        }
        
        internal typealias MonitorMap = [OpaquePointer : glfw.Monitor]
        
        internal static var map = MonitorMap()
        
        internal var pointer: OpaquePointer?
        
        deinit {
//            self.destroy()
        }
        
        private init?(pointer: OpaquePointer?) {
            guard let pointer = pointer else { return nil }
            glfw.Monitor.map[pointer] = self
            self.pointer = pointer
        }
        
        public convenience init?(for window: glfw.Window) {
            guard let windowPointer = window.pointer,
                let monitorPointer = glfwGetWindowMonitor(windowPointer) else { return nil }
            
            self.init(pointer: monitorPointer)
        }
        
        
        // TODO: decide the need for destroy method as monitors does not get destroyed
//        private func destroy() {
//            guard let pointer = self.pointer else { return }
//            glfw.Monitor.map[pointer] = nil
//            self.pointer = nil
//        }
//        
    }
}

public extension glfw.Monitor {
    
    public struct VideoMode {
        
        public struct Bits {
        
            public static let zero = Bits.init(red: 0, green: 0, blue: 0)
            
            public var red: Int
            public var green: Int
            public var blue: Int
            
            fileprivate init(red: Int, green: Int, blue: Int) {
                self.red = red
                self.green = green
                self.blue = blue
            }
        }
        
        static let none = VideoMode()
        
        private var mode: GLFWvidmode?
        
        private init() {
            
        }
        
        fileprivate init?(mode: GLFWvidmode?) {
            guard let mode = mode else { return nil }
            self.mode = mode
        }
        
        public var size: Size {
            guard let mode = self.mode else { return .dontCare }
            return Size(width: Int(mode.width), height: Int(mode.height))
        }
        
        public var refreshRate: Int {
            guard let mode = self.mode else { return .dontCare }
            return Int(mode.refreshRate)
        }
        
        public var bits: Bits {
            guard let mode = self.mode else { return .zero }
            return Bits(red: Int(mode.redBits), green: Int(mode.greenBits), blue: Int(mode.blueBits))
        }
        
    }
    
    
    public struct GammaRamp {
        
        static let none = GammaRamp()
        
        private var ramp: GLFWgammaramp?
        
        private init() {
            
        }
        
        fileprivate init?(ramp: GLFWgammaramp?) {
            guard let ramp = ramp else { return nil }
            self.ramp = ramp
        }
        
        public var size: Int {
            guard let ramp = self.ramp else { return 0 }
            return Int(ramp.size)
        }
        
        public var red: [Int] {
            guard let ramp = self.ramp, let red = ramp.red else { return [] }
            let buffer = UnsafeBufferPointer(start: red, count: self.size)
            return [UInt16](buffer).map { Int($0) }
        }
        
        public var green: [Int] {
            guard let ramp = self.ramp, let green = ramp.green else { return [] }
            let buffer = UnsafeBufferPointer(start: green, count: self.size)
            return [UInt16](buffer).map { Int($0) }
        }
        
        public var blue: [Int] {
            guard let ramp = self.ramp, let blue = ramp.blue else { return [] }
            let buffer = UnsafeBufferPointer(start: blue, count: self.size)
            return [UInt16](buffer).map { Int($0) }
        }
    }
    
    public var name: String? {
        guard let pointer = self.pointer,
            let name = glfwGetMonitorName(pointer) else { return nil }
        
        return String.init(cString: name)
    }
    
    public var position: Point {
        guard let pointer = self.pointer else { return .zero }
        
        var x: Int32 = 0
        var y: Int32 = 0
        glfwGetMonitorPos(pointer, &x, &y)
        
        return Point(x: Int(x), y: Int(y))
    }
    
    public var physicalSize: Size {
        guard let pointer = self.pointer else { return .zero }

        var width: Int32 = 0
        var height: Int32 = 0
        glfwGetMonitorPhysicalSize(pointer, &width, &height)
        
        return Size(width: Int(width), height: Int(height))
    }
    
    public var currentVideoMode: VideoMode {
        guard let pointer = self.pointer else { return .none }
        let videoMode = glfwGetVideoMode(pointer)
        return VideoMode(mode: videoMode?.pointee) ?? .none
    }
    
    public var videoModes: [VideoMode] {
        guard let pointer = self.pointer else { return [] }
        
        var count: Int32 = 0
        let videoModes = glfwGetVideoModes(pointer, &count)
        
        var modes = [VideoMode]()
        
        for index in 0..<Int(count) {
            guard let pointer = videoModes?.advanced(by: index).pointee,
                let mode = VideoMode(mode: pointer) else { continue }
            
            modes.append(mode)
        }
        
        return modes
    }
    
    //TODO: set http://www.glfw.org/docs/latest/group__monitor.html#ga583f0ffd0d29613d8cd172b996bbf0dd
    public var gammaRamp: GammaRamp {
        guard let pointer = self.pointer else { return .none }
        let ramp = glfwGetGammaRamp(pointer)
        return GammaRamp(ramp: ramp?.pointee) ?? .none
    }
}
