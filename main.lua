WINDOW_WIDTH = 1084
WINDOW_HEIGHT = 610

function love.load() -- setup function
    -- set window settings
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT,{
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    -- fonts
    gameFont = love.graphics.newFont(40)

    -- sprites
    sprites = {}
    sprites.sky = love.graphics.newImage('sprites/sky.png')
    sprites.target = love.graphics.newImage('sprites/target.png')
    sprites.crosshairs = love.graphics.newImage('sprites/crosshairs.png')

    -- hide mouse
    love.mouse.setVisible(false)

    -- variables
    target = {}
    target.radius = 50
    target.x = WINDOW_WIDTH / 2
    target.y = WINDOW_HEIGHT / 2
    game_state = 1
    score = 0
    timer = 0
end

function love.update(dt) -- game loop (called each frame)
    -- counts down
    if timer > 0 then
        timer = timer - dt
    end

    -- sets game state to paused state if timer ends
    if timer < 0 then
        timer = 0
        game_state = 1
    end
end

function love.draw() -- draws to the screen (called each frame)
    -- to draw no matter the game state
    love.graphics.draw(sprites.sky, 0, 0)

    -- text
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(gameFont)
    love.graphics.print(score, 30, 10)
    love.graphics.print(math.ceil(timer), WINDOW_WIDTH - 60, 10)
    
    -- menue text
    if game_state == 1 then
        love.graphics.printf('Click To Start', 0, 250, WINDOW_WIDTH, 'center')
    end

    -- draws target if in game
    if game_state == 2 then
        -- sprites
        love.graphics.draw(sprites.target, target.x - target.radius, target.y - target.radius)
    end

    -- draw no matter but keep here so appears over target
    love.graphics.draw(sprites.crosshairs, love.mouse.getX() - 20, love.mouse.getY() - 20)
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == i and game_state == 2 then -- if left mouse press and in game
        local mouse_to_target = distanceBetween(x, y, target.x, target.y)
        if mouse_to_target < target.radius then
            score = score + 1
            target.x = math.random(target.radius, WINDOW_WIDTH - target.radius)
            target.y = math.random(target.radius, WINDOW_HEIGHT - target.radius)
        end
    elseif button == 2 and game_state == 1 then -- if right mouse button and out of game
        game_state = 2
        timer = 10
        score = 0
    end
end

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end