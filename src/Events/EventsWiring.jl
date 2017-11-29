
#module NaquadahEvents
# using Cairo, Gtk, Gtk.ShortNames

export  splotch, ScrollEvent, # not sure all this needs exported (?)
        DragEvent, MouseDownEvent, ClickEvent #, Event,


"""
##

...

# Examples
```julia-repl
```
[Source](https://github.com/TravisA9/NaquadahBrowser/blob/39c41cbb1ac28fe94876fe01beaa6e046c8b63d3/src/DOM/DomTree.jl#L54)
"""
# ======================================================================================
#
# ======================================================================================
function DragEvent(document, widget, event)
    println("drag from X $(event.pressed.x), Y $(event.pressed.y) to X $(event.released.x), Y $(event.released.y)")
end
# ======================================================================================
#
# ======================================================================================
function DrawEvent(document, widget, event)
    println("move x$(event.x) y$(event.y)")
end
# ======================================================================================
#
# ======================================================================================
function onArea( shape , x, y)
    l, t, r, b = getBorderBox(shape::Draw)
    #println("$l, $t, $r, $b")
    if x > l && x < l+r && y > t && y < t+b
        return true
    end
    return false
end
# ======================================================================================
#
# ======================================================================================
function MouseDownEvent(document, widget, event)
    down = document.eventsList.mousedown
    println("clicked: ", event.x, event.y)
    for node in down

        l, t = node.shape.left, node.shape.top
        println("(1) Left: $(l), Top: $(t)")
        if onArea( node.shape, event.x, event.y)
            c = getgc(document.canvas)
            page = document.children[1].children[3]
            node.shape.top += abs(page.scroll.y)
            println("page.scroll.y: ....... $(abs(page.scroll.y))")
            #contentHeight

            #d = Dict("color" => "red")

            setAttribute(node, "color", "red")
            println("(2) Left: $(l), Top: $(t)")
                    AtributesToLayout(document, node, false)
            # VmoveAllChildren(page, page.scroll.y, false)
            println("(3) Left: $(l), Top: $(t)")
            CreateLayoutTree(document, node)
            println("(4) Left: $(l), Top: $(t)")
            DrawContent(c, document, node)
            show(c)
            # d.shape mousedown
            println("(5) Left: $(l), Top: $(t)")

        end
    end
end
# ======================================================================================

# ======================================================================================
function setAttribute(d, key::String, attribute::String)
    println(d.DOM)
    d.DOM[key] = attribute
end
# ======================================================================================
#
# ======================================================================================
function ClickEvent(document, widget, event)
    splotch(widget, event,1.0,0.0,0.0)
end
# ======================================================================================
#
# ======================================================================================
function OnObject(document, x, y, all=true)


end
# ======================================================================================
#
# ======================================================================================
function ScrollEvent(document, widget, event)
  ctx = getgc(widget)
  node = document.children[1].children[3] # TODO: fix! ..test to see if mouse is over object.

  Unit = 50.0

  # I am scrolling(jumping) by 30px here but Opera scrolls by about 50px
  # Opera lacks smoothness too but it seems to transition-scroll by the 50px
  # ...so using the mouse wheel it is impossible to move less than that increment.

  # SCROLL UP!
  if event.direction == 0 && node.scroll.y < node.shape.top # was: 0
    diff = abs(node.scroll.y)
    if diff < Unit
      Unit = diff
    end
      node.scroll.y += Unit
      VmoveAllChildren(node, Unit, false)
    # SCROLL DOWN!
elseif event.direction == 1 && (node.scroll.contentHeight + node.scroll.y + node.shape.top) > node.shape.height
      diff = (node.scroll.contentHeight + node.scroll.y + node.shape.top) - node.shape.height
      if diff < Unit
        Unit = diff
      end
       node.scroll.y -= Unit
          VmoveAllChildren(node, -Unit, false) # -30
  end

  #set_source_rgb(ctx, 1,1,1)
  setcolor( ctx, node.shape.color...)
  rectangle(ctx,  node.shape.left,  node.shape.top, node.shape.width,  node.shape.height )
  fill(ctx);

  #Shape = getShape(node)
  DrawViewport(ctx, document, node)
  reveal(widget)

end
# ======================================================================================
# Draw a splotch
# CALLED FROM:
# ======================================================================================
function splotch(widget,event,r,g,b)
      ctx = getgc(widget)
            deg = (pi/180.0)
        s1, e1 = 1 * deg, 100 * deg
        s2, e2 = 120 * deg, 220 * deg
        s3, e3 = 240 * deg, 340 * deg
        move_to(ctx, event.x, event.y)
        set_line_width(ctx, 2.56);
        set_antialias(ctx,4)
        set_source_rgb(ctx, r, g, b)
        arc(ctx, event.x, event.y, 2, 0, 2pi) # 0, 2pi
        stroke(ctx)

        #set_line_width(ctx, 3);
        set_source_rgba(ctx, r, g, b, 0.7)
        arc(ctx, event.x, event.y, 5, s1, e1) # 0, 2pi
        stroke(ctx)
        arc(ctx, event.x, event.y, 5, s2, e2) # 0, 2pi
        stroke(ctx)
        arc(ctx, event.x, event.y, 5, s3, e3) # 0, 2pi
        stroke(ctx)
        # arc_negative(cr, xc, yc, node.shape.radius,
        #     node.shape.angle[1] * (pi/180.0),
        #     node.shape.angle[2] * (pi/180.0));

        #set_line_width(ctx, 2);
        set_source_rgba(ctx, r, g, b, 0.5)
        arc(ctx, event.x, event.y, 8, s1, e1)
        stroke(ctx)
        arc(ctx, event.x, event.y, 8, s2, e2)
        stroke(ctx)
        arc(ctx, event.x, event.y, 8, s3, e3)
        stroke(ctx)

        #set_line_width(ctx, 1);
        set_source_rgba(ctx, r, g, b, 0.3)
        arc(ctx, event.x, event.y, 11, s1, e1)
        stroke(ctx)
        arc(ctx, event.x, event.y, 11, s2, e2)
        stroke(ctx)
        arc(ctx, event.x, event.y, 11, s3, e3)
        stroke(ctx)
        reveal(widget)
    end
#end # module
