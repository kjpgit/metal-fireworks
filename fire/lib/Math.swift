import func Foundation.random
import func Foundation.sqrt
import func Foundation.sin
import func Foundation.cos


private let PI = 3.1415926535
private let RANDOM_RANGE_DEBUG = false


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


// Return Float in range [0, 1]
func random_float() -> Float {
    let ret = Float(random()) / Float(Int32.max)
    precondition(ret >= 0)
    precondition(ret <= 1)
    return ret
}


// Return Float in range [lower, upper]
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


// Return Int in range [lower, upper]
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


/*
Return random 3D vector.  Length will be == 1.
Source: gamedev.net
This finds a random point on a circle, than finds the height of the sphere
at that point.  It can use the top or bottom hemisphere for z.  
This gives better distribution than two random angles (which will produce
more points clustered at the poles)
*/
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
