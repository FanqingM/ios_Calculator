//
//  ContentView.swift
//  Calculator
//
//  Created by FanqingM on 2021/5/16.
//

import SwiftUI

enum CalcButton: String {
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zero = "0"
    case add = "+"
    case subtract = "-"
    case divide = "÷"
    case multiply = "x"
    case equal = "="
    case clear = "AC"
    case percent = "%"
    case negative = "-/+"

    var buttonColor: Color {
        switch self {
        case .add, .subtract, .multiply, .divide, .equal:
            return .orange
        case .clear, .negative, .percent:
            return Color(.lightGray)
        default:
            return Color(UIColor(red: 55/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1))
        }
    }
}

enum Operation {
    case add, subtract, multiply, divide, equal, none
}

struct ContentView: View {
    @State var userValue = "0"
    @State var value = ""
    @State var runningNumber = 0
    @State var currentOperation: Operation = .none
    @State var numbers = Stack<Int>()
    @State var options = Stack<Operation>()
    @State var length1 = 0     //操作数数组长度
    @State var length2 = 0     //操作符数组长度
    @State var num1 = 0
    @State var num2 = 0
    @State var temp = 0        //储存运算的中间结果
    @State var flag1 = true    //我们从根源上不让用户输入错误，即输入1+后不能再输入-这样的操作服了。得闲输入数字
    
