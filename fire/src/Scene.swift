protocol Drawable {
    func draw(time: TimeUS, 
        inout bv: BufferWrapper, 
        inout bc: BufferWrapper)
}


class FireworkScene {
    private var m_fireworks = [Drawable]()
    private var next_launch: TimeUS
    private var next_stats: TimeUS = 0
    private var stats_max_bv: Int = 0
    private var stats_max_bc: Int = 0
    private var x_aspect_ratio: Float = 0

    init() {
        // Launch the first firework immediately
        next_launch = get_current_timestamp()
        arm_stats()
    }
    
    func set_screen_size(width width: Float, height: Float) {
        print("screen size change: \(width) x \(height)")
        let v = height / width
        x_aspect_ratio = v
    }

    private func arm_stats() {
        // Print buffer stats every second
        self.next_stats = get_current_timestamp() + 1000000
        self.stats_max_bv = 0
        self.stats_max_bc = 0
    }

    private func launch_firework(current_time: TimeUS) {
        let fw = Firework(time: current_time, aspect_x: x_aspect_ratio)
        m_fireworks.append(fw)
        while m_fireworks.count > 10 {
            m_fireworks.removeAtIndex(0)
        }
    }

    func update(inout bv bv: BufferWrapper, inout bc: BufferWrapper) {
        let curtime = get_current_timestamp()

        if curtime > next_launch {
            launch_firework(curtime)
            next_launch = curtime + TimeUS(random_range(100000, 700000))
        }

        for fw in m_fireworks {
            fw.draw(curtime, bv: &bv, bc: &bc)
        }

        if bv.pos > self.stats_max_bv {
            self.stats_max_bv = bv.pos
        }
        if bc.pos > self.stats_max_bc {
            self.stats_max_bc = bc.pos
        }
        if self.next_stats < curtime {
            print("stats: bv \(self.stats_max_bv)")
            print("stats: bc \(self.stats_max_bc)")
            self.arm_stats()
        }
    }
}
