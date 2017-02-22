//
//  GLFW+Monitor.swift
//  SGLFW-Test
//
//  Created by Sergey Minakov on 21.02.17.
//
//

import CGLFW
//import Foundation

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
    
    //TODO: video mode
    
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
}
