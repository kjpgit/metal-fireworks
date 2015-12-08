import func Foundation.srandom

print("starting test")
let BUF_SIZE = 10000000
let BUF_ELEMENTS = BUF_SIZE / sizeof(Float)
let reps = 30000
let scene = FireworkScene()

srandom(0)

var arr_v = UnsafeMutablePointer<Float>.alloc(BUF_ELEMENTS)
var arr_c = UnsafeMutablePointer<Float>.alloc(BUF_ELEMENTS)

for _ in 0..<reps {
    var bv = BufferWrapper(buffer: arr_v, nr_elements: BUF_ELEMENTS)
    var bc = BufferWrapper(buffer: arr_c, nr_elements: BUF_ELEMENTS)
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
