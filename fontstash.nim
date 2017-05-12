const
  FONS_INVALID* = - 1
  FONS_HASH_LUT_SIZE = 256
  FONS_MAX_FALLBACKS = 20
  FONS_VERTEX_COUNT = 1024
  FONS_MAX_STATES = 20

type
  Face = object

  FONSttFontImpl* = object
    font*: Face
    
  FONSflags* = enum
    FONS_ZERO_TOPLEFT = 1, FONS_ZERO_BOTTOMLEFT = 2

  FONSalign* = enum             ##  Horizontal align
    FONS_ALIGN_LEFT = 1 shl 0,    ##  Default
    FONS_ALIGN_CENTER = 1 shl 1, FONS_ALIGN_RIGHT = 1 shl 2, ##  Vertical align
    FONS_ALIGN_TOP = 1 shl 3, FONS_ALIGN_MIDDLE = 1 shl 4, FONS_ALIGN_BOTTOM = 1 shl 5, FONS_ALIGN_BASELINE = 1 shl
        6                     ##  Default

  FONSerrorCode* = enum         ##  Font atlas is full.
    FONS_ATLAS_FULL = 1,        ##  Scratch memory used to render glyphs is full, requested size reported in 'val', you may need to bump up FONS_SCRATCH_BUF_SIZE.
    FONS_SCRATCH_FULL = 2,      ##  Calls to fonsPushState has created too large stack, if you need deep state stack bump up FONS_MAX_STATES.
    FONS_STATES_OVERFLOW = 3,   ##  Trying to pop too many states fonsPopState().
    FONS_STATES_UNDERFLOW = 4

  FONSparams* = object
    width*: cint
    height*: cint
    flags*: cuchar
    userPtr*: pointer
    renderCreate*: proc (uptr: pointer; width: cint; height: cint): cint
    renderResize*: proc (uptr: pointer; width: cint; height: cint): cint
    renderUpdate*: proc (uptr: pointer; rect: ptr cint; data: ptr cuchar)
    renderDraw*: proc (uptr: pointer; verts: ptr cfloat; tcoords: ptr cfloat;
                     colors: ptr cuint; nverts: cint)
    renderDelete*: proc (uptr: pointer)

  FONSquad* = object
    x0*: cfloat
    y0*: cfloat
    s0*: cfloat
    t0*: cfloat
    x1*: cfloat
    y1*: cfloat
    s1*: cfloat
    t1*: cfloat

  
  FONSglyph* = object
    codepoint*: cuint
    index*: cint
    next*: cint
    size*: cshort
    blur*: cshort
    x0*: cshort
    y0*: cshort
    x1*: cshort
    y1*: cshort
    xadv*: cshort
    xoff*: cshort
    yoff*: cshort

  FONSfont* = object
    font*: FONSttFontImpl
    name*: array[64, char]
    data*: ptr cuchar
    dataSize*: cint
    freeData*: cuchar
    ascender*: cfloat
    descender*: cfloat
    lineh*: cfloat
    glyphs*: ptr FONSglyph
    cglyphs*: cint
    nglyphs*: cint
    lut*: array[FONS_HASH_LUT_SIZE, cint]
    fallbacks*: array[FONS_MAX_FALLBACKS, cint]
    nfallbacks*: cint

  FONSstate* = object
    font*: cint
    align*: cint
    size*: cfloat
    color*: cuint
    blur*: cfloat
    spacing*: cfloat

  FONSatlasNode* = object
    x*: cshort
    y*: cshort
    width*: cshort

  FONSatlas* = object
    width*: cint
    height*: cint
    nodes*: ptr FONSatlasNode
    nnodes*: cint
    cnodes*: cint

  FONScontext* = object
    params*: FONSparams
    itw*: cfloat
    ith*: cfloat
    texData*: ptr cuchar
    dirtyRect*: array[4, cint]
    fonts*: ptr ptr FONSfont
    atlas*: ptr FONSatlas
    cfonts*: cint
    nfonts*: cint
    verts*: array[FONS_VERTEX_COUNT * 2, cfloat]
    tcoords*: array[FONS_VERTEX_COUNT * 2, cfloat]
    colors*: array[FONS_VERTEX_COUNT, cuint]
    nverts*: cint
    scratch*: ptr cuchar
    nscratch*: cint
    states*: array[FONS_MAX_STATES, FONSstate]
    nstates*: cint
    handleError*: proc (uptr: pointer; error: cint; val: cint)
    errorUptr*: pointer

  FONStextIter* = object
    x*: cfloat
    y*: cfloat
    nextx*: cfloat
    nexty*: cfloat
    scale*: cfloat
    spacing*: cfloat
    codepoint*: cuint
    isize*: cshort
    iblur*: cshort
    font*: ptr FONSfont
    prevGlyphIndex*: cint
    str*: cstring
    next*: cstring
    `end`*: cstring
    utf8state*: cuint