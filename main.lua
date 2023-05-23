-- Atalhos
local LK = love.keyboard
local LG = love.graphics
local LQ = love.graphics.newQuad
local LM = love.mouse

-- Variaveis para tratar colisão do mapa e personagem
local gameMapWoods
local gameMapCave
local wf
local wall
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

local currentSpriteRunBow
local currentSpriteIdleBow
local currentSpriteJumpBow
local currentSpriteAttackBow

-- Variavel para controlar arma
local arco = {}

local arma = 'x'

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
    gameMapWoods = sti('maps/woods.lua')    
    gameMapCave = sti('maps/cave.lua')     
    
    -- Carrega o Personagem
    -- Personagem sem arma
    player.spriteSheetRun = {} -- Tabela de animacao do personagem andando
    player.spriteSheetIdle = {} -- Tabela de animacao do personagem parado
    player.spriteSheetJump = {} -- Tabela de animacao do personagem pulando
    -- Personagem com arco
    player.spriteSheetRunBow = {} -- Tabela de animacao do personagem andando com arco
    player.spriteSheetIdleBow = {} -- Tabela de animacao do personagem parado com arco
    player.spriteSheetJumpBow = {} -- Tabela de animacao do personagem pulando com arco

    player.x = 100
    player.y = 575
    player.speed = 400
    player.size = 130

    -- Carrea minhas imagens do personagem
    LoadPlayerImages()

    -- Cria o mundo e o colisor do meu personagem
    player.collider = world:newBSGRectangleCollider(player.x, player.y, 100, 130, 10)
    player.collider:setFixedRotation(true)
    -- Sprite atual/inicial sem arma
    currentSpriteRun = 1
    currentSpriteIdle = 1
    currentSpriteJump = 1
    -- Sprite atual/inicial com arco
    currentSpriteRunBow = 1
    currentSpriteIdleBow = 1
    currentSpriteJumpBow = 1

    arco.x = 600
    arco.y = 500
    arco.img = LG.newImage('Insumos/Objeto/weapon_bow.png')
    arco.size = 100
                
    -- Carrega o Mapa
    RenderMap()
end

function love.draw()

    -- Coloco o foco da camera no meu personagem
    cam:attach()

        -- Caso a Fase for igual a 1 carrega os layers/camadas do meu mapa
        if fase == 1 then
            gameMapWoods:drawLayer(gameMapWoods.layers["Background3"])
            gameMapWoods:drawLayer(gameMapWoods.layers["Background2"])
            gameMapWoods:drawLayer(gameMapWoods.layers["Background1"])
            gameMapWoods:drawLayer(gameMapWoods.layers["Caverna"])
            gameMapWoods:drawLayer(gameMapWoods.layers["Camada de Blocos 1"])
        elseif fase == 2 then           
            gameMapCave:drawLayer(gameMapCave.layers["Camada de Blocos 3"])
            gameMapCave:drawLayer(gameMapCave.layers["Camada de Blocos 2"])
            gameMapCave:drawLayer(gameMapCave.layers["Camada de Blocos 1"])
            gameMapCave:drawLayer(gameMapCave.layers["caverna"])
            gameMapCave:drawLayer(gameMapCave.layers["Camada de Blocos 5"])
        end

        -- Executa animação do personagem
        RenderPlayer()

        LG.draw(arco.img, arco.x, arco.y)
    cam:detach()

     -- Fiz o teste de morrer, não fiz o teste de colisão
    -- no espinho, até pq o espinho ta sem colisão
    -- mas resumindo se o Y do player for maior que 577 
    -- ele morre, é só um teste e uma ideia inicial de morte
    love.graphics.print(player.y, 700, 300)
    
    if player.y > 577 then
        love.graphics.setNewFont(20)
        love.graphics.print("Morreu" , 700, 400)        
    end

    love.graphics.print("Vida: 3", 10, 10);
    if arma == 'z' then
        love.graphics.print("Item: Arco", 100, 10);
    else
        love.graphics.print("Item: ", 100, 10);
    end

    
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

    -- Percorre as imagens gerando a animação
    RunThroughImages(dt)
    -- Colidir com arco e pegar arco
    if HaveColission(player, arco) then
       arma = 'z'
       
    end
end

