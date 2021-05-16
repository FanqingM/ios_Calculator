
import Foundation
/// 实现一个基本的栈结构


struct Stack<T> {
    
    /// 声明一个泛型数组，用于存储栈中的元素(栈结构的后备存储器)
    private var elements = [T]()
    /// 返回栈结构中元素的个数
    public var count: Int {
        
        // 返回数组elements中的元素个数
        return elements.count
    }
    
    /// 获取或者设置栈的存储容量
    public var capacity: Int {
        
        // 获取栈的存储容量
        get {
            
            // 返回数组elements的容量
            return elements.capacity
        }
        
        // 设置栈的最小容量
        set {
            
            // 设置数组elements的最小容量
            elements.reserveCapacity(newValue)
        }
    }
    
    /// 初始化方法(创建栈实例)
    public init() {}
    
    /// 使用push方法执行入栈操作
    public mutating func push(element: T) {
        
        // 判断栈是否已满
        
        // 使用数组的append()方法将元素添加到数组elements中
        self.elements.append(element)
    }
    
    /// 使用pop方法执行出栈操作
    @discardableResult
    public mutating func pop() -> T? {
        
        // 判断栈是否已空
        
        // 移除数组elements的最后一个元素
        return elements.popLast()
    }
    
    /// 返回栈顶元素
    public func top() -> T? {
        
        // 返回数组elements的最后一个元素(但是不移除该元素)
        return elements.last
    }
    /// 清空栈中所有的元素
    public mutating func clear() {
        
        // 清空数组elements中所有的元素
        elements.removeAll()
    }
    
    /// 判断栈是否为空
    public func isEmpty() -> Bool {
        
        // 判断数组elements是否为空
        return elements.isEmpty
    }
    
    /// 判断栈是否已满
    public func isFull() -> Bool {
        
        // 对数组的存储情况进行判断
        if count == 0 {
            
            // 如果数组为空，则表示栈还未存储数据元素
            return false
        } else {
            
            // 如果数组不为空，则返回数组的存储容量
            // 然后再根据实际存储情况判断栈是否已满
            return count == elements.capacity
        }
    }
}
