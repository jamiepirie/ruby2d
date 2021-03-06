# ruby2d-opal.rb

# Ruby 2D window
$R2D_WINDOW = nil

# Simple 2D window
`var win;`


`// ruby2d.js

// @type_id values for rendering
const $R2D_TRIANGLE = 1;
const $R2D_QUAD     = 2;
const $R2D_IMAGE    = 3;
const $R2D_SPRITE   = 4;
const $R2D_TEXT     = 5;


function on_key(e, key) {
  switch (e) {
    case S2D.KEYDOWN:
      #{$R2D_WINDOW.key_down_callback(`key`)};
      break;
    
    case S2D.KEY:
      #{$R2D_WINDOW.key_callback(`key`)};
      break;
    
    case S2D.KEYUP:
      #{$R2D_WINDOW.key_up_callback(`key`)};
      break;
  }
}


function on_mouse(x, y) {
  #{$R2D_WINDOW.mouse_callback("any", `x`, `y`)};
}


function update() {
  #{$R2D_WINDOW.mouse_x = `win.mouse.x`};
  #{$R2D_WINDOW.mouse_y = `win.mouse.y`};
  #{$R2D_WINDOW.frames  = `win.frames`};
  #{$R2D_WINDOW.fps     = `win.fps`};
  #{$R2D_WINDOW.update_callback};
}


function render() {
  
  // Set background color
  win.background.r = #{$R2D_WINDOW.get(:background).r};
  win.background.g = #{$R2D_WINDOW.get(:background).g};
  win.background.b = #{$R2D_WINDOW.get(:background).b};
  win.background.a = #{$R2D_WINDOW.get(:background).a};
  
  var objects = #{$R2D_WINDOW.objects};
  
  for (var i = 0; i < objects.length; i++) {
    
    var el = objects[i];
    
    switch (el.type_id) {
      
      case $R2D_TRIANGLE:
        
        S2D.DrawTriangle(
          el.x1, el.y1, el.c1.r, el.c1.g, el.c1.b, el.c1.a,
          el.x2, el.y2, el.c2.r, el.c2.g, el.c2.b, el.c2.a,
          el.x3, el.y3, el.c3.r, el.c3.g, el.c3.b, el.c3.a
        );
        break;
      
      case $R2D_QUAD:
        S2D.DrawQuad(
          el.x1, el.y1, el.c1.r, el.c1.g, el.c1.b, el.c1.a,
          el.x2, el.y2, el.c2.r, el.c2.g, el.c2.b, el.c2.a,
          el.x3, el.y3, el.c3.r, el.c3.g, el.c3.b, el.c3.a,
          el.x4, el.y4, el.c4.r, el.c4.g, el.c4.b, el.c4.a
        );
        break;
      
      case $R2D_IMAGE:
        el.data.x = el.x;
        el.data.y = el.y;
        
        if (el.width  != Opal.nil) el.data.width  = el.width;
        if (el.height != Opal.nil) el.data.height = el.height;
        
        el.data.color.r = el.color.r;
        el.data.color.g = el.color.g;
        el.data.color.b = el.color.b;
        el.data.color.a = el.color.a;
        
        S2D.DrawImage(el.data);
        break;
      
      case $R2D_SPRITE:
        el.data.x = el.x;
        el.data.y = el.y;
        
        S2D.ClipSprite(
          el.data,
          el.clip_x,
          el.clip_y,
          el.clip_w,
          el.clip_h
        );
        
        S2D.DrawSprite(el.data);
        break;
      
      case $R2D_TEXT:
        el.data.x = el.x;
        el.data.y = el.y;
        
        el.data.color.r = el.color.r;
        el.data.color.g = el.color.g;
        el.data.color.b = el.color.b;
        el.data.color.a = el.color.a;
        
        S2D.DrawText(el.data);
        break;
    }
    
  }
}`


module Ruby2D
  class Image
    def init(path)
      `#{self}.data = S2D.CreateImage(path);`
    end
  end
  
  class Sprite
    def init(path)
      `#{self}.data = S2D.CreateSprite(path);`
    end
  end
  
  class Text
    def init
      `#{self}.data = S2D.CreateText(#{self}.font, #{self}.text, #{self}.size);`
      @width  = `#{self}.data.width;`
      @height = `#{self}.data.height;`
    end
    
    def ext_text_set(msg)
      `S2D.SetText(#{self}.data, #{msg});`
      @width  = `#{self}.data.width;`
      @height = `#{self}.data.height;`
    end
  end
  
  class Sound
    def init(path)
      `#{self}.data = S2D.CreateSound(path);`
    end
    
    def play
      `S2D.PlaySound(#{self}.data);`
    end
  end
  
  class Music
    def init(path)
      `#{self}.data = S2D.CreateMusic(path);`
    end
    
    def play
      `S2D.PlayMusic(#{self}.data, #{self}.loop);`
    end
    
    def pause
      `S2D.PauseMusic();`
    end
    
    def resume
      `S2D.ResumeMusic();`
    end
    
    def stop
      `S2D.StopMusic();`
    end
    
    def fadeout(ms)
      `S2D.FadeOutMusic(ms);`
    end
  end
  
  class Window
    def show
      $R2D_WINDOW = self
      
      `
      var width  = #{$R2D_WINDOW.get(:width)};
      var height = #{$R2D_WINDOW.get(:height)};
      
      var vp_w = #{$R2D_WINDOW.get(:viewport_width)};
      var viewport_width = vp_w != Opal.nil ? vp_w : width;
      
      var vp_h = #{$R2D_WINDOW.get(:viewport_height)};
      var viewport_height = vp_h != Opal.nil ? vp_h : height;
      
      win = S2D.CreateWindow(
        #{$R2D_WINDOW.get(:title)}, width, height, update, render, "ruby2d-app", {}
      );
      
      win.viewport.width  = viewport_width;
      win.viewport.height = viewport_height;
      win.on_key          = on_key;
      win.on_mouse        = on_mouse;
      
      S2D.Show(win);`
    end
  end
end