function love.keypressed(k)
    if k == '1' then
        -- Fase a ser exibida
        fase = 1
        -- Aqui vou limpar o antigo mundo criado
        -- E cria-lo novamente
        player.collider = world:destroy()
        world = wf.newWorld(0, 9.81 * 4000, true)
        player.collider = world:newBSGRectangleCollider(150, 575, 100, 130, 10)
        player.collider:setFixedRotation(true)
        RenderMap()        
    elseif k == '2' then
        fase = 2
        player.collider = world:destroy()
        world = wf.newWorld(0, 9.81 * 4000, true)
        player.collider = world:newBSGRectangleCollider(150, 575, 100, 130, 10)
        player.collider:setFixedRotation(true)
        RenderMap()
    end

    if k == 'x' then
        arma = 'x'
        RenderPlayer()
    elseif k == 'z' then
        arma = 'z'
        RenderPlayer()
    end
end

-- Renderizando o mapa
function RenderMap()
    -- Função que carrega as colisões do mapa
    if fase == 1 then  
        if gameMapWoods.layers['Chao'] then
            for i, obj in pairs(gameMapWoods.layers['Chao'].objects) do
                wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
                wall:setType('static')
                table.insert(walls, wall)
            end
        end
    elseif fase == 2 then
        if gameMapCave.layers['Chao'] then
            for i, obj in pairs(gameMapCave.layers['Chao'].objects) do
                wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
                wall:setType('static')
                table.insert(walls, wall)
            end
        end
    end
end

-- Renderiza e executa animações do personagem 
function RenderPlayer()

    if arma == 'x' then
        if not LK.isDown('right') and 
           not LK.isDown('d') and 
           not LK.isDown('left') and 
           not LK.isDown('a') and 
           not LK.isDown('up') and 
           not LK.isDown('w') then  
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
    elseif arma == 'z' then
        if not LK.isDown('right') and
           not LK.isDown('d') and
           not LK.isDown('left') and
           not LK.isDown('a') and
           not LK.isDown('up') and
           not LK.isDown('w') then
            LG.draw(
                player.spriteSheetIdleBow[math.floor(currentSpriteIdleBow)],
                player.x,
                player.y,
                0,
                1,
                1,
                player.spriteSheetIdleBow[1]:getWidth() / 2,
                player.spriteSheetIdleBow[1]:getHeight() / 2
            )
        end

        -- Animação de correr
        if LK.isDown('right') or LK.isDown('d') or LK.isDown('left') or LK.isDown('a') then
            LG.draw(
                player.spriteSheetRunBow[math.floor(currentSpriteRunBow)],
                player.x,
                player.y,
                0,
                1,
                1,
                player.spriteSheetRunBow[1]:getWidth() / 2,
                player.spriteSheetRunBow[1]:getHeight() / 2
            )
        end

        -- Animação de Pular
        if LK.isDown('up') or LK.isDown('w') then
            LG.draw(
                player.spriteSheetJumpBow[math.floor(currentSpriteJumpBow)],
                player.x,
                player.y,
                0,
                1,
                1,
                player.spriteSheetJumpBow[1]:getWidth() / 2,
                player.spriteSheetJumpBow[1]:getHeight() / 2
            )
        end
    
    end
    -- Animação de parado  
    
end

