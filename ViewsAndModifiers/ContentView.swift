//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Steven Gustason on 3/23/23.
//

import SwiftUI

// You can also create your own custom views like this
struct CapsuleText: View {
    var text: String

    var body: some View {
        Text(text)
            .font(.largeTitle)
            .padding()
            .foregroundColor(.white)
            .background(.blue)
            .clipShape(Capsule())
    }
}

// You can also create your own modifiers that comply with the ViewModifier protocol (it has a method called body that accepts whatever it's given and returns some View) - you can use this if you want to apply a specific style to multiple views
struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.white)
            .padding()
            .background(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

// When you create a custom modifier, you usually want to create an extension to make it easier to use
extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

// Here's another custom modifier for large blue title text
struct MainTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.blue)
    }
}

extension View {
    func mainTitleStyle() -> some View {
        modifier(MainTitle())
    }
}

// You can also create custom modifiers to create new view structure, like the one below which embeds the view in a stack and creates another view, allowing us to easily add a watermark to any view
struct Watermark: ViewModifier {
    var text: String

    func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing) {
            content
            Text(text)
                .font(.caption)
                .foregroundColor(.white)
                .padding(5)
                .background(.black)
        }
    }
}

extension View {
    func watermarked(with text: String) -> some View {
        modifier(Watermark(text: text))
    }
}

// You can also create your own custom containers, though this is a little more complicated

struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    @ViewBuilder let content: (Int, Int) -> Content

    var body: some View {
        VStack {
            ForEach(0..<rows, id: \.self) { row in
                HStack {
                    ForEach(0..<columns, id: \.self) { column in
                        content(row, column)
                    }
                }
            }
        }
    }
}

struct ContentView: View {
    @State private var useRedText = false
    
    // You can create properties that make it easier to make complex views
    let motto1 = Text("Draco dormiens")
    let motto2 = Text("nunquam titillandus")
    
    // You can also create computed properties. If you want to return multiple views, you need to either put them in a stack, a group, or add the @ViewBuilder attribute
    @ViewBuilder var spells: some View {
        Text("Lumos")
        Text("Obliviate")
    }
    
    var body: some View {
        VStack {
            Text("Hello, world!")
            // You can use the same property multiple times and it will add to whatever was there before
                .padding()
                .background(.white)
                .padding()
                .background(.blue)
                .padding()
                .background(.green)
                .padding()
                .background(.yellow)
                .font(.largeTitle)
                .blur(radius: 0)
            
            // You can then use your properties inside a container and add modifiers to them directly
            motto1
            // You can then use your custom modifiers using the .modifier modifier
                .modifier(Title())
            motto2
            // Or you can use your extension which makes applying a custom modifier even easier
                .titleStyle()
            spells
                .mainTitleStyle()
            
            // You can then use your custom views inside of your original view
            CapsuleText(text: "First")
            CapsuleText(text: "Second")
            
            // We can then use our custom containers
            GridStack(rows: 4, columns: 4) { row, col in
                Image(systemName: "\(row * 4 + col).circle")
                Text("R\(row) C\(col)")
            }
            
            Button("Hello, world!") {
                // Each time the button is clicked it will toggle our useRedText variable
                useRedText.toggle()
            }
            .frame(width: 200, height: 200)
            .background(.white)
            // Conditional modifiers most often use the ternary operator - in this case, if useRedText is true we will have red text, otherwise it will be blue
            .foregroundColor(useRedText ? .red : .blue)
        }
        // Environmental modifiers are applied to the container and affect everything inside. However, if any of the child views override the same property, the child's version takes priority - see the .font(.largeTitle) for the Text above.
        .font(.title)
        // However, not all modifiers can be environmental. Blur is a regular modifier, so if I apply that here, any child view modifiers are added to the VStack rather than overriding.
        .blur(radius: 1)
        // We used our custom watermarking modifier to embed this whole VStack in a Zstack and add a watermark to the bottom
        .watermarked(with: "Hacking with Swift")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.red)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
