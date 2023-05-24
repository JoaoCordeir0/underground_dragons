-- Atalhos
local LK = love.keyboard
local LG = love.graphics
local LQ = love.graphics.newQuad
local LM = love.mouse

-- Variavel para o menu
local suit = require 'libraries/suit'
local backgroundMenu

-- Variavel de controle do tempo do jogo
local showTimer = "0:00"

-- Variaveis para tratar colisão do mapa e personagem
local gameMapWoods
local gameMapCave
local wf = require 'libraries/windfield'
local wall
local walls = {}
local player = {}

local espinho
local espinhos = {}

-- Variaveis para controlar a barra de vida
local playerLife = 5

-- Variaveis para tratar o mundo
local fase = 0 --[[Fase:
                   0 - Menu Inicial
                   1 - Woods Map
                   2 - Cave Map]]
local world

-- Variaveis para tratar as bibliotecas
local camera = require 'libraries/camera'
local cam
local anim8 = require 'libraries/anim8'
local sti = require 'libraries/sti'

-- Variavel para a animação
local currentSpriteRun
local currentSpriteIdle
local currentSpriteJump
local currentSpriteDie

local currentSpriteRunBow
local currentSpriteIdleBow
local currentSpriteJumpBow
local currentSpriteAttackBow

-- Variavel para setar chechpoint de troca de mapa
local woodsCheckPoint = {}

-- Variavel para controlar arma
local arco = {}
local arma = 'hand'

-- Variaveis para controle de disparos
local veloc = 500
local posShot = {x = 0, y = 0, larg = 50, alt = 50}
local shots = {}

-- Timers para limitação de tiros
local shotTrue = true
local activateMax = 1.5
local timeShot = activateMax

-- Fontes do jogo
local gameFont
local deadFont

function love.load()
    -- Fonte
    gameFont = LG.newFont('Insumos/Fonts/RetroMario-Regular.otf', 18)
    deadFont = LG.newFont('Insumos/Fonts/RetroMario-Regular.otf', 100)
    
    LG.setFont(gameFont)

    -- Adiciona meu background no menu
    backgroundMenu = LG.newImage('Insumos/Menu/backgroundMenu.jpg')
    
    -- Adiciona minha biblioteca de colisão
    world = wf.newWorld(0, 9.81 * 4000, true)
    
    -- Adiciona minha biblioteca de camera
    cam = camera()
    
    -- Teste se a Fase é 1 ou 2
    -- Assim criar a fase selecionada
    gameMapWoods = sti('maps/woods.lua')
    gameMapCave = sti('maps/cave.lua')
    
    -- Carrega o Personagem
    -- Vida do personagem
    player.spriteHealthBar = {}
    -- Personagem sem arma
    player.spriteSheetRun = {} -- Tabela de animacao do personagem andando
    player.spriteSheetIdle = {} -- Tabela de animacao do personagem parado
    player.spriteSheetJump = {} -- Tabela de animacao do personagem pulando
    player.spriteSheetDie = {} -- Tabela de animacao do personagem morrendo
    -- Personagem com arco
    player.spriteSheetRunBow = {} -- Tabela de animacao do personagem andando com arco
    player.spriteSheetIdleBow = {} -- Tabela de animacao do personagem parado com arco
    player.spriteSheetJumpBow = {} -- Tabela de animacao do personagem pulando com arco
    player.spriteSheetAttackBow = {} -- Tabela de animacao do personagem atirando com arco
    
    -- Informações da posição inicial do player
    player.x = 100
    player.y = 575
    player.speed = 400
    player.size = 130
    
    -- Informações iniciais dos disparos
    posShot.x = player.x
    posShot.y = player.y - 20
    
    -- Carrea minhas imagens do personagem
    LoadPlayerImages()
    
    -- Cria o mundo e o colisor do meu personagem
    player.collider = world:newBSGRectangleCollider(player.x, player.y, 100, 130, 10)
    player.collider:setFixedRotation(true)
    -- Sprite atual/inicial sem arma
    currentSpriteRun = 1
    currentSpriteIdle = 1
    currentSpriteJump = 1
    currentSpriteDie = 1
    -- Sprite atual/inicial com arco
    currentSpriteRunBow = 1
    currentSpriteIdleBow = 1
    currentSpriteJumpBow = 1
    currentSpriteAttackBow = 1
    
    -- Posição, tamanho do checkpoint de troca de mapa
    woodsCheckPoint.x = 3750
    woodsCheckPoint.y = 500
    woodsCheckPoint.size = 200
    
    -- Posição, tamanho e imagem do arco
    arco.x = 1530
    arco.y = 350
    arco.img = LG.newImage('Insumos/Objeto/weapon_bow.png')
    arco.size = 100
    
    -- Carrega o Mapa
    RenderMap()    
end

