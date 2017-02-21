//
//  GLFW+Window.swift
//  SGLFW-Test
//
//  Created by Sergey Minakov on 21.02.17.
//
//

import Foundation // TODO: import SGLCore
import CGLFW

public typealias Point = CGPoint
public typealias Size = CGSize
public typealias Rect = CGRect



public extension glfw {
    
    public static func set(windowHint hint: Window.Hint) {
        if case .default = hint {
            self.resetWindowHints()
        } else {
            glfwWindowHint(hint.name, hint.value)
        }
    }
    
    public static func set(windowHints hints: [Window.Hint]) {
        for hint in hints {
            self.set(windowHint: hint)
        }
    }
    
    public static func resetWindowHints() {
        glfwDefaultWindowHints()
    }
    
    public final class Window {
        
        internal typealias WindowMap = [OpaquePointer : glfw.Window]
        
        internal static var map = WindowMap()
        
        internal var pointer: OpaquePointer?
        
        // MARK: lazy
        public lazy var framebuffer: Framebuffer = { [weak self] in Framebuffer(window: self) }()
        public lazy var callbacks: Callbacks = { [weak self] in Callbacks(window: self) }()
        
        public var title: String? {
            didSet {
                guard let pointer = self.pointer else { return }
                glfwSetWindowTitle(pointer, self.title ?? "")
            }
        }
        
        // TODO: remove
//        fileprivate init?(pointer: OpaquePointer?) {
//            guard let pointer = pointer else { return nil }
//            self.pointer = pointer
//            Window.map[pointer] = self
//        }
        
        public init?(width: CGFloat,
                     height: CGFloat,
                     title: String = "",
                     monitor: Monitor? = nil,
                     share: Window? = nil,
                     hints: [Window.Hint] = []) {
            glfw.set(windowHints: hints)
            
            self.pointer = glfwCreateWindow(Int32(width),
                                            Int32(height),
                                            title,
                                            monitor?.pointer,
                                            share?.pointer)
            guard let pointer = self.pointer else { return nil }
            self.title = title
            Window.map[pointer] = self
        }
        
        public func swapBuffers() {
            guard let pointer = self.pointer else { return }
            glfwSwapBuffers(pointer)
        }
        
        deinit {
            self.destroy()
        }
        
        public func destroy() {
            guard let pointer = self.pointer else { return }
            self.callbacks.clear()
            Window.map[pointer] = nil
            glfwDestroyWindow(pointer)
            self.pointer = nil
        }
        
        public func makeCurrent() {
            guard let pointer = self.pointer else { return }
            glfwMakeContextCurrent(pointer)
        }
        
        public func value(for attribute: Window.Attribute) -> Int {
            guard let pointer = self.pointer else { return 0 }
            let value = glfwGetWindowAttrib(pointer, attribute.name)
            return Int(value)
        }
    }
}

public extension glfw.Window {
    
    public class Callbacks {
        
        public typealias WindowCallback = (glfw.Window) -> Void
        public typealias WindowPositionCallback = (glfw.Window, Point) -> Void
        public typealias WindowSizeCallback = (glfw.Window, Size) -> Void
        public typealias WindowBoolCallback = (glfw.Window, Bool) -> Void
        
        private weak var window: glfw.Window?

        // TODO: decide the need for this method.
//        private func setCallback<GLFWCallback, WindowCallback>(
//            oldValue: WindowCallback?,
//            newValue: WindowCallback?,
//            function: (OpaquePointer?, GLFWCallback?) -> GLFWCallback?,
//            action: GLFWCallback?) {
//            guard let pointer = self.window?.pointer else { return }
//            if oldValue == nil {
//                _ = function(pointer, action)
//            } else if newValue == nil && oldValue != nil {
//                _ = function(pointer, nil)
//            }
//        }
        
        deinit {
            self.clear()
        }
        
        fileprivate func clear() {
            self.closed = nil
            self.size = nil
            self.position = nil
            self.refresh = nil
            self.focus = nil
            self.framebuffer = nil
        }
        
        fileprivate init(window: glfw.Window?) {
            self.window = window
        }
        
        // MARK: Closed callback
        
        public var closed: WindowCallback? {
            didSet {
                guard let pointer = self.window?.pointer else { return }
                if oldValue == nil {
                    glfwSetWindowCloseCallback(pointer) { pointer in
                        guard let pointer = pointer,
                            let window = glfw.Window.map[pointer],
                            let callback = window.callbacks.closed else {
                                return
                        }
                        
                        callback(window)
                    }
                } else if self.closed == nil && oldValue != nil {
                    glfwSetWindowCloseCallback(pointer, nil)
                }
            }
        }
        
