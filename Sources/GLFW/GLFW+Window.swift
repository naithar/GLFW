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

//TODO: input http://www.glfw.org/docs/latest/input_guide.html#input_key

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
        
        
        public struct KeyboardInput {
            
            //http://www.glfw.org/docs/latest/group__keys.html#ga9845be48a745fc232045c9ec174d8820
            public enum Key {
                case unknown(Int32)
                case space
                case apostrophe
                case comma
                case minus
                case slash
                case semicolon
                case equal
                case leftBracket //TODO: .bracket(.left)
                case rightBracket //TODO: .bracket(.right)
                case backslash
                case graveAccent
                case worldOne
                case worldTwo
                case escape
                case enter
                case tab
                case backspace
                case insert
                case delete
                case right
                case left
                case down
                case up
                case pageUp
                case pageDown
                case home
                case end
                case capsLock
                case scrollLock
                case numLock
                case printScreen
                case pause
                case leftShift
                case leftControl
                case leftAlt
                case leftSuper
                case rightShift
                case rightControl
                case rightAlt
                case rightSuper
                case menu
                
                // TODO: f keys
                // TODO: kp keys
                
                public enum Number: Int {
                    case zero = 0
                    case one = 1
                    case two = 2
                    case three = 3
                    case four = 4
                    case five = 5
                    case six = 6
                    case seven = 7
                    case eight = 8
                    case nine = 9//...nine
                }
                
                public enum Character {
                    case a // ...z
                }
                
                case number(Number)
                case character(Character)
                
                fileprivate init(value: Int32) {
                    switch value {
                    case GLFW_KEY_SPACE:
                        self = .space
                    case GLFW_KEY_APOSTROPHE:
                        self = .apostrophe
                    case GLFW_KEY_COMMA:
                        self = .comma
                    case GLFW_KEY_MINUS:
                        self = .minus
                    case GLFW_KEY_SLASH:
                        self = .slash
                    case GLFW_KEY_SEMICOLON:
                        self = .semicolon
                    case GLFW_KEY_EQUAL:
                        self = .equal
                    case GLFW_KEY_LEFT_BRACKET:
                        self = .leftBracket
                    case GLFW_KEY_RIGHT_BRACKET:
                        self = .rightBracket
                    case GLFW_KEY_BACKSLASH:
                        self = .backslash
                    case GLFW_KEY_GRAVE_ACCENT:
                        self = .graveAccent
                    case GLFW_KEY_WORLD_1:
                        self = .worldOne
                    case GLFW_KEY_WORLD_2:
                        self = .worldTwo
                    case GLFW_KEY_ESCAPE:
                        self = .escape
                    case GLFW_KEY_ENTER:
                        self = .enter
                    case GLFW_KEY_TAB:
                        self = .tab
                    case GLFW_KEY_BACKSPACE:
                        self = .backspace
                    case GLFW_KEY_INSERT:
                        self = .insert
                    case GLFW_KEY_DELETE:
                        self = .delete
                    case GLFW_KEY_RIGHT:
                        self = .right
                    case GLFW_KEY_LEFT:
                        self = .left
                    case GLFW_KEY_DOWN:
                        self = .down
                    case GLFW_KEY_UP:
                        self = .up
                    case GLFW_KEY_PAGE_UP:
                        self = .pageUp
                    case GLFW_KEY_PAGE_DOWN:
                        self = .pageDown
                    case GLFW_KEY_HOME:
                        self = .home
                    case GLFW_KEY_END:
                        self = .end
                    case GLFW_KEY_CAPS_LOCK:
                        self = .capsLock
                    case GLFW_KEY_SCROLL_LOCK:
                        self = .scrollLock
                    case GLFW_KEY_NUM_LOCK:
                        self = .numLock
                    case GLFW_KEY_PRINT_SCREEN:
                        self = .printScreen
                    case GLFW_KEY_PAUSE:
                        self = .pause
                    case GLFW_KEY_LEFT_SHIFT:
                        self = .leftShift
                    case GLFW_KEY_LEFT_CONTROL:
                        self = .leftControl
                    case GLFW_KEY_LEFT_ALT:
                        self = .leftAlt
                    case GLFW_KEY_LEFT_SUPER:
                        self = .leftSuper
                    case GLFW_KEY_RIGHT_SHIFT:
                        self = .rightShift
                    case GLFW_KEY_RIGHT_CONTROL:
                        self = .rightControl
                    case GLFW_KEY_RIGHT_ALT:
                        self = .rightAlt
                    case GLFW_KEY_RIGHT_SUPER:
                        self = .rightSuper
                    case GLFW_KEY_MENU, GLFW_KEY_LAST:
                        self = .menu
                    case GLFW_KEY_0...GLFW_KEY_9:
                        let numberValue = Int(value - 48)
                        guard let number = Number(rawValue: numberValue) else {
                            self = .unknown(value)
                            return
                        }
                        self = .number(number)
                    case GLFW_KEY_A...GLFW_KEY_Z:
                        fallthrough
                    default:
                        self = .unknown(value)
                    }
                    
                }
            }
            
            public struct Modifier: OptionSet {
                
                public private(set) var rawValue: Int32
                
                public init(rawValue: Int32) {
                    self.rawValue = rawValue
                }
                
                static public let shift = Modifier(rawValue: 1)
                static public let control = Modifier(rawValue: 2)
                static public let alt = Modifier(rawValue: 4)
                static public let `super` = Modifier(rawValue: 8)
                
                //TODO: http://www.glfw.org/docs/latest/group__mods.html
            }
            
            //TODO: http://www.glfw.org/docs/latest/group__input.html#ga2485743d0b59df3791c45951c4195265
            public enum Action {
                case unknown
                case press
                case release
                case `repeat`
                
                fileprivate init(value: Int32) {
                    switch value {
                    case GLFW_PRESS:
                        self = .press
                    case GLFW_RELEASE:
                        self = .release
                    case GLFW_REPEAT:
                        self = .repeat
                    default:
                        self = .unknown
                    }
                }
            }
            //TODO: keys http://www.glfw.org/docs/latest/group__keys.html#gabf48fcc3afbe69349df432b470c96ef2
            public var key: Key
            public var scancode: Int
            public var action: Action
            public var modifiers: Modifier
            
            fileprivate init(key: Int32, scancode: Int32, action: Int32, modifiers: Int32) {
                self.key = Key(value: key)
                self.scancode = Int(scancode)
                self.action = Action(value: action)
                self.modifiers = Modifier(rawValue: modifiers)
            }
        }
        
        // TODO: cursor callbacks
        
        // TODO: deside over
        //window->callbacks
        //window->framebuffer->callbacks
        //window->cursor->callbacks
        //window->input->callbacks
        //vs
        //window->callbacks (window, framebuffer, cursor, input)
        
        public typealias WindowCallback = (glfw.Window) -> Void
        public typealias WindowPositionCallback = (glfw.Window, Point) -> Void
        public typealias WindowSizeCallback = (glfw.Window, Size) -> Void
        public typealias WindowBoolCallback = (glfw.Window, Bool) -> Void
        public typealias WindowKeyboardCallback = (glfw.Window, KeyboardInput) -> Void
        
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
        
        // MARK: Cursor position callback
        
        public var cursorPosition: WindowPositionCallback? {
            didSet {
                guard let pointer = self.window?.pointer else { return }
                if oldValue == nil {
                    glfwSetCursorPosCallback(pointer) { pointer, x, y in
                        guard let pointer = pointer,
                            let window = glfw.Window.map[pointer],
                            let callback = window.callbacks.cursorPosition else {
                                return
                        }
                        
                        let position = Point(x: x, y: y)
                        callback(window, position)
                    }
                } else if self.cursorPosition == nil && oldValue != nil {
                    glfwSetCursorPosCallback(pointer, nil)
                }
            }
        }
        
        @discardableResult
        public func cursorPosition(_ callback: WindowPositionCallback?) -> Callbacks {
            self.cursorPosition = callback
            return self
        }
        
        // MARK: Cursor position callback
        
        public var cursorEnter: WindowBoolCallback? {
            didSet {
                guard let pointer = self.window?.pointer else { return }
                if oldValue == nil {
                    glfwSetCursorEnterCallback(pointer) { pointer, value in
                        guard let pointer = pointer,
                            let window = glfw.Window.map[pointer],
                            let callback = window.callbacks.cursorEnter else {
                                return
                        }
                        
                        let value = value != 0
                        callback(window, value)
                    }
                } else if self.cursorPosition == nil && oldValue != nil {
                    glfwSetCursorEnterCallback(pointer, nil)
                }
            }
        }
        
        @discardableResult
        public func cursorEnter(_ callback: WindowBoolCallback?) -> Callbacks {
            self.cursorEnter = callback
            return self
        }
        
        // MARK: Keyboard input callback
        
        public var keyboard: WindowKeyboardCallback? {
            didSet {
                guard let pointer = self.window?.pointer else { return }
                if oldValue == nil {
                    
                    glfwSetKeyCallback(pointer) { pointer, key, scancode, action, modifiers in
                        guard let pointer = pointer,
                            let window = glfw.Window.map[pointer],
                            let callback = window.callbacks.keyboard else {
                                return
                        }
                        
                        let keyboardInput = KeyboardInput(key: key, scancode: scancode, action: action, modifiers: modifiers)
                        callback(window, keyboardInput)
                    }
                } else if self.keyboard == nil && oldValue != nil {
                    glfwSetKeyCallback(pointer, nil)
                }
            }
        }
        
        @discardableResult
        public func keyboard(_ callback: WindowKeyboardCallback?) -> Callbacks {
            self.keyboard = callback
            return self
        }
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
    
    public var isMinimized: Bool {
        get {
            return self.value(for: .iconified) != 0
        }
        set {
            guard let pointer = self.pointer else { return }
            if newValue {
                glfwIconifyWindow(pointer)
            } else if self.isMinimized {
                glfwRestoreWindow(pointer)
            }
        }
    }
    
    public var isMaximized: Bool {
        get {
            return self.value(for: .maximized) != 0
        }
        set {
            guard let pointer = self.pointer else { return }
            if newValue {
                glfwMaximizeWindow(pointer)
            } else if self.isMaximized {
                glfwRestoreWindow(pointer)
            }
        }
    }
    
    public var monitor: glfw.Monitor? {
//        get {
            return glfw.Monitor(for: self)
//        }
        // TODO: monitor setting
//        set {
//            guard let pointer = self.pointer else { return }
//            let monitor = glfwGetPrimaryMonitor()
//            let frame = glfwGetVideoMode(monitor)
//            
//            glfwSetWindowMonitor(pointer, monitor, 0, 0, Int32(frame!.pointee.width), Int32(frame!.pointee.height), Int32(.dontCare))
//        }
    }
    
