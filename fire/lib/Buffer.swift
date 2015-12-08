import protocol MetalKit.MTLBuffer


// Safe wrapper for an array of floats.
// Ensures we don't stomp on memory past the end.
struct BufferWrapper {
    var pdata: UnsafeMutablePointer<Float>
    let plen: Int
    var pos: Int = 0

    init (_ buffer: MTLBuffer) {
        // NB: MTLBuffer.length == bytes
        let ptr = UnsafeMutablePointer<Float>(buffer.contents())
        self.init(buffer: ptr, nr_elements: buffer.length / sizeof(Float))
    }

    init (buffer: UnsafeMutablePointer<Float>, nr_elements: Int) {
        precondition(nr_elements > 0)
        pdata = buffer
        plen = nr_elements
    }

    func available() -> Int {
        return (plen - pos)
    }

    func has_available(len: Int) -> Bool {
        return self.available() >= len
    }

    // If capacity is full, do nothing
    mutating func append(v: Float) {
        guard has_available(1) else {
            return
        }
        append_raw(v)
    }

    mutating func append(v: Vector3) {
        append(v.x)
        append(v.y)
        append(v.z)
    }

    mutating func append(v: Color4) {
        append(v.r)
        append(v.g)
        append(v.b)
        append(v.a)
    }

    // No capacity checks; caller must check beforehand 
    mutating func append_raw(v: Float) {
        pdata[pos] = v
        pos = pos &+ 1
    }

    mutating func append_raw_color4(v: Color4) {
        append_raw(v.r)
        append_raw(v.g)
        append_raw(v.b)
        append_raw(v.a)
    }
}