        @discardableResult
        public func closed(_ callback: WindowCallback?) -> Callbacks {
            self.closed = callback
            return self
        }
        
        // MARK: Size callback
        
        public var size: WindowSizeCallback? {
            didSet {
                guard let pointer = self.window?.pointer else { return }
                if oldValue == nil {
                    glfwSetWindowSizeCallback(pointer) { pointer, width, height in
                        guard let pointer = pointer,
                            let window = glfw.Window.map[pointer],
                            let callback = window.callbacks.size else {
                                return
                        }
                        
                        let size = Size(width: Int(width), height: Int(height))
                        callback(window, size)
                    }
                } else if self.size == nil && oldValue != nil {
                    glfwSetWindowSizeCallback(pointer, nil)
                }
            }
        }
        
        @discardableResult
        public func size(_ callback: WindowSizeCallback?) -> Callbacks {
            self.size = callback
            return self
        }
        
        // MARK: Position callback
        
        public var position: WindowPositionCallback? {
            didSet {
                guard let pointer = self.window?.pointer else { return }
                if oldValue == nil {
                    glfwSetWindowPosCallback(pointer) { pointer, x, y in
                    guard let pointer = pointer,
                            let window = glfw.Window.map[pointer],
                            let callback = window.callbacks.position else {
                                return
                        }
                        
                        let position = Point(x: Int(x), y: Int(y))
                        callback(window, position)
                    }
                } else if self.position == nil && oldValue != nil {
                    glfwSetWindowPosCallback(pointer, nil)
                }
            }
        }
        
        @discardableResult
        public func position(_ callback: WindowPositionCallback?) -> Callbacks {
            self.position = callback
            return self
        }
        
        // MARK: Refresh callback
        
        public var refresh: WindowCallback? {
            didSet {
                guard let pointer = self.window?.pointer else { return }
                if oldValue == nil {
                    glfwSetWindowRefreshCallback(pointer) { pointer in
                        guard let pointer = pointer,
                            let window = glfw.Window.map[pointer],
                            let callback = window.callbacks.refresh else {
                                return
                        }
                        callback(window)
                    }
                } else if self.refresh == nil && oldValue != nil {
                    glfwSetWindowRefreshCallback(pointer, nil)
                }
            }
        }
        
        @discardableResult
        public func refresh(_ callback: WindowCallback?) -> Callbacks {
            self.refresh = callback
            return self
        }
        
        // MARK: Focus callback.
        
        public var focus: WindowBoolCallback? {
            didSet {
                guard let pointer = self.window?.pointer else { return }
                if oldValue == nil {
                    glfwSetWindowFocusCallback(pointer) { pointer, value in
                        guard let pointer = pointer,
                            let window = glfw.Window.map[pointer],
                            let callback = window.callbacks.focus else {
                                return
                        }
                        
                        let value = value != 0
                        callback(window, value)
                    }
                } else if self.focus == nil && oldValue != nil {
                    glfwSetWindowFocusCallback(pointer, nil)
                }
            }
        }
    
        @discardableResult
        public func focus(_ callback: WindowBoolCallback?) -> Callbacks {
            self.focus = callback
            return self
        }
        
        
        // MARK: Framebuffer callback
        
        public var framebuffer: WindowSizeCallback? {
            didSet {
                guard let pointer = self.window?.pointer else { return }
                if oldValue == nil {
                    glfwSetFramebufferSizeCallback(pointer) { pointer, width, height in
                        guard let pointer = pointer,
                            let window = glfw.Window.map[pointer],
                            let callback = window.callbacks.framebuffer else {
                                return
                        }
                        
                        let framebufferSize = Size(width: Int(width), height: Int(height))
                        callback(window, framebufferSize)
                    }
                } else if self.framebuffer == nil && oldValue != nil {
                    glfwSetFramebufferSizeCallback(pointer, nil)
                }
            }
        }
        
        @discardableResult
        public func framebuffer(_ callback: WindowSizeCallback?) -> Callbacks {
            self.framebuffer = callback
            return self
        }
        
        // MARK: Minimize callback
        
        public var minimize: WindowBoolCallback? {
            didSet {
                guard let pointer = self.window?.pointer else { return }
                if oldValue == nil {
                    glfwSetWindowIconifyCallback(pointer) { pointer, value in
                        guard let pointer = pointer,
                            let window = glfw.Window.map[pointer],
                            let callback = window.callbacks.minimize else {
                                return
                        }
                        
                        let value = value != 0
                        callback(window, value)
                    }
                } else if self.minimize == nil && oldValue != nil {
                    glfwSetWindowIconifyCallback(pointer, nil)
                }
            }
        }
        