function love.draw()

    if fase == 1 or fase == 2 then        
        -- Coloco o foco da camera no meu personagem
        cam:attach()            
            if playerLife == 1 then
                LG.setColor(255, 0, 0)     
            end            
            
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
                
            if fase == 1 and arma == 'hand' then
                LG.draw(arco.img, arco.x, arco.y)
            end     
            
            for i, actual in pairs(shots) do        
                LG.draw(actual.img, actual.x, actual.y)
            end            
            
        cam:detach()    
       
        if playerLife == 1 then                                                          
            LG.setFont(deadFont)                
            LG.setColor(255, 255, 255)     
            LG.print('Morreu', (player.x - deadFont:getWidth('Morreu')) - 150, (LG.getHeight() - deadFont:getHeight('Morreu')) / 2)                 
            LG.setFont(gameFont)        
            suit.draw() -- Renderiza o botão de reiniciar              
        end

        -- Timer do jogo
        LG.print(showTimer, 1450, 10)

        -- Renderiza a barra de vida do usuário
        LG.draw(player.spriteHealthBar[playerLife], 5, 5)
        -- Renderiza a arma que está sendo usada
        weaponInUse()

        LG.print('X -> ' .. player.x, 10, 200)
        LG.print('Y -> ' .. player.y, 10, 220)

    end if fase == 0 then
        LG.draw(backgroundMenu, 0 ,0)
        suit.draw()
    end

end

function love.update(dt)    
    if fase == 0 then
        MenuButtons()    
    elseif fase > 0 and playerLife == 1 then
        restartGame()        
    elseif fase > 0 and playerLife > 1 then
        -- Inicia o cronometro do jogo
        gameTimer()
        
        -- Velocidade do colisor X e Y
        local vx = 0
        local vy = 0
        
        -- Controles basicos
        if LK.isDown('right') or LK.isDown('d') then
            vx = player.speed
        elseif LK.isDown('left') or LK.isDown('a') then
            vx = player.speed * -1
        end
        
        if LK.isDown('up') or LK.isDown('w') then
            vy = player.speed * -5
        end
    
        cam:lookAt(player.x, player.y - 200)
        
        local w = LG.getWidth()
        local h = LG.getHeight()
        
        -- Esconde fundo preto Left
        if cam.x < w / 2 then
            cam.x = w / 2
        end
        
        -- Esconde fundo preto (Top)
        if cam.y < h / 2 then
            cam.y = h / 2
        end
        
        -- Identifica queda nos espinhos
        if player.y > 610 then
            playerLife = 1
        end

        -- Posição de saida dos tiros, no caso o personagem
        posShot.x = player.x
        posShot.y = player.y - 20     
        
        player.collider:setLinearVelocity(vx, vy)
        
        world:update(dt)
        player.x = player.collider:getX()
        player.y = player.collider:getY()   
        
        -- Percorre as imagens gerando a animação
        RunThroughImages(dt)
        
        -- Colidir com arco e pegar arco
        if HaveColission(player, arco) then
            arma = 'arco'
        end
        
        -- Testa colisão da troca de mapas / Fase 1 para Fase 2
        if HaveColission(player, woodsCheckPoint) then
            fase = 2
            player.collider = world:destroy()
            world = wf.newWorld(0, 9.81 * 4000, true)
            player.collider = world:newBSGRectangleCollider(150, 575, 100, 130, 10)
            player.collider:setFixedRotation(true)
            RenderMap()
        end
        
        -- Controle de disparos
        controlShots(dt)
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
    end
    
    if k == 'x' then
        arma = 'hand'
        RenderPlayer()
    elseif k == 'z' then
        arma = 'arco'
        RenderPlayer()
    end
    
    if k == '0' then
        if playerLife > 1 then
            playerLife = playerLife - 1
        else
            playerLife = 5
        end
    end    
end