//    public var cursor: glfw.Cursor? {
//        return nil
//    }
    
    public func set(monitor: glfw.Monitor?, x: CGFloat? = nil, y: CGFloat? = nil, width: CGFloat? = nil, height: CGFloat? = nil, refreshRate: Int? = nil) {
        guard let pointer = self.pointer else { return }
        guard let monitor = monitor else { return }
        let videoMode = monitor.currentVideoMode
        
        let x = x ?? 0
        let y = y ?? 0
        let width = width ?? videoMode.size.width
        let height = height ?? videoMode.size.height
        let refreshRate = refreshRate ?? .dontCare
        
        glfwSetWindowMonitor(pointer, monitor.pointer, Int32(x), Int32(y), Int32(width), Int32(height), Int32(refreshRate))
    }
    
    public func set(cursor: glfw.Cursor?) {
        guard let windowPointer = self.pointer else { return }
        
        glfwSetCursor(windowPointer, cursor?.pointer)
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
        case iconified
        case maximized
        
        internal var name: Int32 {
            switch self {
            case .focused:
                return GLFW_FOCUSED
            case .visible:
                return GLFW_VISIBLE
            case .iconified:
                return GLFW_ICONIFIED
            case .maximized:
                return GLFW_MAXIMIZED
            }
        }
    }
}

public extension glfw.Window {
    
    public enum Hint {
        
        case `default` // Used to reset all hints
        
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
