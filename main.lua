-- Classes
require('Classes.player')
require('Classes.menu')
require('Classes.colission')
require('Classes.table')
require('Classes.enemy')
require('Classes.npc')

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
local historyGame
local winGame
local crosshair

-- Classe do Player, Mapa e Colisão
local playerClass = nil
local colissionClass = nil
local menuClass = nil
local tableClass = nil
local enemyClass = nil
local npcClass = nil

-- Variavel de controle do tempo do jogo
local showTimer = "0:00"

-- Variaveis para tratar colisão do mapa e personagem
local gameMapWoods
local gameMapCave
local gameMapCastle
local wf = require 'libraries/windfield'
local player = {}
local enemy = {}
local npc = {}

-- Variaveis para tratar o mundo
local fase = -4
local world
local espinho
local espinhos = {}
local wall
local walls = {}
local audios = {}

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
local attackTrue = true
local timeAttack = 1.5

-- Fontes do jogo
local gameFont
local deadFont

-- Configurações do jogo
local showFPS = false
local showCoordinates = false

-- Tabelas de posições dos inimigos
                    --  x    y  life Attack
local fase1_enemys = {1585, 440, 3, false, 2050, 505, 3, false, 2700, 570, 3, false}
local fase2_enemys = {1080, 375, 3, false, 1820, 570, 3, false, 3030, 500, 3, false}
local fase3_enemys = {1080, 485, 3, false, 1675, 230, 3, false, 2500, 465, 3, false}
                  -- x     y   life attack direction  
local fase3_boss = {3300, 405, 6, false, 'left'}

