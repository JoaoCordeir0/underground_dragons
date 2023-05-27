-- Classes
require('Classes.player')
require('Classes.menu')
require('Classes.colission')
require('Classes.timer')
require('Classes.table')
require('Classes.enemy')

-- Atalhos
local LK = love.keyboard
local LG = love.graphics
local LQ = love.graphics.newQuad
local LM = love.mouse

-- Variavel para o menu
local suit = require 'libraries/suit'
local backgroundMenu
local video
local backgroundOpcoes
local crosshair

-- Classe do Player, Mapa e Colisão
local playerClass = nil
local colissionClass = nil
local timerClass = nil
local menuClass = nil
local tableClass = nil
local enemyClass = nil

-- Variavel de controle do tempo do jogo
local showTimer = "0:00"

-- Variaveis para tratar colisão do mapa e personagem
local gameMapWoods
local gameMapCave
local gameMapCastle
local wf = require 'libraries/windfield'
local player = {}
local enemy = {}

-- Variaveis para tratar o mundo
local fase = -1 --[[Fase: 0 - Menu Inicial | 1 - Woods Map | 2 - Cave Map]]
local world
local espinho
local espinhos = {}
local wall
local walls = {}

-- Variaveis para tratar as bibliotecas
local camera = require 'libraries/camera'
local cam
local anim8 = require 'libraries/anim8'
local sti = require 'libraries/sti'

-- Variavel para setar chechpoint de troca de mapa
local woodsCheckPoint = {}
local caveCheckPoint = {}

-- Variavel para controlar arma
local playerGuns = {'hand'}

-- Variaveis do arco
local bow = {}

-- Variaveis da espada
local sword = {}

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

-- Configurações do jogo
local showFPS = false
local showCoordinates = false

-- Tabelas de posições dos inimigos
local fase1_enemys = {1585, 440, 2050, 505, 2800, 570}

