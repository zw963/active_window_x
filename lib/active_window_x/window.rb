# -*- coding:utf-8; mode:ruby; -*-

module ActiveWindowX

  # binding for Window on X11
  class Window

    # a buffer for #x_get_window_property
    READ_BUFF_LENGTH = 1024

    # a display which has this window
    attr_reader :display

    # window ID (#define Window unsinged long)
    attr_reader :id

    def initialize display, id
      if display.kind_of? Display
        @display = display
      elsif display.kind_of? Xlib::Display
        @display = Display.new display
      else
        raise ArgumentError, "expect #{Display.name} or #{Xlib::Display.name}"
      end
      @id = id
    end

    def x_query_tree
      Xlib::x_query_tree @display.raw, @id
    end

    # a return value of XQueryTree
    def root
      (r = x_query_tree[0]) and Window.new(@display, r)
    end

    # a return value of XQueryTree
    def parent
      (r = x_query_tree[1]) and Window.new(@display, r)
    end

    # a return value of XQueryTree
    def children
      x_query_tree[2].map{|w|Window.new(@display, w)}
    end

    # window property getter wiith XGetWindowProperty
    def prop name
      atom = @display.intern_atom name
      actual_type, actual_format, nitems, bytes_after, val =
        Xlib::x_get_window_property @display, @id, atom, 0, READ_BUFF_LENGTH, false, Xlib::AnyPropertyType

      case actual_format
      when 32; val.unpack("l!#{nitems}")
      when 16; val.unpack("s#{nitems}")
      when 8; val
      when 0; nil
      end
    end
  end

end