function love.load()
    --love.window.setFullscreen(true, "desktop")

    -- Fonte
    gameFont = LG.newFont('Insumos/Fonts/RetroMario-Regular.otf', 18)
    deadFont = LG.newFont('Insumos/Fonts/RetroMario-Regular.otf', 100)
    
    -- Mira do jogo
    crosshair = LM.newCursor("Insumos/Objeto/crosshair.png",0,0)

    -- Carrega video de abertura
    video = LG.newVideo('Insumos/Videos/VideoIntro.ogv')
    video:play()
    
    -- Carrega meu background no menu
    backgroundMenu = LG.newImage('Insumos/Menu/backgroundMenu.jpg')

    -- Carrega meu background na opçoes
    backgroundOpcoes = LG.newImage('Insumos/Menu/ConfigsGame.png')

    -- Carrega imagem da história do jogo
    historyGame = LG.newImage('Insumos/Menu/HistoryGame.png')

    -- Carrega a tela de vitória do personagem
    winGame = LG.newImage('Insumos/Menu/WinGame.png')

    -- Carrega minha biblioteca de colisão
    world = wf.newWorld(0, 9.81 * 4000, true)

    -- Instância da classe do Player
    playerClass = ClassePlayer.new(player)

    -- Instância da classe de colisão
    colissionClass = ClasseColission.new()

    -- Instância da classe do menu
    menuClass = ClasseMenu.new()

    -- Instância da classe de busca em tabelas ou mais conhecido como array
    tableClass = ClasseTable.new()

    -- Instância da classe de inimigos
    enemyClass = ClasseEnemy.new(enemy)

    -- Instância da classe de npcs
    npcClass = ClasseNpc.new(npc)

    -- Carrega os audios que serão usados no game 
    audios.menu = love.audio.newSource('Insumos/Audios/Nubes.mp3', 'static')
    audios.menu:setVolume(0.1)
    audios.menu:setLooping(true)
    audios.fase1 = love.audio.newSource('Insumos/Audios/Woods.mp3', 'static')
    audios.fase1:setVolume(0.1)
    audios.fase1:setLooping(true)
    audios.fase2 = love.audio.newSource('Insumos/Audios/Cave.mp3', 'static')
    audios.fase2:setVolume(0.1)
    audios.fase2:setLooping(true)
    audios.fase3 = love.audio.newSource('Insumos/Audios/Castle.mp3', 'static')
    audios.fase3:setVolume(0.1)
    audios.fase3:setLooping(true)
    audios.sword = love.audio.newSource('Insumos/Audios/Sword.mp3', 'static')    
    audios.sword:setVolume(0.4)
    audios.fireBreath = love.audio.newSource('Insumos/Audios/FireBreath.mp3', 'static')    
    audios.fireBreath:setVolume(0.4)
    audios.bow = love.audio.newSource('Insumos/Audios/Bow.mp3', 'static')    
    audios.bow:setVolume(0.4)    
    audios.hit = love.audio.newSource('Insumos/Audios/Hit.mp3', 'static')    
    audios.hit:setVolume(0.4)

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
    -- Vida do boss
    enemy.spriteHealthBar = {}

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
    enemy.spriteSheetIdle1 = {} -- Tabela de animacao do personagem parado
    enemy.spriteSheetDie1 = {} -- Tabela de animacao do personagem morrendo    
    enemy.spriteSheetAttack1 = {} -- Tabela de animação do inimigo atacando com a lança
    enemy.currentSpriteIdle1 = 1    
    enemy.currentSpriteDie1 = 1
    enemy.currentSpriteAttack1 = 1

    -- Sprite inimigo fase 2
    enemy.spriteSheetIdle2 = {} -- Tabela de animacao do personagem parado
    enemy.spriteSheetDie2 = {} -- Tabela de animacao do personagem morrendo    
    enemy.spriteSheetAttack2 = {} -- Tabela de animação do inimigo atacando com a lança
    enemy.currentSpriteIdle2 = 1    
    enemy.currentSpriteDie2 = 1
    enemy.currentSpriteAttack2 = 1

    -- Sprite inimigo fase 3
    enemy.spriteSheetIdle3 = {} -- Tabela de animacao do personagem parado
    enemy.spriteSheetDie3 = {} -- Tabela de animacao do personagem morrendo    
    enemy.spriteSheetAttack3 = {} -- Tabela de animação do inimigo atacando com a lança
    enemy.currentSpriteIdle3 = 1    
    enemy.currentSpriteDie3 = 1
    enemy.currentSpriteAttack3 = 1

    -- Sprite inimigo fase 3 boss    
    enemy.spriteSheetDie4Left = {} -- Tabela de animacao do personagem morrendo    
    enemy.spriteSheetRun4Left = {} -- Tabela de animacao do personagem andando
    enemy.spriteSheetAttack4Left = {} -- Tabela de animação do inimigo atacando com a lança      
    enemy.currentSpriteDie4Left = 1
    enemy.currentSpriteRun4Left = 1
    enemy.currentSpriteAttack4Left = 1    
    enemy.spriteSheetDie4Right = {} -- Tabela de animacao do personagem morrendo    
    enemy.spriteSheetRun4Right = {} -- Tabela de animacao do personagem andando
    enemy.spriteSheetAttack4Right = {} -- Tabela de animação do inimigo atacando com a lança    
    enemy.currentSpriteDie4Right = 1
    enemy.currentSpriteRun4Right = 1
    enemy.currentSpriteAttack4Right = 1

    -- Sprite do NPC edwin
    npc.spriteSheetIdle1 = {} -- Tabela de animacao do personagem parado    
    npc.spriteSheetRun1 = {} -- Tabela de animacao do personagem andando    
    npc.currentSpriteIdle1 = 1        
    npc.currentSpriteRun1 = 1    

    -- Informações da posição inicial do player
    player.life = 6
    player.gun = 'hand'
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

    -- Carrega as imagens do NPC
    npcClass.LoadNpcImages()
    
    -- Cria o mundo e o colisor do meu personagem
    player.collider = world:newBSGRectangleCollider(player.x, player.y, 100, 130, 10)
    player.collider:setFixedRotation(true)   
    
    -- Posição, tamanho do checkpoint de troca de mapa
    woodsCheckPoint.x = 3750
    woodsCheckPoint.y = 500
    woodsCheckPoint.size = 200

    caveCheckPoint.x = 3700
    caveCheckPoint.y = 500
    caveCheckPoint.size = 200
    
    -- Posição, tamanho e imagem do arco
    bow.x = 560
    bow.y = 465
    bow.img = LG.newImage('Insumos/Objeto/weapon_bow.png')
    bow.size = 100
    bow.amountArrowsFase1 = 4    
    bow.amountArrowsFase2 = 4    
    bow.amountArrowsFase3 = 10

    -- Posição, tamanho e imagem da espada
    sword.x = 700
    sword.y = 485
    sword.img = LG.newImage('Insumos/Objeto/weapon_sword.png')
    sword.size = 100
    
    -- Carrega o Mapa
    RenderMap()    
