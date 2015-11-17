import Foundation

private let PI = 3.1415926535
private let RANDOM_RANGE_DEBUG = false


// Return number of microseconds
func get_current_timestamp() -> Int64 {
    var time:timeval = timeval(tv_sec: 0, tv_usec: 0)
    gettimeofday(&time, nil)
    let curtime = Int64(time.tv_sec) * 1000000 + Int64(time.tv_usec)
    return curtime
}



// Return number in range [0, 1]
func random_float() -> Float {
    let ret = Float(random()) / Float(Int32.max)
    precondition(ret >= 0)
    precondition(ret <= 1)
    return ret
}


// Return number in range [lower, upper]
func random_range(lower: Float, _ upper: Float) -> Float {
    precondition(lower <= upper)
    if RANDOM_RANGE_DEBUG { return random_choose(lower, upper); }
    let rand = random_float()
    let delta = upper - lower
    let ret = (rand * delta) + lower
    precondition(ret >= lower)
    precondition(ret <= upper)
    return ret
}


// Return number in range [lower, upper]
func random_range(lower: Int, _ upper: Int) -> Int {
    precondition(lower <= upper)
    if RANDOM_RANGE_DEBUG { return random_choose(lower, upper); }
    let delta = upper - lower
    let ret = (Int(random()) % (delta + 1)) + lower
    precondition(ret >= lower)
    precondition(ret <= upper)
    return ret
}


// Return either a or b
func random_choose<T>(a: T, _ b: T) -> T {
    let r = random() % 2
    if r == 0 {
        return a
    } else {
        return b
    }
}


struct Vector3 {
    var x: Float
    var y: Float
    var z: Float

    func length() -> Float {
        return sqrt((x * x) + (y * y) + (z * z)) 
    }
}

struct Color4 {
    var r: Float
    var g: Float
    var b: Float
    var a: Float
}

struct Float4 {
    init (_ a: Float, _ b: Float, _ c: Float, _ d: Float) { 
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    var a: Float
    var b: Float
    var c: Float
    var d: Float
}

// The length of these vectors are 1
func RandomUniformUnitVector() -> Vector3 {
    let angle = random_range(0.0, Float(2.0 * PI))
    let r = sqrt(random_range(0.0, 1.0))
    let hemisphere = Float(1.0) // random_choose(-1.0, 1.0)
    let z = sqrt(1.0 - r*r) * hemisphere
    return Vector3(x: r * cos(angle), y: r * sin(angle), z: z)
}


func RandomUniformUnitVector2D() -> Vector3 {
    let angle = random_range(0.0, Float(2.0 * PI))
    return Vector3(x: cos(angle), y: sin(angle), z: 0)
}


/*
//print(random(0.4))
let v = RandomUniformUnitVector2D()
print(v)
print(v.length())
*/
