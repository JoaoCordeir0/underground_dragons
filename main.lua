-- Atalhos
local LK = love.keyboard
local LG = love.graphics
local LQ = love.graphics.newQuad
local LM = love.mouse

-- Variaveis para tratar colisão do mapa e personagem
local gameMap;
local wf;
local wall;
local walls = {}
local player = {}

-- Variaveis para tratar o mundo
local fase = 1
local world

-- Variaveis para tratar as bibliotecas
local camera
local cam
local anim8
local sti

-- Variavel para a animação
local currentSprite


function love.load()

    -- Adiciona minha biblioteca de colisão
    wf = require 'libraries/windfield'
    world = wf.newWorld(0, 9.81 * 4000, true)

    -- Adiciona minha biblioteca de camera
    camera = require 'libraries/camera'
    cam = camera()

    -- Adiciona minha bibliotca de animação
    anim8 = require 'libraries/anim8'

    -- Adiciona minha biblioteca de inserção de mapa
    sti = require 'libraries/sti'

    -- Teste se a Fase é 1 ou 2
    -- Assim criar a fase selecionada
    if fase == 1 then
        gameMap = sti('maps/woods.lua')
    else if fase == 2 then
            gameMap = sti('maps/cave.lua')
        end
    end

    -- Carrega o Personagem
    player.spriteSheetRun = {} -- Tabela de animacao do personagem andando
    player.spriteSheetIdle= {} -- Tabela de animacao do personagem parado
    player.spriteSheetJump = {} -- Tabela de animacao do personagem pulando
    player.x = 100
    player.y = 575
    player.speed = 400

    -- Aqui vou criar as tabelas das 3 animações diferentes
    table.insert(player.spriteSheetRun, love.graphics.newImage('Insumos/Player/run/player_run_00.png'))
    table.insert(player.spriteSheetRun, love.graphics.newImage('Insumos/Player/run/player_run_01.png'))
    table.insert(player.spriteSheetRun, love.graphics.newImage('Insumos/Player/run/player_run_02.png'))
    table.insert(player.spriteSheetRun, love.graphics.newImage('Insumos/Player/run/player_run_03.png'))
    table.insert(player.spriteSheetRun, love.graphics.newImage('Insumos/Player/run/player_run_04.png'))
    table.insert(player.spriteSheetRun, love.graphics.newImage('Insumos/Player/run/player_run_05.png'))
    table.insert(player.spriteSheetRun, love.graphics.newImage('Insumos/Player/run/player_run_06.png'))
    table.insert(player.spriteSheetRun, love.graphics.newImage('Insumos/Player/run/player_run_07.png'))
    table.insert(player.spriteSheetRun, love.graphics.newImage('Insumos/Player/run/player_run_08.png'))
    table.insert(player.spriteSheetRun, love.graphics.newImage('Insumos/Player/run/player_run_09.png'))

    table.insert(player.spriteSheetIdle, love.graphics.newImage('Insumos/Player/idle/player_idle_0.png'))
    table.insert(player.spriteSheetIdle, love.graphics.newImage('Insumos/Player/idle/player_idle_1.png'))
    table.insert(player.spriteSheetIdle, love.graphics.newImage('Insumos/Player/idle/player_idle_2.png'))
    table.insert(player.spriteSheetIdle, love.graphics.newImage('Insumos/Player/idle/player_idle_3.png'))
    table.insert(player.spriteSheetIdle, love.graphics.newImage('Insumos/Player/idle/player_idle_4.png'))
    table.insert(player.spriteSheetIdle, love.graphics.newImage('Insumos/Player/idle/player_idle_5.png'))
    table.insert(player.spriteSheetIdle, love.graphics.newImage('Insumos/Player/idle/player_idle_6.png'))
    table.insert(player.spriteSheetIdle, love.graphics.newImage('Insumos/Player/idle/player_idle_7.png'))

    table.insert(player.spriteSheetJump, love.graphics.newImage('Insumos/Player/jump/player_fall.png'))
    table.insert(player.spriteSheetJump, love.graphics.newImage('Insumos/Player/jump/player_rise.png'))
    -- Aqui vou criar as tabelas das 3 animações diferentes

    -- Cria o mundo e o colisor do meu personagem
    player.collider = world:newBSGRectangleCollider(200, 500, 100, 130, 10)
    player.collider:setFixedRotation(true)
    currentSprite = 1
    -- Carrega o Personagem

    CarregarMapa()
end

function love.draw()

    -- Coloco o foco da camera no meu personagem
    cam:attach()

        -- Caso a Fase for igual a 1 carrega os layers/camadas do meu mapa
        if fase == 1 then
            gameMap:drawLayer(gameMap.layers["Background3"])
            gameMap:drawLayer(gameMap.layers["Background2"])
            gameMap:drawLayer(gameMap.layers["Background1"])
            gameMap:drawLayer(gameMap.layers["Caverna"])
            gameMap:drawLayer(gameMap.layers["Camada de Blocos 1"])
        elseif fase == 2 then
            gameMap:drawLayer(gameMap.layers["Camada de Blocos 3"])
            gameMap:drawLayer(gameMap.layers["Camada de Blocos 2"])
            gameMap:drawLayer(gameMap.layers["Camada de Blocos 1"])
            gameMap:drawLayer(gameMap.layers["caverna"])
            gameMap:drawLayer(gameMap.layers["Camada de Blocos 5"])
        end

        -- Carrega graficamente o personagem
        LG.draw(
            player.spriteSheetIdle[math.floor(currentSprite)],
            player.x,
            player.y,
            0,
            1,
            1,
            player.spriteSheetIdle[1]:getWidth() / 2,
            player.spriteSheetIdle[1]:getHeight() / 2
        )

        -- Executa animação do personagem
        AnimacaoPersonagem()
    cam:detach()
end

function love.update(dt)

    -- Velocidade do colisor X e Y
    local vx = 0
    local vy = 0

    -- Controles basicos
    if LK.isDown('right') or LK.isDown('d') then
        vx = player.speed
    elseif LK.isDown('left') or LK.isDown('a')  then
        vx = player.speed * -1
    end
        
    if LK.isDown('up') or LK.isDown('w') then
        vy = player.speed * -5
    end

    -- Foca a camera no personagem passando o X e Y dele
    cam:lookAt(player.x, player.y -200)

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

    player.collider:setLinearVelocity(vx, vy)

    world:update(dt)
    player.x = player.collider:getX()
    player.y = player.collider:getY()

    -- Animação personagem
    currentSprite = currentSprite + 10 * dt
    if currentSprite > 5 then
        currentSprite = 1
    end
end

function love.keypressed(k)
    if k == '1' then
        fase = 1
    elseif k == '2' then
        fase = 2
    end
end

function CarregarMapa()
    -- Função que carrega as colisões do mapa
    if gameMap.layers['Chao'] then
        for i, obj in pairs(gameMap.layers['Chao'].objects) do
            wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            wall:setType('static')
            table.insert(walls, wall)
        end
    end
end

function AnimacaoPersonagem()

    -- Executa a animação do personagem
    if LK.isDown('right') or LK.isDown('d') then
        LG.draw(
            player.spriteSheetRun[math.floor(currentSprite)],
            player.x,
            player.y,
            0,
            1,
            1,
            player.spriteSheetRun[1]:getWidth() / 2,
            player.spriteSheetRun[1]:getHeight() / 2
        )
    end
end