function love.load()
    -- love.window.setFullscreen(true, "desktop")

    -- Fonte
    gameFont = LG.newFont('Insumos/Fonts/RetroMario-Regular.otf', 18)
    deadFont = LG.newFont('Insumos/Fonts/RetroMario-Regular.otf', 100)
    
    LG.setFont(gameFont)

    -- Mira do jogo
    crosshair = LM.newCursor("Insumos/Objeto/crosshair.png",0,0)

    -- Adiciona video de abertura
    video = LG.newVideo('Insumos/Videos/LogoPedregasAudio.ogv')
    video:play()

    -- Adiciona meu background no menu
    backgroundMenu = LG.newImage('Insumos/Menu/backgroundMenu.jpg')

    -- Adiciona meu meu background na opçoes
    backgroundOpcoes = LG.newImage('Insumos/Menu/ConfiguraçõesJogo.png')
    
    -- Adiciona minha biblioteca de colisão
    world = wf.newWorld(0, 9.81 * 4000, true)

    -- Instância da classe do Player
    playerClass = ClassePlayer.new(player)

    -- Instância da classe de colisão
    colissionClass = ClasseColission.new()
    
    -- Instância da classe de timer
    timerClass = ClasseTimer.new()

    -- Instância da classe do menu
    menuClass = ClasseMenu.new()

    -- Instância da classe de busca em tabelas ou mais conhecido como array
    tableClass = ClasseTable.new()

    -- Instância da classe de inimigos
    enemyClass = ClasseEnemy.new(enemy)

    -- Adiciona minha biblioteca de camera
    cam = camera()
    
    -- Teste se a Fase é 1 ou 2
    -- Assim criar a fase selecionada
    gameMapWoods = sti('maps/woods.lua')
    gameMapCave = sti('maps/cave.lua')
    gameMapCastle = sti('maps/castle.lua')
    
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
    
    -- Personagem com espada
    player.spriteSheetRunSword = {} -- Tabela de animacao do personagem andando com espada
    player.spriteSheetIdleSword = {} -- Tabela de animacao do personagem parado com espada
    player.spriteSheetJumpSword = {} -- Tabela de animacao do personagem pulando com espada
    player.spriteSheetAttackSword = {} -- Tabela de animacao do personagem atacando com espada
    
    -- Sprite atual/inicial sem arma
    player.currentSpriteRun = 1
    player.currentSpriteIdle = 1
    player.currentSpriteJump = 1
    player.currentSpriteDie = 1

    -- Sprite atual/inicial com arco
    player.currentSpriteRunBow = 1
    player.currentSpriteIdleBow = 1
    player.currentSpriteJumpBow = 1
    player.currentSpriteAttackBow = 1

    -- Sprite atual/inicial com espada
    player.currentSpriteRunSword = 1
    player.currentSpriteIdleSword = 1
    player.currentSpriteJumpSword = 1
    player.currentSpriteAttackSword = 1

    -- Sprite inimigo fase 1
    enemy.spriteSheetIdle = {} -- Tabela de animacao do personagem parado
    enemy.spriteSheetDie = {} -- Tabela de animacao do personagem morrendo    
    enemy.currentSpriteIdle = 1    
    enemy.currentSpriteDie = 1

    -- Informações da posição inicial do player
    player.life = 6
    player.arma = 'hand'
    player.x = 100
    player.y = 575
    player.speed = 400
    player.size = 130
    
    -- Informações iniciais dos disparos
    posShot.x = player.x
    posShot.y = player.y - 20
    
    -- Carrega minhas imagens do personagem
    playerClass.LoadPlayerImages()

    -- Carrega as imagens do inimigo
    enemyClass.LoadEnemyImages()
    
    -- Cria o mundo e o colisor do meu personagem
    player.collider = world:newBSGRectangleCollider(player.x, player.y, 100, 130, 10)
    player.collider:setFixedRotation(true)   
    
    -- Posição, tamanho do checkpoint de troca de mapa
    woodsCheckPoint.x = 3750
    woodsCheckPoint.y = 500
    woodsCheckPoint.size = 200

    caveCheckPoint.x = 3750
    caveCheckPoint.y = 500
    caveCheckPoint.size = 200
    
    -- Posição, tamanho e imagem do arco
    bow.x = 680
    bow.y = 500
    bow.img = LG.newImage('Insumos/Objeto/weapon_bow.png')
    bow.size = 100

    -- Posição, tamanho e imagem da espada
    sword.x = 1700
    sword.y = 100
    sword.img = LG.newImage('Insumos/Objeto/weapon_sword.png')
    sword.size = 100
    
    -- Carrega o Mapa
    RenderMap()    
end