end

function love.draw()   
    if fase >= 1 then        
        -- Coloco o foco da camera no meu personagem
        LG.setFont(gameFont)

        cam:attach()                             
            if player.life == 1 then
                LG.setColor(255, 0, 0)     
            end            
            
            -- Caso a Fase for igual a 1 carrega os layers/camadas do meu mapa
            if fase == 1 then
                gameMapWoods:drawLayer(gameMapWoods.layers["Background3"])
                gameMapWoods:drawLayer(gameMapWoods.layers["Background2"])
                gameMapWoods:drawLayer(gameMapWoods.layers["Background1"])
                gameMapWoods:drawLayer(gameMapWoods.layers["Vegetacao"])
                gameMapWoods:drawLayer(gameMapWoods.layers["Caverna"])
                gameMapWoods:drawLayer(gameMapWoods.layers["Camada de Blocos 1"])

                -- Renderiza os inimigos
                enemyClass.RenderEnemy(1, fase1_enemys)
                
                -- Renderiza poção de vida no fim da fase
                LG.draw(LG.newImage('Insumos/Objeto/health_potion.png'), 3600, 550)

            elseif fase == 2 then
                gameMapCave:drawLayer(gameMapCave.layers["Camada de Blocos 3"])
                gameMapCave:drawLayer(gameMapCave.layers["Camada de Blocos 2"])
                gameMapCave:drawLayer(gameMapCave.layers["Camada de Blocos 1"])
                gameMapCave:drawLayer(gameMapCave.layers["caverna"])
                gameMapCave:drawLayer(gameMapCave.layers["Camada de Blocos 5"])

                -- Renderiza os inimigos
                enemyClass.RenderEnemy(2, fase2_enemys)
                
                -- Renderiza poção de vida no fim da fase
                LG.draw(LG.newImage('Insumos/Objeto/health_potion.png'), 3530, 480)

            elseif fase == 3 then
                gameMapCastle:drawLayer(gameMapCastle.layers["Background1"])
                gameMapCastle:drawLayer(gameMapCastle.layers["Background3"])
                gameMapCastle:drawLayer(gameMapCastle.layers["Background2"])
                gameMapCastle:drawLayer(gameMapCastle.layers["Camada de Blocos 5"])
                gameMapCastle:drawLayer(gameMapCastle.layers["Camada de Blocos 1"])
                gameMapCastle:drawLayer(gameMapCastle.layers["Escada"])

                -- Renderiza os inimigos
                enemyClass.RenderEnemy(3, fase3_enemys, audios)

                -- Renderiza o boss
                enemyClass.RenderEnemyBoss(3, fase3_boss)

                -- Renderiza o doutor Edwin preso no castelo
                npcClass.RenderNpc()
            end
                
            -- Executa animação do personagem
            playerClass.RenderPlayer()
                
            if fase == 1 and not tableClass.contains(playerGuns, 'bow') and bow.amountArrowsFase1 > 0 then
                LG.draw(bow.img, bow.x, bow.y)
            end     

            if fase == 1 and not tableClass.contains(playerGuns, 'sword') then
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

        -- Renderiza a barra de vida do usuário
        LG.draw(player.spriteHealthBar[player.life], 5, 5)

        if fase == 3 and fase3_boss[3] >= 1 then
            -- Renderiza a barra de vida do boss
            LG.draw(enemy.spriteHealthBar[fase3_boss[3]], LG.getWidth() - 276, 5)
        end
        
        -- Renderiza a arma que está sendo usada
        playerClass.weaponInUse(fase, bow)        

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
        LG.draw(LG.newImage('Insumos/Videos/logoDragoesDoSubmundo.png'), (LG.getWidth() / 2) - 360, -100)
        suit.draw()
    elseif fase == -1 then
        LG.draw(historyGame, (LG.getWidth() / 2) - 800, 0)       
    elseif fase == -2 then
        LG.draw(winGame, (LG.getWidth() / 2) - 800, 0)       
    elseif fase == -3 then
        LG.draw(backgroundOpcoes, (LG.getWidth() / 2) - 800, 0)
    elseif fase == -4 then
        LG.draw(video, (LG.getWidth() / 2) - 960, (LG.getHeight() / 2) - 540)                
        if not video:isPlaying() then
            fase = 0
        end
    end
