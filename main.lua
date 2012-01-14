require 'bad'
require 'ship'
require 'bullet'

joystick = {
    n = 0,
    axes = {
        lr = 0,
        ud = 1
    },
    sensitivity = 500,
    threshold = 0.25
}

debug = {}
bullets = {}
baddies = {}

function love.load(arg)
    love.joystick.open(joystick.n)
    ship = Ship:new(400, 300, joystick)
    add_bad()
end

function add_bad()
    table.insert(baddies, Bad:new{})
end

function love.joystickpressed(j, b)
    fire_everything = true
end

function love.joystickreleased(j, b)
    fire_everything = false
end

function update_bullets(dt)
    local trash = {}

    for i, v in ipairs(bullets) do
        v:update(dt)

        if v:is_offscreen() then
            table.insert(trash, i, 1)
        end
    end

    for i, v in ipairs(trash) do
        table.remove(bullets, v)
    end
end

function update_fire_state(dt)
    if fire_everything then
        table.insert(bullets, Bullet:new(ship.x, ship.y))
    end
end

function love.update(dt)
    update_fire_state(dt)

    for i, things in ipairs({{ship}, bullets, baddies}) do
        for i, t in ipairs(things) do
            t:update(dt)
        end
    end
end

function love.keypressed(k)
    if k == 'escape' or k == 'q' then
        love.event.push('q')
    end
end


function love.draw()
    for i, things in ipairs({{ship}, bullets, baddies}) do
        for i, t in ipairs(things) do
            t:draw()
        end
    end

    -- DEBUG
    for i = 1, #debug do
        love.graphics.print("Line " .. i .. ": " .. debug[i], 50, 50 + (i * 10))
    end
end
