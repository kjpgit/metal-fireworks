import func Foundation.srandom

// Performance test.
// We step through frames, and output should be identical each time.

print("starting test")

srandom(0)
clock_toggle_pause()

let BUF_SIZE = 10000000
let BUF_ELEMENTS = BUF_SIZE / sizeof(Float)
let frame_usecs = 16667  // 1/60th of a second
let nr_frames = 30000
let scene = FireworkScene()

var arr_v = UnsafeMutablePointer<Float>.alloc(BUF_ELEMENTS)
var arr_c = UnsafeMutablePointer<Float>.alloc(BUF_ELEMENTS)

for _ in 0..<nr_frames {
    var bv = BufferWrapper(buffer: arr_v, nr_elements: BUF_ELEMENTS)
    var bc = BufferWrapper(buffer: arr_c, nr_elements: BUF_ELEMENTS)
    scene.update(bv: &bv, bc: &bc)
    clock_step_pause(frame_usecs)
}

print("ending test")