end

function love.update(dt)    
    if fase == 0 then
        -- Limpa as armas do player
        playerGuns = {'hand'}
        player.gun = 'hand'

        -- Reseta as informações do inimigo
        for i = 1, 12, 4 do
            fase1_enemys[i + 2] = 3        
            fase2_enemys[i + 2] = 3     
            fase1_enemys[i + 3] = false
            fase2_enemys[i + 3] = false   
        end     

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

        if player.x < 3080 then
            cam:lookAt(player.x, player.y - 200)
        end

        local w = LG.getWidth()
        local h = LG.getHeight()
        
        -- Esconde fundo preto Left
        if cam.x < w / 2 then
            cam.x = w / 2
        end
        
        -- Esconde fundo preto Top left
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
               
        -- Colidir com a espada e pega-la
        if colissionClass.HaveColission(player, sword) and fase == 1 then
            player.gun = 'sword'
            table.insert(playerGuns, 'sword')
        end

        -- Colidir com o arco e pega-lo
        if colissionClass.HaveColission(player, bow) and fase == 1 then
            player.gun = 'bow'
            table.insert(playerGuns, 'bow')                       
        end
        
        -- Testa colisão da troca de mapas / Fase 1 para Fase 2
        if colissionClass.HaveColission(player, woodsCheckPoint) and fase == 1 and enemyClass.checkEnemyDie(fase1_enemys) then            
            if player.life < 5 then 
                player.life = 5
            end
            fase = 2
            player.collider = world:destroy()
            world = wf.newWorld(0, 9.81 * 4000, true)
            player.collider = world:newBSGRectangleCollider(150, 575, 100, 130, 10)
            player.collider:setFixedRotation(true)
            RenderMap()
        elseif colissionClass.HaveColission(player, caveCheckPoint) and fase == 2 and enemyClass.checkEnemyDie(fase2_enemys) then
            if player.life < 5 then 
                player.life = 5
            end
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

        -- Controle de dano no personagem
        if fase == 1 then
            applyDamagePlayer(dt, fase1_enemys)       
            -- Controle de dano nos inimigos
            applyDamageEnemy(dt, fase1_enemys)
        elseif fase == 2 then                   
            -- Control de dano no personagem            
            applyDamagePlayer(dt, fase2_enemys)       
            -- Controle de dano nos inimigos
            applyDamageEnemy(dt, fase2_enemys)
        elseif fase == 3 then
            -- Reseta o inventario com a flecha
            playerGuns = {'hand', 'sword', 'bow'}
            -- Control de dano no personagem       
            applyDamagePlayer(dt, fase3_enemys)       
            -- Controle de dano nos inimigos
            applyDamageEnemy(dt, fase3_enemys)
            -- Controle de dano no boss da fase 3
            applyDamageBoss(dt)
            -- IA do boss que segue o player para mata-lo
            bossIA(dt)
        end       
    end

    -- Verifica se o player obteve a vitória     
    if player.x > 3600 and fase3_boss[3] == 0 then
        fase = -2
    end

    -- Controle dos audios de cada fase
    if fase == 1 then
        audios.fase1:play()        
    else 
        audios.fase1:stop()
    end

    if fase == 2 then
        audios.fase2:play()        
    else 
        audios.fase2:stop()
    end

    if fase == 3 then
        audios.fase3:play()        
    else 
        audios.fase3:stop()
    end

    if fase == 0 or fase == -1 or fase == -2 or fase == -3 then
        audios.menu:play()
    else 
        audios.menu:stop()
    end
end

