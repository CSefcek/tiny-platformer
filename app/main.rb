def tick args
  defaults args
  input args
  calc args
  render args
end

def defaults args
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
      { x: 640 - 32 * 2, y: 360 - 32 * 2, w: 32, h: 32, path: 'sprites/square/blue.png' },
      { x: 640 - 32,     y: 360 - 32 * 2, w: 32, h: 32, path: 'sprites/square/blue.png' },
      { x: 640,          y: 360 - 32 * 2, w: 32, h: 32, path: 'sprites/square/blue.png' },
      { x: 640 + 32,     y: 360 - 32 * 2, w: 32, h: 32, path: 'sprites/square/blue.png' },
      { x: 640 + 32 * 2, y: 360 - 32 * 2, w: 32, h: 32, path: 'sprites/square/blue.png' },
    ]

  args.state.player ||= { x: 640 - 32 *2,
                          y: 360,
                          w: 32,
                          h: 32,
                          dx: 0,
                          dy: 0,
                          on_ground: false,
                          path: '/sprites/square/green.png',
                          flip_horizontally: false }

  args.state.jump ||= {
      speed: 10
    }

  args.state.gravity ||= -1

  args.outputs.labels  << { x: 640,
                            y: 600,
                            text: 'Score: ',
                            size_px: 30,
                            anchor_x: 0.5,
                            anchor_y: 0.5,
                            r: 102,
                            g: 255,
                            b: 227, }
end
  

def render args
  # rendering player and terrain
  args.outputs.sprites << args.state.player
  args.outputs.sprites << args.state.terrain
end

def input args
  if args.inputs.keyboard.key_down.space && args.state.player.on_ground
    args.state.player.dy = args.state.jump.speed
    args.state.player.on_ground = false
  end
end

def calc args
  args.state.player.dy += args.state.gravity

  # set dx and dy based on inputs
  args.state.player.dx = args.inputs.left_right * 4
  #args.state.player.dy = args.inputs.up_down * 4

  # check for collisions on the x and y axis independently

  # increment player's position by dx
  args.state.player.x += args.state.player.dx

  # flip character sprite based on dx
  if args.state.player.dx < 0
    args.state.player.flip_horizontally = true
  elsif args.state.player.dx > 0
    args.state.player.flip_horizontally = false
  end
  
  # check for collisions on the x axis first
  collision = args.state.terrain.find { |t| t.intersect_rect? args.state.player }

  # if there is a collision, move the player to the edge of the collision
  # based on the direction of the player's movement and set the player's
  # dx to 0
  if collision
    if args.state.player.dx > 0
      args.state.player.x = collision.x - args.state.player.w
    elsif args.state.player.dx < 0
      args.state.player.x = collision.x + collision.w
    end
    args.state.player.dx = 0
  end

  #increment player's position by dy
  args.state.player.y += args.state.player.dy

  # check for collisions on the y axis
  collision = args.state.terrain.find { |t| t.intersect_rect? args.state.player }

  # if there is a collision, move the player to the edge of the collision
  # based on the direction of the player's movement and set the player's
  # dy to 0
  if collision
    if args.state.player.dy > 0
      # moving up: hit head on underside of block
      args.state.player.y = collision.y - args.state.player.h
      args.state.player.on_ground = false
    elsif args.state.player.dy < 0
      # moving down: land on top of block
      args.state.player.y = collision.y + collision.h
      args.state.player.on_ground = true
    end
    args.state.player.dy = 0
  end
end

  


$gtk.reset