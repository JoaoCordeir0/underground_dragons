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
local currentSpriteRun
local currentSpriteIdle
local currentSpriteJump


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
    end
    if fase == 2 then
        gameMap = sti('maps/cave.lua')
    end    

    -- Carrega o Personagem
    player.spriteSheetRun = {} -- Tabela de animacao do personagem andando
    player.spriteSheetIdle = {} -- Tabela de animacao do personagem parado
    player.spriteSheetJump = {} -- Tabela de animacao do personagem pulando
    player.x = 100
    player.y = 575
    player.speed = 400

    -- Aqui vou criar as tabelas das 3 animações diferentes
    -- Animação de Correr
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
    -- Animação de ficar Parado
    table.insert(player.spriteSheetIdle, love.graphics.newImage('Insumos/Player/idle/player_idle_0.png'))
    table.insert(player.spriteSheetIdle, love.graphics.newImage('Insumos/Player/idle/player_idle_1.png'))
    table.insert(player.spriteSheetIdle, love.graphics.newImage('Insumos/Player/idle/player_idle_2.png'))
    table.insert(player.spriteSheetIdle, love.graphics.newImage('Insumos/Player/idle/player_idle_3.png'))
    table.insert(player.spriteSheetIdle, love.graphics.newImage('Insumos/Player/idle/player_idle_4.png'))
    table.insert(player.spriteSheetIdle, love.graphics.newImage('Insumos/Player/idle/player_idle_5.png'))
    table.insert(player.spriteSheetIdle, love.graphics.newImage('Insumos/Player/idle/player_idle_6.png'))
    table.insert(player.spriteSheetIdle, love.graphics.newImage('Insumos/Player/idle/player_idle_7.png'))
    -- Animação de Pular
    table.insert(player.spriteSheetJump, love.graphics.newImage('Insumos/Player/jump/player_fall.png'))
    table.insert(player.spriteSheetJump, love.graphics.newImage('Insumos/Player/jump/player_rise.png'))
    -- Aqui vou criar as tabelas das 3 animações diferentes

    -- Cria o mundo e o colisor do meu personagem
    player.collider = world:newBSGRectangleCollider(200, 500, 100, 130, 10)
    player.collider:setFixedRotation(true)
    currentSpriteRun = 1
    currentSpriteIdle = 1
    currentSpriteJump = 1
    -- Carrega o Personagem

    RenderMap()
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

        -- Executa animação do personagem
        RenderPlayer()

        -- Fiz o teste de morrer, não fiz o teste de colisão
        -- no espinho, até pq o espinho ta sem colisão
        -- mas resumindo se o Y do player for maior que 577 
        -- ele morre, é só um teste e uma ideia inicial de morte
        love.graphics.print(player.y, 700, 300)
        
        if player.y > 577 then
            love.graphics.setNewFont(20)
            love.graphics.print("Morreu" , 700, 400)        
        end
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

    --[[if LK.isDown('up') or LK.isDown('w') then
        player.collider:applyLinearImpulse(0,-1000)
    end]]

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
    -- Animação Corrida
    currentSpriteRun = currentSpriteRun + 10 * dt
    if currentSpriteRun >= 10 then
        currentSpriteRun = 1
    end

    -- Animação Parado
    currentSpriteIdle = currentSpriteIdle + 10 * dt
    if currentSpriteIdle >= 8 then
        currentSpriteIdle = 1
    end

    -- Animação Pulo
    currentSpriteJump = currentSpriteJump + 10 * dt
    if currentSpriteJump >= 2 then
        currentSpriteJump = 1
    end
end

function love.keypressed(k)
    if k == '1' then
        fase = 1
    elseif k == '2' then
        fase = 2
    end
end

function RenderMap()
    -- Função que carrega as colisões do mapa
    if gameMap.layers['Chao'] then
        for i, obj in pairs(gameMap.layers['Chao'].objects) do
            wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            wall:setType('static')
            table.insert(walls, wall)
        end
    end
end

-- Executa animações do personagem 
function RenderPlayer()         
    -- Animação de parado  
    if not LK.isDown('right') and 
       not LK.isDown('d') and 
       not LK.isDown('left') and 
       not LK.isDown('a') and 
       not LK.isDown('up') and 
       not LK.isDown('w') and 
       not LK.isDown('s') then  
        LG.draw(
            player.spriteSheetIdle[math.floor(currentSpriteIdle)],
            player.x,
            player.y,
            0,
            1,
            1,
            player.spriteSheetIdle[1]:getWidth() / 2,
            player.spriteSheetIdle[1]:getHeight() / 2
        )
    end 

    -- Animação de correr
    if LK.isDown('right') or LK.isDown('d') or LK.isDown('left') or LK.isDown('a') then
        LG.draw(
            player.spriteSheetRun[math.floor(currentSpriteRun)],
            player.x,
            player.y,
            0,
            1,
            1,
            player.spriteSheetRun[1]:getWidth() / 2,
            player.spriteSheetRun[1]:getHeight() / 2
        )
    end

    -- Animação de Pular
    if LK.isDown('up') or LK.isDown('w') then
        LG.draw(
            player.spriteSheetJump[math.floor(currentSpriteJump)],
            player.x,
            player.y,
            0,
            1,
            1,
            player.spriteSheetJump[1]:getWidth() / 2,
            player.spriteSheetJump[1]:getHeight() / 2
        )
    end
end