function love.keypressed(k)
    if k == 'escape' or k == 'space' and fase == -4 then
        fase = 0
        LG.draw(backgroundMenu, 0 ,0)
        suit.draw()   
        if video:isPlaying() then
            video:pause()   
        end
    end
   
    if fase == -1 and k == 'return' then
        initGame()
    end

    -- Opções de configuração do game
    if k == 'p' then
        if showFPS then
            showFPS = false
        else
            showFPS = true
        end
    end
    if k == 'o' then
        if showCoordinates then
            showCoordinates = false
        else
            showCoordinates = true
        end
    end  

    -- Teclas de troca de armas no inventário
    if k == '1' and tableClass.contains(playerGuns, 'hand') then
        player.gun = 'hand'
        playerClass.RenderPlayer()
    elseif k == '2' and tableClass.contains(playerGuns, 'bow') then
        player.gun = 'bow'
        playerClass.RenderPlayer()
    elseif k == '3' and tableClass.contains(playerGuns, 'sword') then
        player.gun = 'sword'
        playerClass.RenderPlayer()         
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

-- Função que inicia o jogo na fase 1 com todas as variaveis limpas
function initGame()
    -- Reseta para fase 1
    fase = 1
    -- Reseta o player
    playerGuns = {'hand'}
    player.life = 6
    player.x = 100
    player.y = 575
    player.gun = 'hand'    
    bow.amountArrowsFase1 = 4    
    bow.amountArrowsFase2 = 4    
    bow.amountArrowsFase3 = 12
    -- Reseta o inimigo
    for i = 1, 12, 4 do
        fase1_enemys[i + 2] = 3        
        fase2_enemys[i + 2] = 3     
        fase1_enemys[i + 3] = false
        fase2_enemys[i + 3] = false   
    end        

    player.collider = world:destroy()
    world = wf.newWorld(0, 9.81 * 4000, true)
    player.collider = world:newBSGRectangleCollider(150, 575, 100, 130, 10)
    player.collider:setFixedRotation(true)
    RenderMap()
end

-- Função responsável por reiniciar o jogo quando o jogador morrer
function restartGame()    
    --suit.layout:reset(650, 500)    
    suit.layout:reset((LG.getWidth() / 2) - 100, 500) -- x / y    
    if suit.Button("Recomeçar", {id=3}, suit.layout:row(200,50)).hit then
        -- Reseta para fase 1
        fase = 1
        -- Reseta o player
        playerGuns = {'hand'}
        player.life = 6
        player.x = 100
        player.y = 575
        player.gun = 'hand'    
        bow.amountArrowsFase1 = 4    
        bow.amountArrowsFase2 = 4    
        bow.amountArrowsFase3 = 12
        -- Reseta o inimigo
        for i = 1, 12, 4 do
            fase1_enemys[i + 2] = 3        
            fase2_enemys[i + 2] = 3    
            fase3_enemys[i + 2] = 3     
            fase1_enemys[i + 3] = false
            fase2_enemys[i + 3] = false                              
            fase3_enemys[i + 3] = false                              
        end        
        fase3_boss[3] = 6        

        player.collider = world:destroy()
        world = wf.newWorld(0, 9.81 * 4000, true)
        player.collider = world:newBSGRectangleCollider(150, 575, 100, 130, 10)
        player.collider:setFixedRotation(true)
        RenderMap()
    end
end

-- Aplica dano ao personagem ao colidir com inimigos
function applyDamagePlayer(dt, faseEnemys)    
    for i = 1, 12, 4 do
        -- Primeiro valida se o personagem está no mesmo lugar com range de 150 que o inimigo -> X
        local condition1 = player.x > faseEnemys[i] - 150 and player.x < faseEnemys[i] + 150
        -- Valida se o personagem está no mesmo lugar com range de 150 que o inimigo -> Y
        local condition2 = player.y > faseEnemys[i + 1] - 150 and player.y < faseEnemys[i + 1] + 150
        -- Verifica se o inimigo colidido está vivo
        local condition3 = faseEnemys[i + 2] > 0 

        if condition1 and condition2 and condition3 then
            if i >= 1 and i <= 2 then                            
                -- Caso haja colisão, chama função que aplica dano no personagem
                playerClass.playerDamage(dt, 'enemy', audios)
                faseEnemys[4] = true
            else
                faseEnemys[4] = false
            end
            if i >= 5 and i <= 6 then                            
                -- Caso haja colisão, chama função que aplica dano no personagem
                playerClass.playerDamage(dt, 'enemy', audios)
                faseEnemys[8] = true
            else
                faseEnemys[8] = false
            end
            if i >= 9 and i <= 10 then                            
                -- Caso haja colisão, chama função que aplica dano no personagem
                playerClass.playerDamage(dt, 'enemy', audios)
                faseEnemys[12] = true
            else
                faseEnemys[12] = false
            end       
        end          
    end    
