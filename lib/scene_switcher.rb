require "scene_switcher/version"

module SceneSwitcher
  @gc_on_switch = false
  @file = nil
  @proc_cache = {}
  
  module_function
  
  def gc_on_switch
    @gc_on_switch
  end
  
  def gc_on_switch=(bool)
    @gc_on_switch = bool
  end
  
  def force_gc
    tmp_gc_disable = GC.enable
    GC.start
    GC.disable if tmp_gc_disable
  end
  
  def cache(file, priv = false)
    begin
      expr = File.binread(file)
    rescue
      raise LoadError, "cannot load such file -- #{file}"
    end
    encoding = "UTF-8"
    encoding = $1 if expr.lines[0..2].join("\n").match(/coding:\s*(\S+)/)
    expr.force_encoding(encoding)
    if priv
      @proc_cache[file] = eval("Proc.new {\nmodule Module.new::SceneSwitcherTemporaryModule\n#{expr}\nend\n}", Object::TOPLEVEL_BINDING, file, -1)
    else
      @proc_cache[file] = eval("Proc.new {\n#{expr}\n}", Object::TOPLEVEL_BINDING, file, 0)
    end
  end
  
  def switch_to(file, priv = false)
    if @file
      @file = file
      throw :sceneswitcher_switch_signal
    else
      @file = file
      while @file
        force_gc if @gc_on_switch
        catch(:sceneswitcher_switch_signal) do
          cache(@file, priv) unless @proc_cache[@file]
          @proc_cache[@file].call
          @file = nil
        end
      end
      exit
    end
  end
end

def switch_to(file, priv = false)
  SceneSwitcher.switch_to(file, priv)
end

