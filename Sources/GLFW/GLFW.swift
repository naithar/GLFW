//
//  GLFW.swift
//  SGLFW-Test
//
//  Created by Sergey Minakov on 21.02.17.
//
//

import CGLFW

public enum glfw {
    
    public static func initialize() {
        glfwInit()
    }
    
    public static func terminate() {
        glfwTerminate()
    }
    
    public static func pollEvents() {
        glfwPollEvents()
    }
    
    public static func set(swapInterval value: Int) {
        glfwSwapInterval(Int32(value))
    }
    
}
