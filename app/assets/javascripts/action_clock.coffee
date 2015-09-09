$(document).ready ->
  padWithZero = (i) ->
    if i < 10
      i = '0' + i
    i

  actionTime = ->
    now = new Date
    ending = new Date
    h = now.getHours()
    m = now.getMinutes()
    if m < 25
      ending.setHours h
      ending.setMinutes 25
    else if m < 30
      ending.setHours h
      ending.setMinutes 30
    else if m < 55
      ending.setHours h
      ending.setMinutes 55
    else
      ending.setHours h + 1
      ending.setMinutes 0
    ending

  updateStatus = (m) ->
    current_action = document.getElementById('time').dataset.current_action
    if m < 3 && !current_action
      document.getElementById('time').classList.remove 'focus', 'review', 'relax'
      document.getElementById('time').classList.add 'commit'
      return 'commit'
    else if m < 23
      document.getElementById('time').classList.remove 'commit', 'review', 'relax'
      document.getElementById('time').classList.add 'focus'
      return 'focus'
    else if m < 25
      document.getElementById('time').classList.remove 'commit', 'focus', 'relax'
      document.getElementById('time').classList.add 'review'
      return 'review'
    else if m < 30
      document.getElementById('time').classList.remove 'commit', 'focus', 'review'
      document.getElementById('time').classList.add 'relax'
      return 'relax'
    else if m < 33 && !current_action
      document.getElementById('time').classList.remove 'focus', 'review', 'relax'
      document.getElementById('time').classList.add 'commit'
      return 'commit'
    else if m < 53
      document.getElementById('time').classList.remove 'commit', 'review', 'relax'
      document.getElementById('time').classList.add 'focus'
      return 'focus'
    else if m < 55
      document.getElementById('time').classList.remove 'commit', 'focus', 'relax'
      document.getElementById('time').classList.add 'review'
      return 'review'
    else
      document.getElementById('time').classList.remove 'commit', 'focus', 'review'
      document.getElementById('time').classList.add 'relax'
      return 'relax'

  playSounds = (status, m, s) ->
    tick_volume = document.getElementById('time').dataset.tick_volume
    warning_volume = document.getElementById('time').dataset.warning_volume

    commit = new Audio("/assets/commit.wav")
    tick = new Audio("/assets/tick.wav")
    warning = new Audio("/assets/warning.wav")
    bell = new Audio("/assets/bell.wav")
    whistle = new Audio("/assets/whistle.wav")

    tick.volume = commit.volume = tick_volume / 100
    warning.volume = bell.volume = whistle.volume = warning_volume / 100

    console.log 'Playing sounds with', status, m, s, tick_volume, warning_volume
    if s == 0 && m == 2 && status != 'relax'
      warning.play()
    else if s == 0 && m == 0 && status != 'relax'
      bell.play()
    else if s == 30 && m == 0 && status == 'relax'
      whistle.play()
    else if status == 'commit'
      commit.play()
    else if status != 'relax'
      tick.play()
    return

  startTime = ->
    now = new Date
    ending = actionTime()
    time_delta = ending - now
    m = now.getMinutes()
    status = updateStatus now.getMinutes()
    if ending.getMinutes() == 0
      m = 59 - m
    else
      m = ending.getMinutes() - m - 1
    s = 60 - now.getSeconds() - 1
    playSounds(status, m, s)
    m = padWithZero(m)
    s = padWithZero(s)
    document.getElementById('time').innerHTML = m + ':' + s
    t = setTimeout((->
      startTime()
      return
    ), 1000)

  startTime()