import
  bgfxdotnim,
  fontstash

const NVG_MAX_STATES = 32
const NVG_MAX_FONTIMAGES = 4

type
  INNER_C_STRUCT_360867024* = object
    r*: cfloat
    g*: cfloat
    b*: cfloat
    a*: cfloat

  INNER_C_UNION_3941339160* = object {.union.}
    rgba*: array[4, cfloat]
    ano_369128525*: INNER_C_STRUCT_360867024

  NVGcolor* = object
    ano_377390029*: INNER_C_UNION_3941339160

  NVGpaint* = object
    xform*: array[6, cfloat]
    extent*: array[2, cfloat]
    radius*: cfloat
    feather*: cfloat
    innerColor*: NVGcolor
    outerColor*: NVGcolor
    image*: cint

  NVGwinding* = enum
    NVG_CCW = 1,                ##  Winding for solid shapes
    NVG_CW = 2                  ##  Winding for holes
  

  NVGsolidity* = enum
    NVG_SOLID = 1,              ##  CCW
    NVG_HOLE = 2                ##  CW

  NVGlineCap* = enum
    NVG_BUTT, NVG_ROUND, NVG_SQUARE, NVG_BEVEL, NVG_MITER

  NVGalign* = enum              ##  Horizontal align
    NVG_ALIGN_LEFT = 1 shl 0,     ##  Default, align text horizontally to left.
    NVG_ALIGN_CENTER = 1 shl 1,   ##  Align text horizontally to center.
    NVG_ALIGN_RIGHT = 1 shl 2,    ##  Align text horizontally to right.
                          ##  Vertical align
    NVG_ALIGN_TOP = 1 shl 3,      ##  Align text vertically to top.
    NVG_ALIGN_MIDDLE = 1 shl 4,   ##  Align text vertically to middle.
    NVG_ALIGN_BOTTOM = 1 shl 5,   ##  Align text vertically to bottom.
    NVG_ALIGN_BASELINE = 1 shl 6  ##  Default, align text vertically to baseline.

  NVGblendFactor* = enum
    NVG_ZERO = 1 shl 0, NVG_ONE = 1 shl 1, NVG_SRC_COLOR = 1 shl 2,
    NVG_ONE_MINUS_SRC_COLOR = 1 shl 3, NVG_DST_COLOR = 1 shl 4,
    NVG_ONE_MINUS_DST_COLOR = 1 shl 5, NVG_SRC_ALPHA = 1 shl 6,
    NVG_ONE_MINUS_SRC_ALPHA = 1 shl 7, NVG_DST_ALPHA = 1 shl 8,
    NVG_ONE_MINUS_DST_ALPHA = 1 shl 9, NVG_SRC_ALPHA_SATURATE = 1 shl 10

  NVGcompositeOperation* = enum
    NVG_SOURCE_OVER, NVG_SOURCE_IN, NVG_SOURCE_OUT, NVG_ATOP, NVG_DESTINATION_OVER,
    NVG_DESTINATION_IN, NVG_DESTINATION_OUT, NVG_DESTINATION_ATOP, NVG_LIGHTER,
    NVG_COPY, NVG_XOR

  NVGcompositeOperationState* = object
    srcRGB*: cint
    dstRGB*: cint
    srcAlpha*: cint
    dstAlpha*: cint

  NVGglyphPosition* = object
    str*: cstring              ##  Position of the glyph in the input string.
    x*: cfloat                 ##  The x-coordinate of the logical glyph position.
    minx*: cfloat
    maxx*: cfloat              ##  The bounds of the glyph shape.
  
  NVGtextRow* = object
    start*: cstring            ##  Pointer to the input text where the row starts.
    `end`*: cstring            ##  Pointer to the input text where the row ends (one past the last character).
    next*: cstring             ##  Pointer to the beginning of the next row.
    width*: cfloat             ##  Logical width of the row.
    minx*: cfloat
    maxx*: cfloat              ##  Actual bounds of the row. Logical with and bounds can differ because of kerning and some parts over extending.
  
  NVGimageFlags* = enum
    NVG_IMAGE_GENERATE_MIPMAPS = 1 shl 0, ##  Generate mipmaps during creation of the image.
    NVG_IMAGE_REPEATX = 1 shl 1,  ##  Repeat image in X direction.
    NVG_IMAGE_REPEATY = 1 shl 2,  ##  Repeat image in Y direction.
    NVG_IMAGE_FLIPY = 1 shl 3,    ##  Flips (inverses) image in Y direction when rendered.
    NVG_IMAGE_PREMULTIPLIED = 1 shl 4, ##  Image data has premultiplied alpha.
    NVG_IMAGE_NEAREST = 1 shl 5   ##  Image interpolation is Nearest instead Linear

  NVGscissor* = object
    xform*: array[6, cfloat]
    extent*: array[2, cfloat]

  NVGvertex* = object
    x*: cfloat
    y*: cfloat
    u*: cfloat
    v*: cfloat

  NVGpath* = object
    first*: cint
    count*: cint
    closed*: cuchar
    nbevel*: cint
    fill*: ptr NVGvertex
    nfill*: cint
    stroke*: ptr NVGvertex
    nstroke*: cint
    winding*: cint
    convex*: cint

  NVGparams* = object
    userPtr*: pointer
    edgeAntiAlias*: cint
    renderCreate*: proc (uptr: pointer): cint
    renderCreateTexture*: proc (uptr: pointer; `type`: cint; w: cint; h: cint;
                              imageFlags: cint; data: ptr cuchar): cint
    renderDeleteTexture*: proc (uptr: pointer; image: cint): cint
    renderUpdateTexture*: proc (uptr: pointer; image: cint; x: cint; y: cint; w: cint;
                              h: cint; data: ptr cuchar): cint
    renderGetTextureSize*: proc (uptr: pointer; image: cint; w: ptr cint; h: ptr cint): cint
    renderViewport*: proc (uptr: pointer; width: cint; height: cint;
                         devicePixelRatio: cfloat)
    renderCancel*: proc (uptr: pointer)
    renderFlush*: proc (uptr: pointer)
    renderFill*: proc (uptr: pointer; paint: ptr NVGpaint;
                     compositeOperation: NVGcompositeOperationState;
                     scissor: ptr NVGscissor; fringe: cfloat; bounds: ptr cfloat;
                     paths: ptr NVGpath; npaths: cint)
    renderStroke*: proc (uptr: pointer; paint: ptr NVGpaint;
                       compositeOperation: NVGcompositeOperationState;
                       scissor: ptr NVGscissor; fringe: cfloat; strokeWidth: cfloat;
                       paths: ptr NVGpath; npaths: cint)
    renderTriangles*: proc (uptr: pointer; paint: ptr NVGpaint;
                          compositeOperation: NVGcompositeOperationState;
                          scissor: ptr NVGscissor; verts: ptr NVGvertex; nverts: cint)
    renderDelete*: proc (uptr: pointer)

  NVGcommands* {.pure.} = enum
    NVG_MOVETO = 0, NVG_LINETO = 1, NVG_BEZIERTO = 2, NVG_CLOSE = 3, NVG_WINDING = 4

  NVGpointFlags* = enum
    NVG_PT_CORNER = 0x00000001, NVG_PT_LEFT = 0x00000002, NVG_PT_BEVEL = 0x00000004,
    NVG_PR_INNERBEVEL = 0x00000008

  NVGstate* = object
    compositeOperation*: NVGcompositeOperationState
    fill*: NVGpaint
    stroke*: NVGpaint
    strokeWidth*: cfloat
    miterLimit*: cfloat
    lineJoin*: cint
    lineCap*: cint
    alpha*: cfloat
    xform*: array[6, cfloat]
    scissor*: NVGscissor
    fontSize*: cfloat
    letterSpacing*: cfloat
    lineHeight*: cfloat
    fontBlur*: cfloat
    textAlign*: cint
    fontId*: cint

  NVGpoint* = object
    x*: cfloat
    y*: cfloat
    dx*: cfloat
    dy*: cfloat
    len*: cfloat
    dmx*: cfloat
    dmy*: cfloat
    flags*: cuchar

  NVGpathCache* = object
    points*: ptr NVGpoint
    npoints*: cint
    cpoints*: cint
    paths*: ptr NVGpath
    npaths*: cint
    cpaths*: cint
    verts*: ptr NVGvertex
    nverts*: cint
    cverts*: cint
    bounds*: array[4, cfloat]

  NVGcontext* = object
    params*: NVGparams
    commands*: ptr cfloat
    ccommands*: cint
    ncommands*: cint
    commandx*: cfloat
    commandy*: cfloat
    states*: array[NVG_MAX_STATES, NVGstate]
    nstates*: cint
    cache*: ptr NVGpathCache
    tessTol*: cfloat
    distTol*: cfloat
    fringeWidth*: cfloat
    devicePxRatio*: cfloat
    fs*: ptr FONScontext
    fontImages*: array[NVG_MAX_FONTIMAGES, cint]
    fontImageIdx*: cint
    drawCallCount*: cint
    fillTriCount*: cint
    strokeTriCount*: cint
    textTriCount*: cint
  
  AllocatorI = object

proc nvgCreate*(edgeaa: cint; viewId: cuchar; allocator: ptr AllocatorI = nil): ptr NVGcontext {.importc: "nvgCreate", dynlib: libname.}

when isMainModule:
  if not bgfx_init(BGFX_RENDERER_TYPE_COUNT, 0'u16, 0, nil, nil):
    echo("Error initializng BGFX.")
  echo repr nvgCreate(1, 0.cuchar)