def tick args
  # Black background
  args.outputs.solids << {
    x: 0,
    y: 0,
    w: args.grid.w,
    h: args.grid.h,
    r: 0,
    g: 0,
    b: 0,
  }
  args.state.terrain ||= [
      { x: 640,          y: 360,          w: 32, h: 32, path: 'sprites/square/blue.png' },
      { x: 640,          y: 360 - 32,     w: 32, h: 32, path: 'sprites/square/blue.png' },
      { x: 640,          y: 360 - 32 * 2, w: 32, h: 32, path: 'sprites/square/blue.png' },
      { x: 640 + 32,     y: 360 - 32 * 2, w: 32, h: 32, path: 'sprites/square/blue.png' },
      { x: 640 + 32 * 2, y: 360 - 32 * 2, w: 32, h: 32, path: 'sprites/square/blue.png' },
    ]

  args.state.player ||= { x: 576,
                          y: 200,
                          w: 80,
                          h: 80,
                          path: '/sprites/square/green.png' }

  args.outputs.labels  << { x: 640,
                            y: 600,
                            text: 'Score: ',
                            size_px: 30,
                            anchor_x: 0.5,
                            anchor_y: 0.5 }


  args.outputs.sprites << args.state.player

  args.outputs.sprites << args.state.terrain



  if args.inputs.keyboard.left
    args.state.player.x -= 10
  elsif args.inputs.keyboard.right
    args.state.player.x += 10
  end

  if args.inputs.keyboard.down
    args.state.player.y -= 10
  elsif args.inputs.keyboard.up
    args.state.player.y += 10
  end

  if args.state.player.x > 1280
    args.state.player.x = 0
  elsif args.state.player.x < 0
    args.state.player.x = 1280
  end

  if args.state.player.y > 720
    args.state.player.y = 0
  elsif args.state.player.y < 0
    args.state.player.y = 720
  end
end

$gtk.reset