function LoadPlayerImages()

    -- Aqui vou criar as tabelas das animações diferentes
    -- Animação de Correr
    table.insert(player.spriteSheetRun, LG.newImage('Insumos/Player/run/player_run_00.png'))
    table.insert(player.spriteSheetRun, LG.newImage('Insumos/Player/run/player_run_01.png'))
    table.insert(player.spriteSheetRun, LG.newImage('Insumos/Player/run/player_run_02.png'))
    table.insert(player.spriteSheetRun, LG.newImage('Insumos/Player/run/player_run_03.png'))
    table.insert(player.spriteSheetRun, LG.newImage('Insumos/Player/run/player_run_04.png'))
    table.insert(player.spriteSheetRun, LG.newImage('Insumos/Player/run/player_run_05.png'))
    table.insert(player.spriteSheetRun, LG.newImage('Insumos/Player/run/player_run_06.png'))
    table.insert(player.spriteSheetRun, LG.newImage('Insumos/Player/run/player_run_07.png'))
    table.insert(player.spriteSheetRun, LG.newImage('Insumos/Player/run/player_run_08.png'))
    table.insert(player.spriteSheetRun, LG.newImage('Insumos/Player/run/player_run_09.png'))

    -- Animação de ficar Parado
    table.insert(player.spriteSheetIdle, LG.newImage('Insumos/Player/idle/player_idle_0.png'))
    table.insert(player.spriteSheetIdle, LG.newImage('Insumos/Player/idle/player_idle_1.png'))
    table.insert(player.spriteSheetIdle, LG.newImage('Insumos/Player/idle/player_idle_2.png'))
    table.insert(player.spriteSheetIdle, LG.newImage('Insumos/Player/idle/player_idle_3.png'))
    table.insert(player.spriteSheetIdle, LG.newImage('Insumos/Player/idle/player_idle_4.png'))
    table.insert(player.spriteSheetIdle, LG.newImage('Insumos/Player/idle/player_idle_5.png'))
    table.insert(player.spriteSheetIdle, LG.newImage('Insumos/Player/idle/player_idle_6.png'))
    table.insert(player.spriteSheetIdle, LG.newImage('Insumos/Player/idle/player_idle_7.png'))

    -- Animação de Pular
    table.insert(player.spriteSheetJump, LG.newImage('Insumos/Player/jump/player_fall.png'))
    table.insert(player.spriteSheetJump, LG.newImage('Insumos/Player/jump/player_rise.png'))

    -- Animação de Correr com Arco
    table.insert(player.spriteSheetRunBow, LG.newImage('Insumos/PlayerBow/run/player_bow_run_00.png'))
    table.insert(player.spriteSheetRunBow, LG.newImage('Insumos/PlayerBow/run/player_bow_run_01.png'))
    table.insert(player.spriteSheetRunBow, LG.newImage('Insumos/PlayerBow/run/player_bow_run_02.png'))
    table.insert(player.spriteSheetRunBow, LG.newImage('Insumos/PlayerBow/run/player_bow_run_03.png'))
    table.insert(player.spriteSheetRunBow, LG.newImage('Insumos/PlayerBow/run/player_bow_run_04.png'))
    table.insert(player.spriteSheetRunBow, LG.newImage('Insumos/PlayerBow/run/player_bow_run_05.png'))
    table.insert(player.spriteSheetRunBow, LG.newImage('Insumos/PlayerBow/run/player_bow_run_06.png'))
    table.insert(player.spriteSheetRunBow, LG.newImage('Insumos/PlayerBow/run/player_bow_run_07.png'))
    table.insert(player.spriteSheetRunBow, LG.newImage('Insumos/PlayerBow/run/player_bow_run_08.png'))
    table.insert(player.spriteSheetRunBow, LG.newImage('Insumos/PlayerBow/run/player_bow_run_09.png'))

    -- Animação de ficar Parado com Arco
    table.insert(player.spriteSheetIdleBow, LG.newImage('Insumos/PlayerBow/idle/player_bow_idle_0.png'))
    table.insert(player.spriteSheetIdleBow, LG.newImage('Insumos/PlayerBow/idle/player_bow_idle_1.png'))
    table.insert(player.spriteSheetIdleBow, LG.newImage('Insumos/PlayerBow/idle/player_bow_idle_2.png'))
    table.insert(player.spriteSheetIdleBow, LG.newImage('Insumos/PlayerBow/idle/player_bow_idle_3.png'))
    table.insert(player.spriteSheetIdleBow, LG.newImage('Insumos/PlayerBow/idle/player_bow_idle_4.png'))
    table.insert(player.spriteSheetIdleBow, LG.newImage('Insumos/PlayerBow/idle/player_bow_idle_5.png'))
    table.insert(player.spriteSheetIdleBow, LG.newImage('Insumos/PlayerBow/idle/player_bow_idle_6.png'))
    table.insert(player.spriteSheetIdleBow, LG.newImage('Insumos/PlayerBow/idle/player_bow_idle_7.png'))

    -- Animação de Pular com Arco
    table.insert(player.spriteSheetJumpBow, LG.newImage('Insumos/PlayerBow/jump/player_bow_fall.png'))
    table.insert(player.spriteSheetJumpBow, LG.newImage('Insumos/PlayerBow/jump/player_bow_rise.png'))
end

function RunThroughImages(dt)
    -- Animação personagem

    -- Animações sem armas
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

    -- Animações com arco
    -- Animação Corrida com arco
    currentSpriteRunBow = currentSpriteRunBow + 10 * dt
    if currentSpriteRunBow >= 10 then
        currentSpriteRunBow = 1
    end

    -- Animação Parado com arco
    if currentSpriteIdleBow >= 8 then
        currentSpriteIdleBow = 1
    end

    -- Animação Pulo com arco
    if currentSpriteJumpBow >= 2 then
        currentSpriteJumpBow = 1
    end
end

function HaveColission(player, arco)
    -- Calcular a distância centro a centro(Pitagoras)
    local distancia = math.sqrt((player.x - arco.x)^2 + (player.y - arco.y)^2)

    -- Verificar a colisão 
    return distancia < (player.size + arco.size) / 2
end