-- Renderizando o mapa
function RenderMap()
    -- Função que carrega as colisões do mapa
    if fase == 1 or fase == 0 then
        if gameMapWoods.layers['Chao'] then
            for i, obj in pairs(gameMapWoods.layers['Chao'].objects) do
                wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
                wall:setType('static')
                table.insert(walls, wall)
            end
        end

        if gameMapWoods.layers['Espinhos'] then
            for i, obj in pairs(gameMapWoods.layers['Espinhos'].objects) do
                espinho = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
                espinho:setType('static')
                table.insert(espinhos, espinho)
            end
        end
    elseif fase == 2 or fase == 0 then
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
    if playerLife == 1 then
        LG.draw(
            player.spriteSheetDie[math.floor(currentSpriteDie)],
            player.x,
            player.y,
            0,
            1,
            1,
            player.spriteSheetDie[1]:getWidth() / 2,
            player.spriteSheetDie[1]:getHeight() / 2
        )
    else 
        if arma == 'hand' then
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
                if not LK.isDown('up') and not LK.isDown('w') then
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
        elseif arma == 'arco' then
            if not LK.isDown('right') and
               not LK.isDown('d') and
               not LK.isDown('left') and
               not LK.isDown('a') and
               not LK.isDown('up') and
               not LK.isDown('w') and
               not LM.isDown(1) then
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
                if not LK.isDown('up') and not LK.isDown('w') and not LM.isDown(1) then
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
    
            if LM.isDown(1) then
                LG.draw(
                    player.spriteSheetAttackBow[math.floor(currentSpriteAttackBow)],
                    player.x,
                    player.y,
                    0,
                    1,
                    1,
                    player.spriteSheetAttackBow[1]:getWidth() / 2,
                    player.spriteSheetAttackBow[1]:getHeight() / 2
                )
            end
        end 
    end  
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

    -- Animação de Atacar com Arco
    table.insert(player.spriteSheetAttackBow, LG.newImage('Insumos/PlayerBow/attack/player_bow_attack_00.png'))
    table.insert(player.spriteSheetAttackBow, LG.newImage('Insumos/PlayerBow/attack/player_bow_attack_01.png'))
    table.insert(player.spriteSheetAttackBow, LG.newImage('Insumos/PlayerBow/attack/player_bow_attack_02.png'))
    table.insert(player.spriteSheetAttackBow, LG.newImage('Insumos/PlayerBow/attack/player_bow_attack_03.png'))
    table.insert(player.spriteSheetAttackBow, LG.newImage('Insumos/PlayerBow/attack/player_bow_attack_04.png'))
    table.insert(player.spriteSheetAttackBow, LG.newImage('Insumos/PlayerBow/attack/player_bow_attack_05.png'))
    table.insert(player.spriteSheetAttackBow, LG.newImage('Insumos/PlayerBow/attack/player_bow_attack_06.png'))
    table.insert(player.spriteSheetAttackBow, LG.newImage('Insumos/PlayerBow/attack/player_bow_attack_07.png'))
    table.insert(player.spriteSheetAttackBow, LG.newImage('Insumos/PlayerBow/attack/player_bow_attack_08.png'))
    table.insert(player.spriteSheetAttackBow, LG.newImage('Insumos/PlayerBow/attack/player_bow_attack_09.png'))
    table.insert(player.spriteSheetAttackBow, LG.newImage('Insumos/PlayerBow/attack/player_bow_attack_10.png'))
    table.insert(player.spriteSheetAttackBow, LG.newImage('Insumos/PlayerBow/attack/player_bow_attack_11.png'))
    table.insert(player.spriteSheetAttackBow, LG.newImage('Insumos/PlayerBow/attack/player_bow_attack_12.png'))
    table.insert(player.spriteSheetAttackBow, LG.newImage('Insumos/PlayerBow/attack/player_bow_attack_13.png'))
    table.insert(player.spriteSheetAttackBow, LG.newImage('Insumos/PlayerBow/attack/player_bow_attack_14.png'))
    
    -- Barra de vida do personagem
    table.insert(player.spriteHealthBar, LG.newImage('Insumos/Player/healthbar/healthBar1.png'))
    table.insert(player.spriteHealthBar, LG.newImage('Insumos/Player/healthbar/healthBar2.png'))
    table.insert(player.spriteHealthBar, LG.newImage('Insumos/Player/healthbar/healthBar3.png'))
    table.insert(player.spriteHealthBar, LG.newImage('Insumos/Player/healthbar/healthBar4.png'))
    table.insert(player.spriteHealthBar, LG.newImage('Insumos/Player/healthbar/healthBar5.png'))

    -- Animação de Morte
    table.insert(player.spriteSheetDie, LG.newImage('Insumos/Player/die/player_die_00.png'))
    table.insert(player.spriteSheetDie, LG.newImage('Insumos/Player/die/player_die_01.png'))
    table.insert(player.spriteSheetDie, LG.newImage('Insumos/Player/die/player_die_02.png'))
    table.insert(player.spriteSheetDie, LG.newImage('Insumos/Player/die/player_die_03.png'))
    table.insert(player.spriteSheetDie, LG.newImage('Insumos/Player/die/player_die_04.png'))
    table.insert(player.spriteSheetDie, LG.newImage('Insumos/Player/die/player_die_05.png'))
    table.insert(player.spriteSheetDie, LG.newImage('Insumos/Player/die/player_die_06.png'))
    table.insert(player.spriteSheetDie, LG.newImage('Insumos/Player/die/player_die_07.png'))
    table.insert(player.spriteSheetDie, LG.newImage('Insumos/Player/die/player_die_08.png'))
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

    -- Animação de Morte
    currentSpriteDie = currentSpriteDie + 10 * dt
    if currentSpriteDie >= 9 then
        currentSpriteDie = 9
    end
    
    -- Animações com arco
    -- Animação Corrida com arco
    currentSpriteRunBow = currentSpriteRunBow + 10 * dt
    if currentSpriteRunBow >= 10 then
        currentSpriteRunBow = 1
    end
    
    -- Animação Parado com arco
    currentSpriteIdleBow = currentSpriteIdleBow + 10 * dt
    if currentSpriteIdleBow >= 8 then
        currentSpriteIdleBow = 1
    end
    
    -- Animação Pulo com arco
    currentSpriteJumpBow = currentSpriteJumpBow + 10 * dt
    if currentSpriteJumpBow >= 2 then
        currentSpriteJumpBow = 1
    end

    -- Animação Ataque com arco
    currentSpriteAttackBow = currentSpriteAttackBow + 10 * dt
    if currentSpriteAttackBow >= 15 then
        currentSpriteAttackBow = 1
    end
