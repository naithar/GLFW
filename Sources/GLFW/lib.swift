import CGLFW

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
    
    public func set(swapInterval value: Int) {
        glfwSwapInterval(Int32(value))
    }
    
    public final class Window {
        
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
        
        public var size: Size {
            guard let pointer = self.pointer else { return .zero }
            var width: Int32 = 0
            var height: Int32 = 0
            
            glfwGetWindowSize(pointer, &width, &height)
            return Size(width: Int(width), height: Int(height))
        }
        
        public var frame: Rect {
            guard let pointer = self.pointer else { return .zero }
            var x: Int32 = 0
            var y: Int32 = 0
            var right: Int32 = 0
            var bottom: Int32 = 0
            
            glfwGetWindowFrameSize(pointer, &x, &y, &right, &bottom)
            
            return Rect(x: Int(x), y: Int(y), width: Int(right - x), height: Int(bottom - y))
        }
        
        private var pointer: OpaquePointer?
        
        public lazy var framebuffer: Framebuffer = { [weak self] in
            Framebuffer(window: self)
        }()
        
        public var shouldClose: Bool {
            guard let pointer = self.pointer else { return false }
            return glfwWindowShouldClose(pointer) == 1
        }
        
        public init?(width: Int, height: Int, title: String = "", monitor: Monitor? = nil) {
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
            glfwDestroyWindow(pointer)
            self.pointer = nil
        }
        
        public func makeCurrent() {
            guard let pointer = self.pointer else { return }
            glfwMakeContextCurrent(pointer)
        }
    }
}
