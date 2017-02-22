//
//  GLFW+Cursor.swift
//  SGLFW-Test
//
//  Created by Sergey Minakov on 22.02.17.
//
//

//TODO: cursor http://www.glfw.org/docs/latest/input_guide.html#cursor_standard

import CGLFW

public extension glfw {
    
    public final class Cursor {
        
        internal typealias CursorMap = [OpaquePointer : glfw.Cursor]
        
        internal static var map = CursorMap()
        
        internal var pointer: OpaquePointer?
        
        public enum Shape {
            case arrow
            case ibeam
            case crosshair
            case hand
            case hresize // TODO: .resize(.horizontal)
            case vresize // TODO: .resize(.vertical)
            
            internal var raw: Int32 {
                switch self {
                case .arrow:
                    return GLFW_ARROW_CURSOR
                case .ibeam:
                    return GLFW_IBEAM_CURSOR
                case .crosshair:
                    return GLFW_CROSSHAIR_CURSOR
                case .hand:
                    return GLFW_HAND_CURSOR
                case .hresize:
                    return GLFW_HRESIZE_CURSOR
                case .vresize:
                    return GLFW_VRESIZE_CURSOR
                }
            }
        }
        
        deinit {
            self.destroy()
        }
        
        //TODO: http://www.glfw.org/docs/latest/group__input.html#gafca356935e10135016aa49ffa464c355
        
        public init?(standart shape: Cursor.Shape) {
            guard let pointer = glfwCreateStandardCursor(shape.raw) else { return nil }
            self.pointer = pointer
            glfw.Cursor.map[pointer] = self
        }
        
        public func destroy() {
            guard let pointer = self.pointer else { return }
            glfw.Cursor.map[pointer] = nil
            glfwDestroyCursor(pointer)
            self.pointer = nil
        }
    }
}
