local LG = love.graphics
local LK = love.keyboard
local LM = love.mouse

-- Timers para controlar os danos
local damageTrue = true
local activateMax = 1.1
local timeDamage = activateMax

ClasseEnemy = {}

ClasseEnemy.new = function(enemy)
    local self = self or {}

    self.enemy = enemy

    -- Renderiza e executa animações do personagem
    self.RenderEnemy = function(fase, faseEnemys)     
        -- Fase = 1: renderiza 3 inimigos
        if fase == 1 then                
            for i = 1, 6, 2 do             
                LG.draw(
                    enemy.spriteSheetIdle[math.floor(enemy.currentSpriteIdle)],
                    faseEnemys[i],
                    faseEnemys[i + 1],
                    0,
                    1,
                    1,
                    enemy.spriteSheetIdle[1]:getWidth() / 2,
                    enemy.spriteSheetIdle[1]:getHeight() / 2
                ) 
            end            
        end   
    end

    self.LoadEnemyImages = function()
        -- Aqui vou criar as tabelas das animações diferentes
        -- Animação de ficar Parado
        table.insert(enemy.spriteSheetIdle, LG.newImage('Insumos/Enemy/Goblin Halberd/idle/goblin_halberd_idle_0.png'))
        table.insert(enemy.spriteSheetIdle, LG.newImage('Insumos/Enemy/Goblin Halberd/idle/goblin_halberd_idle_1.png'))
        table.insert(enemy.spriteSheetIdle, LG.newImage('Insumos/Enemy/Goblin Halberd/idle/goblin_halberd_idle_2.png'))
        table.insert(enemy.spriteSheetIdle, LG.newImage('Insumos/Enemy/Goblin Halberd/idle/goblin_halberd_idle_3.png'))
        table.insert(enemy.spriteSheetIdle, LG.newImage('Insumos/Enemy/Goblin Halberd/idle/goblin_halberd_idle_4.png'))
        table.insert(enemy.spriteSheetIdle, LG.newImage('Insumos/Enemy/Goblin Halberd/idle/goblin_halberd_idle_5.png'))
        table.insert(enemy.spriteSheetIdle, LG.newImage('Insumos/Enemy/Goblin Halberd/idle/goblin_halberd_idle_6.png'))
        table.insert(enemy.spriteSheetIdle, LG.newImage('Insumos/Enemy/Goblin Halberd/idle/goblin_halberd_idle_7.png'))        
    end

    self.RunThroughImagesEnemys = function(dt)
        -- Animação inimigo   
        -- Animação Parado
        enemy.currentSpriteIdle = enemy.currentSpriteIdle + 10 * dt
        if enemy.currentSpriteIdle >= 8 then
            enemy.currentSpriteIdle = 1
        end        
    end
    
    return self
end
