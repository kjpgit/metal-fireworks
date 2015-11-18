import Cocoa

print("starting test")
let BUF_SIZE = 10000000
let reps = 30000
let scene = FireworkScene()

srandom(0)

var arr_v = UnsafeMutablePointer<Float>.alloc(BUF_SIZE / sizeof(Float))
var arr_c = UnsafeMutablePointer<Float>.alloc(BUF_SIZE / sizeof(Float))

for _ in 0..<reps {
    var bv = BufferWrapper(buffer: arr_v, bytelen: BUF_SIZE)
    var bc = BufferWrapper(buffer: arr_c, bytelen: BUF_SIZE)
    scene.update(bv: &bv, bc: &bc)
}

/*
var bv = BufferWrapper(buffer: arr_v, len: BUF_SIZE)
var pos = Vector3(x: 1, y: 2, z: 3)
for _ in 0..<reps {
    for i in 0..<10000 {
        draw_triangle_2d(&bv, pos, 1.0)
    }
    bv.pos = 0
}
*/

print("ending test")
