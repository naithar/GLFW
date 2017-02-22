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
    
    public final class Monitor {
        
        public static let primary = glfw.Monitor.init(pointer: glfwGetPrimaryMonitor())
        
        internal typealias MonitorMap = [OpaquePointer : glfw.Monitor]
        
        internal static var map = MonitorMap()
        
        internal var pointer: OpaquePointer?
        
        deinit {
            self.destroy()
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
        
        
        private func destroy() { // TODO: decide the need for destroy method as monitors does not get destroyed
            guard let pointer = self.pointer else { return }
            glfw.Monitor.map[pointer] = nil
            self.pointer = nil
        }
        
    }
}
