import Cocoa

print("starting test")
let BUF_SIZE = 10000000
let reps = 3000
let scene = FireworkScene()

srandom(0)

var arr_v = UnsafeMutablePointer<Float>.alloc(BUF_SIZE)
var arr_c = UnsafeMutablePointer<Float>.alloc(BUF_SIZE)

for _ in 0..<reps {
    var bv = BufferWrapper(buffer: arr_v, len: BUF_SIZE)
    var bc = BufferWrapper(buffer: arr_c, len: BUF_SIZE)
    scene.update(bv: &bv, bc: &bc)
}
print("ending test")
