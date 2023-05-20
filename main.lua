-- Atalhos
local LK = love.keyboard
local LG = love.graphics
local LQ = love.graphics.newQuad

local gameMap;
local wf;
local wall;

local walls = {}
local player = {}

function  love.load()
    wf = require 'libraries/windfield'
    world = wf.newWorld(0, 9.81 * 2000, true)

    local sti = require 'libraries/sti'
    gameMap = sti('maps/woods.lua')

    player.x = 100
    player.y = 575
    player.speed = 400
    player.spriteSheet = LG.newImage('Insumos/Player/idle/player_idle_0.png')
    player.collider = world:newBSGRectangleCollider(200, 500, 100, 130, 10)
    player.collider:setFixedRotation(true)

    if gameMap.layers['Chao'] then
        for i, obj in pairs(gameMap.layers['Chao'].objects) do
            wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            wall:setType('static')
            table.insert(walls, wall)
        end
    end
end

function  love.draw()
    gameMap:draw()

    LG.draw(
        player.spriteSheet,
        player.x,
        player.y,
        0,
        1,
        1,
        player.spriteSheet:getWidth() / 2,
        player.spriteSheet:getHeight() / 2
    )

    -- Visualizar area de contato
    --world:draw()
end

function love.update(dt)

    -- Velocidade do colisor X e Y
    local vx = 0
    local vy = 0
      
    if LK.isDown('right') or LK.isDown('d') then
        vx = player.speed
    end

    if LK.isDown('left') or LK.isDown('a') then
        vx = player.speed * -1
    end

    if LK.isDown('up') or LK.isDown('w') then
        if player.y > 500 then
            vy = player.speed * -5
        end
    end

    player.collider:setLinearVelocity(vx, vy)

    world:update(dt)
    player.x = player.collider:getX()
    player.y = player.collider:getY() 
end

