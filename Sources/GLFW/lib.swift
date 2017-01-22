import CGLFW

extension Int {
    
    static let dontCare = Int(GLFW_DONT_CARE)
}
public enum glfw {
    
    public struct Rect {
        
        public static let zero = Rect(origin: .zero, size: .zero)
        
        public var origin: Point
        public var size: Size
        
        public init(origin: Point, size: Size) {
            self.origin = origin
            self.size = size
        }
        
        public init(x: Int, y: Int, width: Int, height: Int) {
            self.init(origin: Point(x: x, y: y), size: Size(width: width, height: height))
        }
    }
    
    public struct Size {
        
        public static let zero = Size(width: 0, height: 0)
        
        public var width: Int
        public var height: Int
        
        public init(width: Int, height: Int) {
            self.width = width
            self.height = height
        }
    }
    
    public struct Point {
        
        public static let zero = Point(x: 0, y: 0)
        
        public var x: Int
        public var y: Int
        
        public init(x: Int, y: Int) {
            self.x = x
            self.y = y
        }
    }
    
    public static func initialize() {
        glfwInit()
    }
    
    public static func terminate() {
        glfwTerminate()
    }
    
    public static func pollEvents() {
        glfwPollEvents()
    }
    
    
    
    public final class Monitor {
        
//        private var pointer: OpaquePointer
    }
    
//    public func setSwapInterval(_ value: Int) {
//        glfwSwapInterval(value)
//    }
    
    public static func set(swapInterval value: Int) {
        glfwSwapInterval(Int32(value))
    }
    
    public static func set(windowHint hint: Window.Hint) {
        glfwWindowHint(hint.name, hint.value)
    }
    
    public final class Window {
        
        public enum Hint {
            
            internal var name: Int32 {
                switch self {
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
        
        public struct Framebuffer {
            
            private weak var window: Window?
            fileprivate init(window: Window?) {
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
        
        public struct Callbacks {
            
            private static var windows = [OpaquePointer : Window]()
            
            internal static func clear(for window: Window) {
                guard let pointer = window.pointer else { return }
                Callbacks.windows[pointer] = nil
            }
            
            public typealias WindowCallback = (Window) -> Void
            public typealias WindowPositionCallback = (Window, Point) -> Void
            public typealias WindowSizeCallback = (Window, Size) -> Void
            public typealias WindowFocusCallback = (Window, Bool) -> Void
            
            public var closed: WindowCallback? {
                didSet {
                    guard let pointer = self.window?.pointer else { return }
                    if oldValue == nil {
                        self.setClosedCallback()
                    }
                    Callbacks.windows[pointer] = self.window
                }
            }
            public var position: WindowSizeCallback? {
                didSet {
                    
                }
            }
            public var size: WindowSizeCallback? {
                didSet {
                    
                }
            }
            public var focused: WindowFocusCallback? {
                didSet {
                    
                }
            }
            
            private weak var window: Window?
            fileprivate init(window: Window?) {
                self.window = window
            }
            
            private func setClosedCallback() {
                guard let pointer = self.window?.pointer else { return }
                glfwSetWindowCloseCallback(pointer) { pointer in
                    guard let pointer = pointer,
                        let window = Callbacks.windows[pointer] else { return }
                    window.callbacks.closed?(window)
                }
            }
        }
        
        public var size: Size {
            get {
                guard let pointer = self.pointer else { return .zero }
                var width: Int32 = 0
                var height: Int32 = 0
                
                glfwGetWindowSize(pointer, &width, &height)
                return Size(width: Int(width), height: Int(height))
            }
            set {
                guard let pointer = self.pointer else { return }
                glfwSetWindowSize(pointer, Int32(newValue.width), Int32(newValue.height))
            }
        }
        
        public var frame: Rect {
            get {
                guard let pointer = self.pointer else { return .zero }
                var x: Int32 = 0
                var y: Int32 = 0
                var right: Int32 = 0
                var bottom: Int32 = 0
                
                glfwGetWindowFrameSize(pointer, &x, &y, &right, &bottom)
                
                return Rect(x: Int(x), y: Int(y), width: Int(right - x), height: Int(bottom - y))
            }
            set {
                guard let pointer = self.pointer else { return }
                
                let position = newValue.origin
                let size = newValue.size
                
                glfwSetWindowPos(pointer, Int32(position.x), Int32(position.y))
                glfwSetWindowSize(pointer, Int32(size.width), Int32(size.height))
            }
        }
        
        private var pointer: OpaquePointer?
        
        public lazy var framebuffer: Framebuffer = { [weak self] in
            Framebuffer(window: self)
        }()
        
        public lazy var callbacks: Callbacks = { [weak self] in
            Callbacks(window: self)
        }()
        
        public var shouldClose: Bool {
            guard let pointer = self.pointer else { return false }
            return glfwWindowShouldClose(pointer) == 1
        }
        
        fileprivate init?(pointer: OpaquePointer?) {
            guard let pointer = pointer else { return }
            self.pointer = pointer
        }
        
        public init?(width: Int, height: Int, title: String = "", monitor: Monitor? = nil, hints: [Hint] = []) {
            for hint in hints {
                glfw.set(windowHint: hint)
            }
            self.pointer = glfwCreateWindow(Int32(width),
                                            Int32(height),
                                            title,
                                            nil, nil)
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
            Callbacks.clear(for: self)
            glfwDestroyWindow(pointer)
            self.pointer = nil
        }
        
        public func makeCurrent() {
            guard let pointer = self.pointer else { return }
            glfwMakeContextCurrent(pointer)
        }
    }
}