function love.draw()   
    if fase == 1 or fase == 2 or fase == 3 then        
        -- Coloco o foco da camera no meu personagem
        cam:attach()                             
            if player.life == 1 then
                LG.setColor(255, 0, 0)     
            end            
            
            -- Caso a Fase for igual a 1 carrega os layers/camadas do meu mapa
            if fase == 1 then
                gameMapWoods:drawLayer(gameMapWoods.layers["Background3"])
                gameMapWoods:drawLayer(gameMapWoods.layers["Background2"])
                gameMapWoods:drawLayer(gameMapWoods.layers["Background1"])
                gameMapWoods:drawLayer(gameMapWoods.layers["Caverna"])
                gameMapWoods:drawLayer(gameMapWoods.layers["Camada de Blocos 1"])

                enemyClass.RenderEnemy(1, fase1_enemys)

            elseif fase == 2 then
                gameMapCave:drawLayer(gameMapCave.layers["Camada de Blocos 3"])
                gameMapCave:drawLayer(gameMapCave.layers["Camada de Blocos 2"])
                gameMapCave:drawLayer(gameMapCave.layers["Camada de Blocos 1"])
                gameMapCave:drawLayer(gameMapCave.layers["caverna"])
                gameMapCave:drawLayer(gameMapCave.layers["Camada de Blocos 5"])
            elseif fase == 3 then
                gameMapCastle:drawLayer(gameMapCastle.layers["Background1"])
                gameMapCastle:drawLayer(gameMapCastle.layers["Background3"])
                gameMapCastle:drawLayer(gameMapCastle.layers["Background2"])
                gameMapCastle:drawLayer(gameMapCastle.layers["Camada de Blocos 1"])
                gameMapCastle:drawLayer(gameMapCastle.layers["Camada de Blocos 5"])
            end
                
            -- Executa animação do personagem
            playerClass.RenderPlayer()
                
            if fase == 1 and player.arma == 'hand' and not tableClass.contains(playerGuns, 'bow') then
                LG.draw(bow.img, bow.x, bow.y)
            end     

            if fase == 2 and not tableClass.contains(playerGuns, 'sword') then
                LG.draw(sword.img, sword.x, sword.y)
            end
            
            for i, actual in pairs(shots) do        
                LG.draw(actual.img, actual.x, actual.y, actual.ang)
            end            
            
        cam:detach()    
       
        if player.life == 1 then                                                          
            LG.setFont(deadFont)                
            LG.setColor(255, 255, 255)                       
            LG.print('Morreu', (LG.getWidth() / 2) - 185, 300)                 
            LG.setFont(gameFont)        
            suit.draw() -- Renderiza o botão de reiniciar              
        end

        -- Timer do jogo
        LG.print("Tempo: " .. showTimer, LG.getWidth() - 100, 10)

        -- Renderiza a barra de vida do usuário
        LG.draw(player.spriteHealthBar[player.life], 5, 5)

        -- Renderiza a arma que está sendo usada
        playerClass.weaponInUse()

        if showFPS then
            LG.print("FPS: " .. tostring(love.timer.getFPS( )), LG.getWidth() - 70, LG.getHeight() - 20)
        end

        if showCoordinates then
            local mouseX, mouseY = love.mouse.getPosition()
            LG.print('Eixo x -> ' .. player.x, 10, 150)
            LG.print('Eixo y -> ' .. player.y, 10, 170)
            LG.print('Mouse x -> ' .. mouseX, 10, 190)
            LG.print('Mouse y -> ' .. mouseY, 10, 210)
        end

        love.mouse.setCursor(crosshair)

    elseif fase == 0 then
        LG.draw(backgroundMenu, (LG.getWidth() / 2) - 960 ,0)
        suit.draw()
    elseif fase == -1 then
        LG.draw(video, (LG.getWidth() / 2) - 960,0)
        
        if not video:isPlaying() then
            fase = 0
        end
    elseif fase == -2 then
        LG.draw(backgroundOpcoes, (LG.getWidth() / 2) - 720, 0)
    end
end

function love.update(dt)    
    if fase == 0 then
        -- Limpa as armas do player
        playerGuns = {'hand'}
        player.arma = 'hand'
        -- Retorna a fase atual e a fase 1 quando o jogar clicar em inicar história
        fase = menuClass.MenuButtons(suit)

        -- Destroi e constroi a fase 1 do jogo       
        player.collider = world:destroy()
        world = wf.newWorld(0, 9.81 * 4000, true)
        player.collider = world:newBSGRectangleCollider(150, 575, 100, 130, 10)
        player.collider:setFixedRotation(true)
        RenderMap()
    elseif fase > 0 and player.life == 1 then
        restartGame()
    elseif fase > 0 and player.life > 1 then
        -- Inicia o cronometro do jogo
        showTimer = timerClass.gameTimer()
        
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
            player.life = 1
        end

        -- Posição de saida dos tiros, no caso o personagem
        posShot.x = player.x
        posShot.y = player.y - 20     
        
        player.collider:setLinearVelocity(vx, vy)
        
        world:update(dt)
        player.x = player.collider:getX()
        player.y = player.collider:getY()   
        
        -- Percorre as imagens gerando a animação
        playerClass.RunThroughImagesPlayer(dt)
        enemyClass.RunThroughImagesEnemys(dt)
        
        -- Colidir com o arco e pega-lo
        if colissionClass.HaveColission(player, bow) and fase == 1 then
            player.arma = 'bow'
            table.insert(playerGuns, 'bow')                       
        end

        -- Colidir com a espada e pega-la
        if colissionClass.HaveColission(player, sword) and fase == 2 then
            player.arma = 'sword'
            table.insert(playerGuns, 'sword')
        end
        
        -- Testa colisão da troca de mapas / Fase 1 para Fase 2
        if colissionClass.HaveColission(player, woodsCheckPoint) and fase == 1 then
            fase = 2
            player.collider = world:destroy()
            world = wf.newWorld(0, 9.81 * 4000, true)
            player.collider = world:newBSGRectangleCollider(150, 575, 100, 130, 10)
            player.collider:setFixedRotation(true)
            RenderMap()
        elseif colissionClass.HaveColission(player, caveCheckPoint) and fase == 2 then
            fase = 3
            player.collider = world:destroy()
            world = wf.newWorld(0, 9.81 * 4000, true)
            player.collider = world:newBSGRectangleCollider(150, 300, 100, 130, 10)
            player.collider:setFixedRotation(true)
            player.y = 300
            player.collider:setY(player.y)
            RenderMap()
        end

        -- Controle de disparos
        controlShots(dt)
    end