end

-- Função de controle de tiro com arco e flecha
function controlShots(dt)
    -- Temporizador dos disparos
    timeAttack = timeAttack - (1 * dt)
    if timeAttack < 0 then
        attackTrue = true
    end
    -- Controlar o disparo com o mouse
    if love.mouse.isDown(1) and attackTrue and player.gun == 'bow' then
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
                        
        -- Controle do total de flechas disponiveis em cada fase
        if fase == 1 and bow.amountArrowsFase1 >= 0 then
            bow.amountArrowsFase1 = bow.amountArrowsFase1 - 1
        end
        if fase == 2 and bow.amountArrowsFase2 >= 0 then
            bow.amountArrowsFase2 = bow.amountArrowsFase2 - 1   
        end
        if fase == 3 and bow.amountArrowsFase3 >= 0 then
            bow.amountArrowsFase3 = bow.amountArrowsFase3 - 1
        end
        
        -- Dispara apenas se houver flechas disponiveis na fase
        if fase == 1 and bow.amountArrowsFase1 >= 0 then
            -- Audio do disparo da flecha
            audios.bow:play()
            table.insert(shots, newShot)
        elseif fase == 2 and bow.amountArrowsFase2 >= 0 then
            -- Audio do disparo da flecha
            audios.bow:play()
            table.insert(shots, newShot)
        elseif fase == 3 and bow.amountArrowsFase3 >= 0 then
            -- Audio do disparo da flecha
            audios.bow:play()
            table.insert(shots, newShot)
        end  
        
        attackTrue = false
        timeAttack = 1.3
    end
        
    -- Animação dos disparos
    for i, actual in pairs(shots) do
        -- Física: Dx = deslocamento na direção X, Dy = deslocamento na direção Y
        local Dx = veloc * math.cos(actual.ang)
        local Dy = veloc * math.sin(actual.ang)
        actual.x = actual.x + (Dx * dt)
        actual.y = actual.y + (Dy * dt)
        
        -- Verificação para a limpeza de disparos que sairem da tela
        if actual.x > 5000 or actual.y > 2000 or actual.x < 0 or actual.y < 0 then
            table.remove(shots, i)
        end
    end
end

-- Aplica dano ao inimigo ao colidir com personagem
function applyDamageEnemy(dt, faseEnemys)

    if player.gun == 'bow' then    
        for i, shot in pairs(shots) do                                
            for c = 1, 12, 4 do
                -- Primeiro valida se o personagem está no mesmo lugar com range de 100 que o inimigo -> X
                if shot.x > faseEnemys[c] - 100 and shot.x < faseEnemys[c] + 100 then
                    -- Valida se o personagem está no mesmo lugar com range de 100 que o inimigo -> Y
                    if shot.y > faseEnemys[c + 1] - 100 and shot.y < faseEnemys[c + 1] + 100 then
                        
                        -- Caso haja colisão, aplica dano no inimigo

                        -- 3 life do enemy 1
                        -- 6 life do enemy 2
                        -- 9 life do enemy 3

                        if faseEnemys[c + 2] > 0 then
                            -- Remove o tiro
                            table.remove(shots, i)

                            -- Dispara audio de dano
                            audios.hit:play()
                            
                            if c >= 1 and c <= 2 then                            
                                faseEnemys[3] = faseEnemys[3] - 1                                                
                            elseif c >= 5 and c <= 6 then                            
                                faseEnemys[7] = faseEnemys[7] - 1                        
                            elseif c >= 9 and c <= 10 then                            
                                faseEnemys[11] = faseEnemys[11] - 1  
                            end
                        end                       
                    end
                end
            end
        end 
    elseif player.gun == 'sword' then
        for c = 1, 12, 4 do
            if LM.isDown(1) then
                -- Audio de ataque com a espada
                audios.sword:play()
                -- Primeiro valida se o personagem está no mesmo lugar com range de 150 que o inimigo
                if player.x > faseEnemys[c] - 150 and player.x < faseEnemys[c] + 150 then
                    -- Primeiro valida se o personagem está no mesmo lugar com range de 150 que o inimigo
                    if player.y > faseEnemys[c + 1] - 150 and player.y < faseEnemys[c + 1] + 150 then
                        -- Caso haja colisão, aplica dano no inimigo

                        -- 3 life do enemy 1
                        -- 6 life do enemy 2
                        -- 9 life do enemy 3
                        timeAttack = timeAttack - (1 * dt)
                        if timeAttack < 0 then
                            attackTrue = true
                        end
        
                        if attackTrue then
                            if faseEnemys[c + 2] > 0 then                     
                                -- Dispara audio de dano
                                audios.hit:play()
                                
                                if c >= 1 and c <= 2 then                            
                                    faseEnemys[3] = faseEnemys[3] - 1                                                
                                elseif c >= 5 and c <= 6 then                            
                                    faseEnemys[7] = faseEnemys[7] - 1                        
                                elseif c >= 9 and c <= 10 then                            
                                    faseEnemys[11] = faseEnemys[11] - 1  
                                end
                            end    
                            attackTrue = false
                            timeAttack = 2 -- Define a dificuldade de ataque com a espada
                        end     
                    end         
                end                   
            end
        end
    end