        @discardableResult
        public func minimize(_ callback: WindowBoolCallback?) -> Callbacks {
            self.minimize = callback
            return self
        }
        
        //TODO: common code
    }
}

// MARK: runtime values
public extension glfw.Window {
    
    public var frame: Rect {
        get {
            guard let pointer = self.pointer else { return .zero }
            var x: Int32 = 0
            var y: Int32 = 0
            var width: Int32 = 0
            var height: Int32 = 0
            
            glfwGetWindowPos(pointer, &x, &y)
            glfwGetWindowSize(pointer, &width, &height)
            
            return Rect(x: Int(x), y: Int(y), width: Int(width), height: Int(height))
        }
        set {
            guard let pointer = self.pointer else { return }
            
            let position = newValue.origin
            let size = newValue.size
            
            glfwSetWindowPos(pointer, Int32(position.x), Int32(position.y))
            glfwSetWindowSize(pointer, Int32(size.width), Int32(size.height))
        }
    }
    
    public var shouldClose: Bool {
        guard let pointer = self.pointer else { return false }
        return glfwWindowShouldClose(pointer) == 1
    }
    
    public var isVisible: Bool {
        get {
            return self.value(for: .visible) != 0
        }
        set {
            guard let pointer = self.pointer else { return }
            if newValue {
                glfwShowWindow(pointer)
            } else {
                glfwHideWindow(pointer)
            }
        }
    }
    
    public var isFocused: Bool {
        get {
            return self.value(for: .focused) != 0
        }
    }
    
    public func focus() {
        guard let pointer = self.pointer else { return }
        glfwFocusWindow(pointer)
    }
    
    //TODO: isFocused
    
    // TODO: http://www.glfw.org/docs/latest/window_guide.html#window_iconify
    
    
    public func limit(min: Size, max: Size) { //TODO: move to var
        guard let pointer = self.pointer else { return }
        glfwSetWindowSizeLimits(pointer, Int32(min.width), Int32(min.height), Int32(max.width), Int32(max.height))
    }
    
    public func aspectRatio(width: CGFloat, height: CGFloat) { //TODO: move to var
        guard let pointer = self.pointer else { return }
        glfwSetWindowAspectRatio(pointer, Int32(width), Int32(height))
    }
}

public extension glfw.Window {
    
    public struct Framebuffer {
        
        private weak var window: glfw.Window?
        fileprivate init(window: glfw.Window?) {
            self.window = window
        }
        
        public var size: Size {
            guard let pointer = self.window?.pointer else { return .zero }
            var width: Int32 = 0
            var height: Int32 = 0
            glfwGetFramebufferSize(pointer, &width, &height)
            return Size(width: Int(width), height: Int(height))
        }
    }
}


// TODO: http://www.glfw.org/docs/latest/window_guide.html#window_attribs
public extension glfw.Window {
    
    public enum Attribute {
        case visible
        case focused
        
        internal var name: Int32 {
            switch self {
            case .focused:
                return GLFW_FOCUSED
            case .visible:
                return GLFW_VISIBLE
            }
        }
    }
}

public extension glfw.Window {
    
    public enum Hint {
        
        case `default`
        
        internal var name: Int32 {
            switch self {
            case .default:
                return -1
            case .resizable:
                return GLFW_RESIZABLE
            case .visible:
                return GLFW_VISIBLE
            case .decorated:
                return GLFW_DECORATED
            case .focused:
                return GLFW_FOCUSED
            case .iconify:
                return GLFW_AUTO_ICONIFY
            case .floating:
                return GLFW_FLOATING
            case .redBits:
                return GLFW_RED_BITS
            case .greenBits:
                return GLFW_GREEN_BITS
            case .blueBits:
                return GLFW_BLUE_BITS
            case .alphaBits:
                return GLFW_ALPHA_BITS
            case .depthBits:
                return GLFW_DEPTH_BITS
            case .stencilBits:
                return GLFW_STENCIL_BITS
            case .accumRedBits:
                return GLFW_ACCUM_RED_BITS
            case .accumGreenBits:
                return GLFW_ACCUM_GREEN_BITS
            case .accumBlueBits:
                return GLFW_ACCUM_BLUE_BITS
            case .accumAlphaBits:
                return GLFW_ACCUM_ALPHA_BITS
            case .auxBuffers:
                return GLFW_AUX_BUFFERS
            case .samples:
                return GLFW_SAMPLES
            case .refreshRate:
                return GLFW_REFRESH_RATE
            case .stereo:
                return GLFW_STEREO
            case .sRGBCapable:
                return GLFW_SRGB_CAPABLE
            case .doubleBuffer:
                return GLFW_DOUBLEBUFFER
            case .clientAPI:
                return GLFW_CLIENT_API
            case .contextVersionMajor:
                return GLFW_CONTEXT_VERSION_MAJOR
            case .contextVersionMinor:
                return GLFW_CONTEXT_VERSION_MINOR
            case .contextRobustness:
                return GLFW_CONTEXT_ROBUSTNESS
            case .contextReleaseBehavior:
                return GLFW_CONTEXT_RELEASE_BEHAVIOR
            case .openGLForwardCompat:
                return GLFW_OPENGL_FORWARD_COMPAT
            case .openGLDebugContext:
                return GLFW_OPENGL_DEBUG_CONTEXT
            case .openGLProfile:
                return GLFW_OPENGL_PROFILE
            }
        }
        