end

function love.keypressed(k)
    if k == 'escape' or k == 'space' and fase == -1 then
        fase = 0
        LG.draw(backgroundMenu, 0 ,0)
        suit.draw()   
        if video:isPlaying() then
            video:pause()   
        end
    end
   
    if k == 'p' then
        if showFPS then
            showFPS = false
        else
            showFPS = true
        end
    end

    if k == 'x' and tableClass.contains(playerGuns, 'hand') then
        player.arma = 'hand'
        playerClass.RenderPlayer()
    elseif k == 'z' and tableClass.contains(playerGuns, 'bow') then
        player.arma = 'bow'
        playerClass.RenderPlayer()
    elseif k == 'c' and tableClass.contains(playerGuns, 'sword') then
        player.arma = 'sword'
        playerClass.RenderPlayer()         
    end
    
    if k == 'o' then
        if showCoordinates then
            showCoordinates = false
        else
            showCoordinates = true
        end
    end    
end

-- Função responsavel por renderizar o mapa
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
    elseif fase == 3 or fase == 0 then
        if gameMapCastle.layers['Chao'] then
            for i, obj in pairs(gameMapCastle.layers['Chao'].objects) do
                wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
                wall:setType('static')
                table.insert(walls, wall)
            end
        end
    end
end

function controlShots(dt)
    -- Temporizador dos disparos
    timeShot = timeShot - (1 * dt)
    if timeShot < 0 then
        shotTrue = true
    end
    -- Controlar o disparo com o mouse
    if love.mouse.isDown(1) and shotTrue and player.arma == 'bow' then
        -- Definir a posição do disparo (meio da caixa)
        local X = posShot.x + (posShot.larg / 2)
        local Y = posShot.y + (posShot.alt / 2)  
        
        -- Coletar a posição do alvo (mouse)
        local alvoX, alvoY = love.mouse.getPosition()

        if alvoX > 1200 then
            alvoX = (alvoX / 2) + player.x
        else
            alvoX = alvoX + (player.x / 2)
        end 
        
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

-- Função responsável por reiniciar o jogo quando o jogador morrer
function restartGame()    
    --suit.layout:reset(650, 500)    
    suit.layout:reset((LG.getWidth() / 2) - 100, 500) -- x / y    
    if suit.Button("Recomeçar", {id=3}, suit.layout:row(200,50)).hit then
        fase = 1
        playerGuns = {'hand'}
        player.life = 6
        player.x = 100
        player.y = 575
        player.arma = 'hand'
        haveBow = false
        haveSword = false
        player.collider = world:destroy()
        world = wf.newWorld(0, 9.81 * 4000, true)
        player.collider = world:newBSGRectangleCollider(150, 575, 100, 130, 10)
        player.collider:setFixedRotation(true)
        RenderMap()
    end
end