end

-- Aplica dano ao boss
function applyDamageBoss(dt)
    -- Primeiro valida se o personagem está no mesmo lugar com range de 200 que o inimigo -> X
    local condition1 = player.x > fase3_boss[1] - 200 and player.x < fase3_boss[1] + 200
    -- Valida se o personagem está no mesmo lugar com range de 200 que o inimigo -> Y
    local condition2 = player.y > fase3_boss[2] - 200 and player.y < fase3_boss[2] + 200
    -- Verifica se o inimigo colidido está vivo
    local condition3 = fase3_boss[3] > 0 

    if condition1 and condition2 and condition3 then           
        -- Caso haja colisão, chama função que aplica dano no personagem
        playerClass.playerDamage(dt, 'boss', audios)
                    
        fase3_boss[4] = true

        -- Identifica dano causado no boss com espada 
        if LM.isDown(1) and player.gun == 'sword' then
            -- Caso haja colisão, aplica dano no inimigo            
            timeAttack = timeAttack - (1 * dt)
            if timeAttack < 0 then
                attackTrue = true
            end
        
            if attackTrue then
                if fase3_boss[3] > 0 then                     
                    fase3_boss[3] = fase3_boss[3] - 1
                end    
                attackTrue = false
                timeAttack = 2 -- Define a dificuldade de ataque com a espada
            end     
        end
    else
        fase3_boss[4] = false    
    end   
    
    if player.gun == 'bow' then    
        for i, shot in pairs(shots) do                                           
            -- Primeiro valida se o personagem está no mesmo lugar com range de 200 que o inimigo -> X
            if shot.x > fase3_boss[1] - 200 and shot.x < fase3_boss[1] + 200 then
                -- Valida se o personagem está no mesmo lugar com range de 200 que o inimigo -> Y
                if shot.y > fase3_boss[2] - 200 and shot.y < fase3_boss[2] + 200 then                        
                    -- Caso haja colisão, aplica dano no inimigo
                    if fase3_boss[3] > 0 then
                        -- Remove o tiro
                        table.remove(shots, i)

                        fase3_boss[3] = fase3_boss[3] - 1
                    end                       
                end
            end          
        end 
    end
end

-- IA do boss para seguir o personagem 
function bossIA(dt)             
    local condition = player.x > fase3_boss[1] - 200 and player.x < fase3_boss[1] + 200

    if not condition and fase3_boss[3] > 0 then
        
        if fase3_boss[5] == 'left' then
            if fase3_boss[1] <= 1900 or player.x > fase3_boss[1] then 
                fase3_boss[5] = 'right'
            end
            fase3_boss[1] = fase3_boss[1] - 100 * dt  
        end

        if fase3_boss[5] == 'right' then
            if fase3_boss[1] >= 3600 or player.x < fase3_boss[1] then
                fase3_boss[5] = 'left'
            end
            fase3_boss[1] = fase3_boss[1] + 100 * dt   
        end

    end
end