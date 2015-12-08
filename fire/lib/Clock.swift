import func Foundation.gettimeofday
import struct Foundation.timeval


// Microseconds since epoch
typealias TimeUS = Int64

private var g_clock_pause_time: TimeUS = 0
private var g_clock_timeshift: TimeUS = 0


// Return number of microseconds.
// Time can be paused and unpaused.
func get_current_timestamp() -> TimeUS {
    if g_clock_pause_time != 0 {
        return g_clock_pause_time
    } else {
        return _get_current_timestamp() - g_clock_timeshift
    }
}


// Raw system time.
// TODO: use a monotonic time source instead
private func _get_current_timestamp() -> TimeUS {
    var time = timeval(tv_sec: 0, tv_usec: 0)
    gettimeofday(&time, nil)
    let curtime = TimeUS(time.tv_sec) * 1000000 + TimeUS(time.tv_usec)
    return curtime
}


// Pause/unpause time
func clock_toggle_pause() {
    if g_clock_pause_time == 0 {
        // Freeze current time
        g_clock_pause_time = get_current_timestamp()
    } else {
        // Unpause.  Set timeshift to systime - current paused time,
        // so time continues where it left off.
        g_clock_timeshift = _get_current_timestamp() - g_clock_pause_time
        g_clock_pause_time = 0
    }
}


// If not already paused, pause.
// Else, advance pause time by @usecs
func clock_step_pause(usecs: Int) {
    if (g_clock_pause_time == 0) {
        clock_toggle_pause()
    } else {
        g_clock_pause_time += usecs
    }
}
