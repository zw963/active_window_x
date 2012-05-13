# -*- coding:utf-8; mode:ruby; -*-

module ActiveWindowX

  # binding for Display on X11
  class Display

    # raw class of Display
    attr_reader :raw

    # a boolean which be true if this display was closed
    attr_reader :closed
    alias :closed? :closed

    def initialize arg=nil
      @raw =
        if arg.nil? or arg.kind_of? String
          Xlib::x_open_display arg
        elsif arg.kind_of? Xlib::Display
          arg
        else
          raise ArgumentError, 'expect nil, String or Xlib::Display'
        end
      @closed = false
      @root_window = nil
      @cache = {}
    end

    def close
      Xlib::x_close_display @raw
      @closed = true
    end

    def root_window
      @root_window ||= RootWindow.new self, Xlib::default_root_window(@raw)
    end

    def active_window
      root_window.active_window
    end

    def intern_atom name
      if @cache.has_key? name
        @cache[name]
      else
        @cache[name] = Xlib::x_intern_atom @raw, name, false
      end
    end

    def atom_name id
      if @cache.has_key? id
        @cache[id]
      else
        @cache[id] = Xlib::x_atom_name @raw, id
      end
    end
  end

end