    let buttons: [[CalcButton]] = [
        [.clear, .negative, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .equal],
    ]

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            VStack {                // Text display
                VStack{
                    HStack {
                        Spacer()
                        Text(userValue)
                            .bold()
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(2)
                            //限制最多两行
                            .padding()
                    }
                }
                // Our buttons
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { item in
                            Button(action: {
                                self.didTap(button: item)
                            }, label: {
                                Text(item.rawValue)
                                    .font(.system(size: 32))
                                    .frame(
                                        width: self.buttonWidth(item: item),
                                        height: self.buttonHeight()
                                    )
                                    .background(item.buttonColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(self.buttonWidth(item: item)/5)
                            })
                        }
                    }
                    .padding(.bottom, 3)
                }
            }
        }
    }
    func Prioity(op:Operation) -> Int
    {
        switch op {
        case .add: return 0
        case .subtract: return 1
        case .multiply: return 2
        case .divide: return 2
        case .equal: return -1
        case .none:
            return -2
        }
    }
    func Calculate(num1:Int,num2:Int,op:Operation) -> Int
    {
        switch op {
        case .add: self.value = "\(num1 + num2)"
           // self.userValue+=self.value
        case .subtract: self.value = "\(num2 - num1)"
           // self.userValue+=self.value
        case .multiply: self.value = "\(num1 * num2)"
            //self.userValue+=self.value
        case .divide: self.value = "\(num2 / num1)"
           // self.userValue+=self.value
        case .equal:
            break
        case .none:
            break
        }
        return Int(self.value) ?? 0
    }
    func didTap(button: CalcButton) {
        var flag = true
        switch button {
        case .add, .subtract, .multiply, .divide, .equal:
            if button == .add && self.flag1{
//                self.currentOperation = .add
                self.runningNumber = Int(self.value) ?? 0
                self.numbers.push(element: runningNumber)
                self.userValue += "+"
                self.options.push(element: .add)
                self.length2+=1
                self.flag1 = false
            }
            else if button == .subtract && self.flag1 {
//                self.currentOperation = .subtract
                self.runningNumber = Int(self.value) ?? 0
                self.numbers.push(element: runningNumber)
                self.userValue += "-"
                self.options.push(element: .subtract)
                self.length2+=1
                self.flag1 = false
            }
            else if button == .multiply && self.flag1{
//                self.currentOperation = .multiply
                self.runningNumber = Int(self.value) ?? 0
                self.numbers.push(element: runningNumber)
                self.userValue += "x"
                self.options.push(element: .multiply)
                self.length2+=1
                self.flag1 = false
            }
            else if button == .divide && self.flag1{
//                self.currentOperation = .divide
                self.runningNumber = Int(self.value) ?? 0
                self.numbers.push(element: runningNumber)
                self.userValue += "÷"
                self.options.push(element: .divide)
                self.length2+=1
                self.flag1 = false
            }
            //根据操作数栈和操作符号栈的情况计算结果
            else if button == .equal {
                self.options.push(element: .equal)
                self.userValue += "="
                var a = self.numbers.count
                var b = self.options.count
                print("numbers \(a)  options \(b)")
//                let runningValue = self.runningNumber
//                let currentValue = Int(self.value) ?? 0
//                self.Calculate(num1: runningNumber, num2: currentValue, op: currentOperation)
                //注意num1,num2和进栈顺序是反的
                //下面我们根据操作数栈和操作符号栈里面的东西算结果
                //把等号也加进去了
                if a<2
                {
                    self.userValue = "error"
                }
                else
                {
                    while a>=2 && b>=2 && flag
                    {
                        let num1 = self.numbers.pop() ?? 0
                        
                        let op = self.options.pop() ?? .none
                        if(b>1)
                        {
                            if(self.Prioity(op: op) > self.Prioity(op: self.options.top() ?? .none))
                            {
                                let num2 = self.numbers.pop() ?? 0
                                temp = self.Calculate(num1: num1, num2: num2, op: op)
                                self.numbers.push(element: temp)
                                a = self.numbers.count
                                b = self.options.count
                            }
                            else
                            {
                                var numbers2 = Stack<Int>()
                                numbers.push(element: num1)
                                var options2 = Stack<Operation>()
                                options2.push(element: op)
                                //延迟运算
                                //这下面也不能直接做，因为还可能延迟运算
                                while b>=2
                                {
                                    let op2 = self.options.pop() ?? .none
                                    if self.numbers.isEmpty()
                                    {
                                        self.userValue = "error"
                                        flag = false
                                        break;
                                    }
                                    else
                                    {
                                        let num2 = self.numbers.pop() ?? 0
                                        options2.push(element: op2)
                                        numbers2.push(element: num2)
                                        if self.Prioity(op: op2) > self.Prioity(op: self.options.top() ?? .none)
                                        {
                                            options2.pop()
                                            numbers2.pop()
                                            self.numbers.push(element: num2)
                                            self.options.push(element: op2)
                                            break;
                                        }
                                    }
                                }
                                if self.numbers.count < 2
                                {
                                    self.userValue = "error"
                                    break;
                                }
                                else
                                {
                                    let num4 = self.numbers.pop() ?? 0
                                    let num5 = self.numbers.pop() ?? 0
                                    let op3 = self.options.pop() ?? .none
                                    temp = self.Calculate(num1: num4, num2: num5, op: op3)
                                    self.numbers.push(element: temp)
                                    
                                    var cnt1 = numbers2.count
                                    var cnt2 = options2.count
                                    while cnt1>0
                                    {
                                        let s = numbers2.pop() ?? 0
                                        self.numbers.push(element: s)
                                        cnt1-=1
                                    }
                                    while cnt2>0
                                    {
                                        let m = options2.pop() ?? .none
                                        self.options.push(element: m)
                                        cnt2-=1
                                    }
                                }
                            }
                        }
                        else
                        {
                            let num2 = self.numbers.pop() ?? 0
                            //说明操作符栈中已经没东西了
                            temp = self.Calculate(num1: num1, num2: num2, op: op)
                            self.numbers.push(element: temp)
                            a = self.numbers.count
                            b = self.options.count
                        }
                    }
                }
                    //self.userValue+=self.value
                self.userValue+=self.value
                //貌似第二个数入栈的时候出问题了。。
//                self.value = "\(num1)   \(num2)"
//                self.userValue+=self.value
            }

            if button != .equal {
                self.value = "0"
            }
        case .clear:
            self.userValue = "0"
            self.value = "0"
            self.flag1 = true
            self.numbers.clear()
            self.options.clear()
        //暂时没有完成这些功能
        case .negative, .percent:
            break
        default:
            self.flag1 = true
            let number = button.rawValue
            if self.userValue == "0" {
                self.value = number
                self.userValue = number
                self.numbers.push(element: Int(self.value) ?? 0)
            }
            else {
                
                self.value = "\(self.value)\(number)"
                self.userValue = "\(self.userValue)\(number)"
                self.numbers.pop()
                self.numbers.push(element: Int(self.value) ?? 0)
            }
        }
    }
//为了适配不同的IOS移动端设备
    func buttonWidth(item: CalcButton) -> CGFloat {
        if item == .zero {
            return ((UIScreen.main.bounds.width - (4*12)) / 4) * 2
        }
        if item == .equal {
            return ((UIScreen.main.bounds.width - (4*12)) / 4) * 2.1
        }
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }

    func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
