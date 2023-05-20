-- Atalhos
local LK = love.keyboard
local LG = love.graphics
local LQ = love.graphics.newQuad

-- Variaveis para tratar colisão do mapa e personagem
local gameMap;
local wf;
local wall;
local walls = {}
local player = {}

function  love.load()

    -- Adiciona minha biblioteca de colisão
    wf = require 'libraries/windfield'
    world = wf.newWorld(0, 9.81 * 2000, true)

    -- Adiciona minha biblioteca de camera
    camera = require 'libraries/camera'
    cam = camera()

    -- Adiciona minha biblioteca de inserção de mapa
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

    cam:attach()
        gameMap:drawLayer(gameMap.layers["Background3"])
        gameMap:drawLayer(gameMap.layers["Background2"])
        gameMap:drawLayer(gameMap.layers["Background1"])
        gameMap:drawLayer(gameMap.layers["Caverna"])
        gameMap:drawLayer(gameMap.layers["Camada de Blocos 1"])

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
    cam:detach()

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
        vy = player.speed * -5
    end

    cam:lookAt(player.x, player.y - 200)

    local w = LG.getWidth()
    local h = LG.getHeight()
   
    -- Esconde fundo preto Left
    if cam.x < w/2 then
        cam.x = w/2
    end

    -- Esconde fundo preto (Top)
    if cam.y < h/2 then
        cam.y = h/2
    end

    --[[local mapW = gameMap.width * gameMap.tilewidth
    local mapH = gameMap.height * gameMap.tileheight

    Esconde fundo preto (Right)
    if cam.x < (mapW - w/2) then
        cam.x = (mapW - w/2)
    end

    Esconde fundo preto (Bottom)
    if cam.y < (mapH/2) then
        cam.y = (mapH/2)
    end]]

   
    player.collider:setLinearVelocity(vx, vy)

    world:update(dt)
    player.x = player.collider:getX()
    player.y = player.collider:getY()
end

