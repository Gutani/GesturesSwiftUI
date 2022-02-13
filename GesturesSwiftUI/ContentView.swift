//
//  ContentView.swift
//  GesturesSwiftUI
//
//  Created by Gustavo Malheiros on 13/02/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        ScrollView {
            VStack{
                SimpleTapGesture()
                Divider()
                LongPresGesture()
                Divider()
                DragGestur()
                Divider()
                CombiningGestures()
            }
        }
    }
}


struct CombiningGestures:View {
    
    @GestureState var dragOffSet = CGSize.zero
    @State var position = CGSize.zero
    @GestureState var isPressed = false
    
    var body: some View {
        Image(systemName: isPressed ? "flame.fill" : "flame").foregroundColor(.pink).font(.system(size: 150)).offset(x: position.width + dragOffSet.width, y: position.height + dragOffSet.height).gesture(LongPressGesture(minimumDuration: 1).updating($isPressed, body: {
            (currentState, state, transaction) in
            state = currentState
        }).sequenced(before: DragGesture()).updating($dragOffSet, body: {
            value, state, transaction in
            state = .zero
            
        }).onEnded { value in
            
            guard case .second(true, let drag?) = value else {
                return
            }
            
            position.height += drag.translation.height
            position.width += drag.translation.width
        }
                                                                                                                                                                                                           
        )
    }
}


struct DragGestur: View {
    @GestureState var dragOffSet = CGSize.zero
    
    //Variable to maintain the image where it stop
    @State var position = CGSize.zero
    
    var body: some View {
        Image(systemName: "sun.dust.fill").font(.system(size: 150)).foregroundColor(.blue)
            .offset(x: position.width + dragOffSet.width, y: position.height + dragOffSet.height)
            .gesture(gesture).gesture(LongPressGesture(minimumDuration: 0.5).onEnded { _ in
                position.width = dragOffSet.width
                position.height = dragOffSet.height
            })
    }
    
    var gesture: some Gesture {
        DragGesture().updating($dragOffSet) {
            value, state, transaction in
            state = value.translation
        }.onEnded { value in
            position.height += value.translation.height
            position.width += value.translation.width
        }
    }
}



struct LongPresGesture:View {
    @State var isPressed = false
    
    //Keeps track of the state change of a gesture
    @GestureState var isDetectingLongPress = false
    @State var completedLongPress = false
    
    var gesture: some Gesture {
        LongPressGesture(minimumDuration: 0.5).updating($isDetectingLongPress) {
            currentState, gestureState, transaction in
            gestureState = currentState
            
        }.onEnded { finished in
            completedLongPress = finished
            isPressed.toggle()
        }
    }
    
    
    var body: some View{
        Image(systemName: isPressed ? "record.circle" : "record.circle.fill").font(.system(size: 200)).foregroundColor(.red).opacity(isDetectingLongPress ? 0.5 : 1.0).scaleEffect(isPressed ? 0.6 : 0.5).animation(Animation.easeInOut, value: isPressed).gesture(
            gesture
        )
    }
}

struct SimpleTapGesture:View {
    @State var isPressed = false
    
    var body: some View {
        Image(systemName: isPressed ? "trash.fill" : "trash" ).font(.system(size: 200)).scaleEffect(isPressed ? 0.6 : 0.5).animation(Animation.linear, value: isPressed).foregroundColor(.yellow).gesture(TapGesture().onEnded {
            isPressed.toggle()
        })
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
