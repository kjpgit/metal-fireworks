import Foundation

private var g_clock_pause_time: Int = 0
private var g_clock_timeshift: Int = 0


// Return number of microseconds
func get_current_timestamp() -> Int {
    if g_clock_pause_time != 0 {
        return g_clock_pause_time
    } else {
        return _get_current_timestamp() - g_clock_timeshift
    }
}


private func _get_current_timestamp() -> Int {
    var time:timeval = timeval(tv_sec: 0, tv_usec: 0)
    gettimeofday(&time, nil)
    let curtime = Int(time.tv_sec) * 1000000 + Int(time.tv_usec)
    return curtime
}


func clock_toggle_pause() {
    if g_clock_pause_time == 0 {
        g_clock_pause_time = get_current_timestamp()
    } else {
        g_clock_timeshift = _get_current_timestamp() - g_clock_pause_time
        g_clock_pause_time = 0
    }
}


func clock_step_pause(usecs: Int) {
    if (g_clock_pause_time == 0) {
        clock_toggle_pause()
        return
    }
    if g_clock_pause_time != 0 {
        g_clock_pause_time += usecs
    }
}