        internal var value: Int32 {
            switch self {
            case .default:
                return -1
            case .resizable(let value),
                 .visible(let value),
                 .decorated(let value),
                 .focused(let value),
                 .iconify(let value),
                 .floating(let value),
                 .stereo(let value),
                 .sRGBCapable(let value),
                 .doubleBuffer(let value),
                 .openGLForwardCompat(let value),
                 .openGLDebugContext(let value):
                return value ? GLFW_TRUE : GLFW_FALSE
            case .redBits(let value),
                 .greenBits(let value),
                 .blueBits(let value),
                 .alphaBits(let value),
                 .depthBits(let value),
                 .stencilBits(let value),
                 .accumRedBits(let value),
                 .accumGreenBits(let value),
                 .accumBlueBits(let value),
                 .accumAlphaBits(let value),
                 .auxBuffers(let value),
                 .samples(let value),
                 .refreshRate(let value),
                 .contextVersionMajor(let value),
                 .contextVersionMinor(let value):
                return Int32(value)
            case .clientAPI(let value):
                return value.raw
            case .contextRobustness(let value):
                return value.raw
            case .contextReleaseBehavior(let value):
                return value.raw
            case .openGLProfile(let value):
                return value.raw
            }
        }
        
        case resizable(Bool)
        case visible(Bool)
        case decorated(Bool)
        case focused(Bool)
        case iconify(Bool)
        case floating(Bool)
        case redBits(Int)
        case greenBits(Int)
        case blueBits(Int)
        case alphaBits(Int)
        case depthBits(Int)
        case stencilBits(Int)
        case accumRedBits(Int)
        case accumGreenBits(Int)
        case accumBlueBits(Int)
        case accumAlphaBits(Int)
        case auxBuffers(Int)
        case samples(Int)
        case refreshRate(Int)
        case stereo(Bool)
        case sRGBCapable(Bool)
        case doubleBuffer(Bool)
        
        public enum ClientAPI {
            case openGL
            case openGLES
            
            internal var raw: Int32 {
                switch self {
                case .openGL:
                    return GLFW_OPENGL_API
                case .openGLES:
                    return GLFW_OPENGL_ES_API
                }
            }
        }
        
        case clientAPI(ClientAPI)
        case contextVersionMajor(Int)
        case contextVersionMinor(Int)
        
        public enum ContextRobustness {
            case none
            case noResetNotification
            case loseContextOnReset
            
            internal var raw: Int32 {
                switch self {
                case .none:
                    return GLFW_NO_ROBUSTNESS
                case .noResetNotification:
                    return GLFW_NO_RESET_NOTIFICATION
                case .loseContextOnReset:
                    return GLFW_LOSE_CONTEXT_ON_RESET
                }
            }
        }
        
        case contextRobustness(ContextRobustness)
        
        public enum ContextReleaseBehavior {
            case any
            case flush
            case none
            
            internal var raw: Int32 {
                switch self {
                case .any:
                    return GLFW_ANY_RELEASE_BEHAVIOR
                case .flush:
                    return GLFW_RELEASE_BEHAVIOR_FLUSH
                case .none:
                    return GLFW_RELEASE_BEHAVIOR_NONE
                }
            }
        }
        
        case contextReleaseBehavior(ContextReleaseBehavior)
        case openGLForwardCompat(Bool)
        case openGLDebugContext(Bool)
        
        public enum OpenGLProfile {
            case any
            case compat
            case core
            
            internal var raw: Int32 {
                switch self {
                case .any:
                    return GLFW_OPENGL_ANY_PROFILE
                case .compat:
                    return GLFW_OPENGL_COMPAT_PROFILE
                case .core:
                    return GLFW_OPENGL_CORE_PROFILE
                }
            }
        }
        
        case openGLProfile(OpenGLProfile)
    }
}
