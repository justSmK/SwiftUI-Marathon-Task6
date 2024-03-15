//
//  ContentView.swift
//  SwiftUIMarathonTask6
//
//  Created by Sergei Semko on 3/15/24.
//

import SwiftUI

enum LayoutType {
    case horizontal
    case diagonal
}

struct ContentView: View {
    
    private let spacing: CGFloat = 10
    
    @State var countOfSquare = 10
    @State var layoutType = LayoutType.horizontal
    
    var body: some View {
        GeometryReader(content: { geometry in
            HStack(alignment: .center, content: {
                Button {
                    if countOfSquare > 1 {
                        countOfSquare -= 1
                    }
                } label: {
                    Image(systemName: "minus")
                        .font(.largeTitle)
                }

                Button {
                    countOfSquare += 1
                } label: {
                    Image(systemName: "plus")
                        .font(.largeTitle)
                }
            })
            .frame(maxWidth: .infinity)
            
            
            
            let layout = switch layoutType {
            case .horizontal:
                AnyLayout(HStackLayout(spacing: spacing))
            case .diagonal:
                AnyLayout(CustomStack())
            }
            
            layout {
                ForEach(0..<countOfSquare, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 6)
                        .fill(.blue)
                        .aspectRatio(contentMode: .fit)
                }.onTapGesture {
                    withAnimation {
                        layoutType = layoutType == .diagonal ? .horizontal : .diagonal
                    }
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        })
    }
}

struct CustomStack: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        CGSize(
            width: proposal.width ?? .zero,
            height: proposal.height ?? .zero
        )
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let size = bounds.height / CGFloat(subviews.count)
        
        var pointX = bounds.minX
        var pointY = bounds.maxY - size
        
        subviews.forEach { layoutSubview in
            layoutSubview
                .place(
                    at: CGPoint(x: pointX, y: pointY),
                    proposal: ProposedViewSize(width: size, height: size)
                )
            
            pointX += (bounds.width - size) / CGFloat(subviews.count - 1)
            pointY -= size
        }
    }
    
    
}

#Preview {
    ContentView()
}
