-- Classes
require('Classes.player')
require('Classes.map')
require('Classes.colission')
require('Classes.timer')

-- Atalhos
local LK = love.keyboard
local LG = love.graphics
local LQ = love.graphics.newQuad
local LM = love.mouse

-- Variavel para o menu
local suit = require 'libraries/suit'
local backgroundMenu

-- Classe do Player, Mapa e Colisão
local playerClass = nil
local mapClass = nil
local colissionClass = nil
local timerClass = nil

-- Variavel de controle do tempo do jogo
local showTimer = "0:00"

-- Variaveis para tratar colisão do mapa e personagem
local gameMapWoods
local gameMapCave
local wf = require 'libraries/windfield'
local player = {}

-- Variaveis para tratar o mundo
local fase = 0 --[[Fase: 0 - Menu Inicial | 1 - Woods Map | 2 - Cave Map]]
local world

-- Variaveis para tratar as bibliotecas
local camera = require 'libraries/camera'
local cam
local anim8 = require 'libraries/anim8'
local sti = require 'libraries/sti'

-- Variavel para setar chechpoint de troca de mapa
local woodsCheckPoint = {}

-- Variavel para controlar arma
local arco = {}

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

    -- Instância da classe do Mapa
    mapClass = ClasseMap.new(world)

    -- Instância da classe do Player
    playerClass = ClassePlayer.new(player)

    -- Instância da classe de colisão
    colissionClass = ClasseColission.new()
    
    -- Instância da classe de timer
    timerClass = ClasseTimer.new()

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

    -- Informações da posição inicial do player
    player.life = 5
    player.arma = 'hand'
    player.x = 100
    player.y = 575
    player.speed = 400
    player.size = 130
    
    -- Informações iniciais dos disparos
    posShot.x = player.x
    posShot.y = player.y - 20
    
    -- Carrea minhas imagens do personagem
    playerClass.LoadPlayerImages()
    
    -- Cria o mundo e o colisor do meu personagem
    player.collider = world:newBSGRectangleCollider(player.x, player.y, 100, 130, 10)
    player.collider:setFixedRotation(true)   
    
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
    mapClass.RenderMap(fase, gameMapWoods, gameMapCave)    
end

function love.draw()

    if fase == 1 or fase == 2 then        
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
            elseif fase == 2 then
                gameMapCave:drawLayer(gameMapCave.layers["Camada de Blocos 3"])
                gameMapCave:drawLayer(gameMapCave.layers["Camada de Blocos 2"])
                gameMapCave:drawLayer(gameMapCave.layers["Camada de Blocos 1"])
                gameMapCave:drawLayer(gameMapCave.layers["caverna"])
                gameMapCave:drawLayer(gameMapCave.layers["Camada de Blocos 5"])
            end
                
            -- Executa animação do personagem
            playerClass.RenderPlayer()
                
            if fase == 1 and player.arma == 'hand' then
                LG.draw(arco.img, arco.x, arco.y)
            end     
            
            for i, actual in pairs(shots) do        
                LG.draw(actual.img, actual.x, actual.y)
            end            
            
        cam:detach()    
       
        if player.life == 1 then                                                          
            LG.setFont(deadFont)                
            LG.setColor(255, 255, 255)                       
            LG.print('Morreu', 570, 300)                 
            LG.setFont(gameFont)        
            suit.draw() -- Renderiza o botão de reiniciar              
        end

        -- Timer do jogo
        LG.print(showTimer, 1450, 10)

        -- Renderiza a barra de vida do usuário
        LG.draw(player.spriteHealthBar[player.life], 5, 5)
        -- Renderiza a arma que está sendo usada
        playerClass.weaponInUse()

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
        playerClass.RunThroughImages(dt)
        
        -- Colidir com arco e pegar arco
        if colissionClass.HaveColission(player, arco) then
            player.arma = 'arco'
        end
        
        -- Testa colisão da troca de mapas / Fase 1 para Fase 2
        if colissionClass.HaveColission(player, woodsCheckPoint) then
            fase = 2
            player.collider = world:destroy()
            world = wf.newWorld(0, 9.81 * 4000, true)
            player.collider = world:newBSGRectangleCollider(150, 575, 100, 130, 10)
            player.collider:setFixedRotation(true)
            mapClass.RenderMap(fase, gameMapWoods, gameMapCave)    
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
        mapClass.RenderMap(fase, gameMapWoods, gameMapCave)    
    end
    
    if k == 'x' then
        player.arma = 'hand'
        playerClass.RenderPlayer()
    elseif k == 'z' then
        player.arma = 'arco'
        playerClass.RenderPlayer()
    elseif k == 'c' then
        player.arma = 'espada'            
    end
    
    if k == '0' then
        if player.life > 1 then
            player.life = player.life - 1
        else
            player.life = 5
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
    if love.mouse.isDown(1) and shotTrue and player.arma == 'arco' then
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

-- Função responsável por reiniciar o jogo quando o jogador morrer
function restartGame()    
    suit.layout:reset(650, 500)
    if suit.Button("Recomeçar", {id=3}, suit.layout:row(200,50)).hit then
        fase = 1
        player.life = 5        
        player.x = 100 
        player.y = 575         
        player.collider = world:destroy()
        world = wf.newWorld(0, 9.81 * 4000, true)
        player.collider = world:newBSGRectangleCollider(150, 575, 100, 130, 10)
        player.collider:setFixedRotation(true)
        mapClass.RenderMap(fase, gameMapWoods, gameMapCave)                
    end
end