import
  strutils

import
  bgfxdotnim
  , bgfxdotnim.platform
  , sdl2 as sdl,
  bgfxextrasdotnim

import
  ../graphics,
  logo

const WIDTH = 960
const HEIGHT = 540

var ctx : ptr NVGContext

type
  DemoData = object
    fontNormal, fontBold, fontIcons: int
    images: array[12, int]

proc `/`(x, y: uint16): uint16 =
    x div y


let targetFramePeriod: uint32 = 20 # 20 milliseconds corresponds to 50 fps
var frameTime: uint32 = 0

proc limitFrameRate*() =
  let now = getTicks()
  if frameTime > now:
    delay(frameTime - now) # Delay to maintain steady frame rate
  frameTime += targetFramePeriod

proc getTime(): float64 =
    return float64(sdl.getPerformanceCounter()*1000) / float64 sdl.getPerformanceFrequency()


var g = newGraphics()

g.init("bgfx.nim Example00-HelloWorld", WIDTH, HEIGHT, SDL_WINDOW_SHOWN or SDL_WINDOW_RESIZABLE)

discard imguiCreate()

ctx = nvgCreate(1, 0.cuchar)
bgfx_set_view_seq(0, true)

proc drawWindow(ctx: ptr NVGContext, title: string, x, y, w, h: float) =
  let cornerRadius = 3.0

  var shadowPaint: NVGPaint
  var headerPaint: NVGPaint
  
  nvgSave(ctx)

  # Window
  nvgBeginPath(ctx);
  nvgRoundedRect(ctx, x,y, w,h, cornerRadius);
  nvgFillColor(ctx, nvgRGBA(28.cuchar,30.cuchar,34.cuchar,192.cuchar) );
  #	nvgFillColor(vg, nvgRGBA(0,0,0,128) );
  nvgFill(ctx);

  # Drop shadow
  shadowPaint = nvgBoxGradient(ctx, x,y+2, w,h, cornerRadius*2, 10, nvgRGBA(0.cuchar,0.cuchar,0.cuchar,128.cuchar), nvgRGBA(0.cuchar,0.cuchar,0.cuchar,0.cuchar) )
  nvgBeginPath(ctx)
  nvgRect(ctx, x-10,y-10, w+20,h+30)
  nvgRoundedRect(ctx, x,y, w,h, cornerRadius)
  nvgPathWinding(ctx, NVG_HOLE.ord)
  nvgFillPaint(ctx, shadowPaint)
  nvgFill(ctx)

  # Header
  headerPaint = nvgLinearGradient(ctx, x,y,x,y+15, nvgRGBA(255.cuchar,255.cuchar,255.cuchar,8.cuchar), nvgRGBA(0.cuchar,0.cuchar,0.cuchar,16.cuchar) )
  nvgBeginPath(ctx)
  nvgRoundedRect(ctx, x+1,y+1, w-2,30, cornerRadius-1)
  nvgFillPaint(ctx, headerPaint)
  nvgFill(ctx)
  nvgBeginPath(ctx)
  nvgMoveTo(ctx, x+0.5f, y+0.5f+30)
  nvgLineTo(ctx, x+0.5f+w-1, y+0.5f+30)
  nvgStrokeColor(ctx, nvgRGBA(0.cuchar,0.cuchar,0.cuchar,32.cuchar) )
  nvgStroke(ctx)

  nvgFontSize(ctx, 18.0f)
  nvgFontFace(ctx, "sans-bold")
  nvgTextAlign(ctx, NVG_ALIGN_CENTER.ord or NVG_ALIGN_MIDDLE.ord)

  nvgFontBlur(ctx,2)
  nvgFillColor(ctx, nvgRGBA(0.cuchar,0.cuchar,0.cuchar,128.cuchar) )
  discard nvgText(ctx, x+w/2,y+16+1, title, nil)

  nvgFontBlur(ctx,0)
  nvgFillColor(ctx, nvgRGBA(220.cuchar,220.cuchar,220.cuchar,160.cuchar) )
  discard nvgText(ctx, x+w/2,y+16, title, nil)

  nvgRestore(ctx)

var demoData: DemoData

proc drawDemo(ctx: ptr NVGContext) =
  drawWindow(ctx, "Widgets `n Stuff", 50, 50, 300, 400)

proc loadDemoData(ctx: ptr NVGContext, data: var DemoData) =
  echo nvgCreateFont(ctx, "icons", "/Users/zachcarter/projects/bgfx.extras.nim/examples/font/entypo.ttf")
  echo nvgCreateFont(ctx, "sans-bold", "/Users/zachcarter/projects/bgfx.extras.nim/examples/font/roboto-bold.ttf")

loadDemoData(ctx, demoData)

var
  event = sdl.defaultEvent
  runGame = true


while runGame:
  while sdl.pollEvent(event):
    case event.kind
    of sdl.QuitEvent:
      runGame = false
      break
    else:
      discard

  var now = getTime()
  var last {.global.} = getTime()
  let frameTime: float32 = now - last
  let time = getTime()
  last = now
  var toMs = 1000.0'f32

  discard bgfx_touch(0)

  bgfx_dbg_text_clear(0, false)
  bgfx_dbg_text_printf(1, 1, 0x0f, "Frame: %7.3f[ms] FPS: %7.3f", float32(frameTime), (1.0 / frameTime) * toMs)

  bgfx_set_view_clear(0, BGFX_CLEAR_COLOR or BGFX_CLEAR_DEPTH, 0x303030ff, 1.0, 0)

  nvgBeginFrame(ctx, WIDTH, HEIGHT, 1.0f)

  drawDemo(ctx)

  nvgEndFrame(ctx)

  discard bgfx_frame(false)
  
  limitFrameRate()

g.dispose()