end

function HaveColission(player, item)
    -- Calcular a distância centro a centro(Pitagoras)
    local distancia = math.sqrt((player.x - item.x) ^ 2 + (player.y - item.y) ^ 2)
    
    -- Verificar a colisão
    return distancia < (player.size + item.size) / 2
end

function weaponInUse()
    if arma == 'arco' then
        return LG.draw(LG.newImage('Insumos/Objeto/weapon_bow.png'), 300, 5)
    end
end

function gameTimer()
    -- Definido para 5 minutos
    local finish = false
    local time = math.ceil(love.timer.getTime())
    
    if time < 60 then
        seconds = time
    elseif time >= 60 and time < 120 then
        seconds = time - 60
    elseif time >= 120 and time < 180 then
        seconds = time - 120
    elseif time >= 180 and time < 240 then
        seconds = time - 180
    elseif time >= 240 and time < 300 then
        seconds = time - 240
    elseif time >= 300 then
        finish = true
    end
    
    if not finish then
        showTimer = math.ceil(time / 60) - 1 .. ":" .. (seconds < 10 and 0 .. seconds or seconds)
    else
        showTimer = "Tempo esgotado"
    end
end

function controlShots(dt)

    -- Temporizador dos disparos
    timeShot = timeShot - (1 * dt)
    if timeShot < 0 then
        shotTrue = true
    end
    -- Controlar o disparo com o mouse
    if love.mouse.isDown(1) and shotTrue and arma == 'arco' then
        -- Definir a posição do disparo (meio da caixa)
        local X = posShot.x + (posShot.larg / 2)
        local Y = posShot.y + (posShot.alt / 2)  
        
        -- Coletar a posição do alvo (mouse)
        local alvoX, alvoY = love.mouse.getPosition()
        
        -- Alvo do tiro
        local angle = math.atan2((alvoY - Y), (alvoX - X))
        
        -- Criar o novo disparo e incluir na tabela
        newShot = {x = X, y = Y, ang = angle, img = LG.newImage('Insumos/Objeto/arrow.png')}
        table.insert(shots, newShot)

        shotTrue = false

        timeShot = activateMax
    end
        
    -- Animação dos disparos
    for i, actual in pairs(shots) do
        -- Física: Dx = deslocamento na direção X, Dy = deslocamento na direção Y
        local Dx = veloc * math.cos(actual.ang)
        local Dy = veloc * math.sin(actual.ang)
        actual.x = actual.x + (Dx * dt)
        actual.y = actual.y + (Dy * dt)
        
        -- Verificação para a limpeza de disparos que sairem da tela
        -- if actual.x > LG.getWidth() or actual.y > LG.getHeight() or actual.x < 0 or actual.y < 0 then
        --     table.remove(shots, i)
        -- end
    end
end

function MenuButtons()
    suit.layout:reset((LG.getWidth() / 2) - 250,(LG.getHeight() / 2) - 50)
    suit.layout:padding(10)
    suit.Label("Dragões do Submundo", (LG.getWidth() / 2) - 100,100, 200,30)
    
    if suit.Button("Iniciar História", {id=1}, suit.layout:row(500,50)).hit then
        fase = 1
    end
    
    if suit.Button("Sair", {id=2}, suit.layout:row()).hit then
        love.event.quit()
    end
end

function restartGame()
    suit.layout:reset((player.x - deadFont:getWidth('Morreu')) - 100, (LG.getHeight() - (deadFont:getHeight('Morreu') - 300)) / 2)    
    if suit.Button("Recomeçar", {id=3}, suit.layout:row(200,50)).hit then
        fase = 1
        playerLife = 5        
        player.x = 100 
        player.y = 575         
        player.collider = world:destroy()
        world = wf.newWorld(0, 9.81 * 4000, true)
        player.collider = world:newBSGRectangleCollider(150, 575, 100, 130, 10)
        player.collider:setFixedRotation(true)
        RenderMap()
    end
end
