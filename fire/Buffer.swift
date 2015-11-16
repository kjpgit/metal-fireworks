import MetalKit


struct BufferWrapper {
    var pdata: UnsafeMutablePointer<Float>
    let plen: Int
    var pos: Int

    init (_ buffer: MTLBuffer) {
        let ptr = UnsafeMutablePointer<Float>(buffer.contents())
        self.init(buffer: ptr, len: buffer.length)
    }

    init (buffer: UnsafeMutablePointer<Float>, len: Int) {
        precondition(len > 0)
        pdata = buffer
        plen = len
        pos = 0
    }

    mutating func append(v: Float) {
        //precondition(pos < plen)
        if (pos >= plen) {
            return
        }
        pdata[pos] = v
        pos++
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
}

