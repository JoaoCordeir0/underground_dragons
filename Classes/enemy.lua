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
        if fase == 1 then
            for i = 1, 9, 3 do     
                if faseEnemys[i + 2] > 0 then
                    if enemy.isAttacking then        
                        LG.draw(
                            enemy.spriteSheetAttackHalberd[math.floor(enemy.currentSpriteAttackHalberd)],
                            faseEnemys[i],
                            faseEnemys[i + 1],
                            0,
                            1,
                            1,
                            enemy.spriteSheetAttackHalberd[1]:getWidth() / 2,
                            enemy.spriteSheetAttackHalberd[1]:getHeight() / 2
                        ) 
                    else 
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
                else 
                    LG.draw(
                        enemy.spriteSheetDie[math.floor(enemy.currentSpriteDie)],
                        faseEnemys[i],
                        faseEnemys[i + 1],
                        0,
                        1,
                        1,
                        enemy.spriteSheetDie[1]:getWidth() / 2,
                        enemy.spriteSheetDie[1]:getHeight() / 2
                    )
                end
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

        -- Animação atacando
        table.insert(enemy.spriteSheetAttackHalberd, LG.newImage('Insumos/Enemy/Goblin Halberd/attack/goblin_halberd_attack_01.png'))
        table.insert(enemy.spriteSheetAttackHalberd, LG.newImage('Insumos/Enemy/Goblin Halberd/attack/goblin_halberd_attack_02.png'))
        table.insert(enemy.spriteSheetAttackHalberd, LG.newImage('Insumos/Enemy/Goblin Halberd/attack/goblin_halberd_attack_03.png'))
        table.insert(enemy.spriteSheetAttackHalberd, LG.newImage('Insumos/Enemy/Goblin Halberd/attack/goblin_halberd_attack_04.png'))
        table.insert(enemy.spriteSheetAttackHalberd, LG.newImage('Insumos/Enemy/Goblin Halberd/attack/goblin_halberd_attack_05.png'))
        table.insert(enemy.spriteSheetAttackHalberd, LG.newImage('Insumos/Enemy/Goblin Halberd/attack/goblin_halberd_attack_06.png'))
        table.insert(enemy.spriteSheetAttackHalberd, LG.newImage('Insumos/Enemy/Goblin Halberd/attack/goblin_halberd_attack_07.png'))
        table.insert(enemy.spriteSheetAttackHalberd, LG.newImage('Insumos/Enemy/Goblin Halberd/attack/goblin_halberd_attack_08.png'))
        table.insert(enemy.spriteSheetAttackHalberd, LG.newImage('Insumos/Enemy/Goblin Halberd/attack/goblin_halberd_attack_09.png'))
        table.insert(enemy.spriteSheetAttackHalberd, LG.newImage('Insumos/Enemy/Goblin Halberd/attack/goblin_halberd_attack_10.png'))

        -- Animação morto
        table.insert(enemy.spriteSheetDie, LG.newImage('Insumos/Enemy/Goblin Halberd/die/goblin_halberd_die_00.png'))
        table.insert(enemy.spriteSheetDie, LG.newImage('Insumos/Enemy/Goblin Halberd/die/goblin_halberd_die_01.png'))
        table.insert(enemy.spriteSheetDie, LG.newImage('Insumos/Enemy/Goblin Halberd/die/goblin_halberd_die_02.png'))
        table.insert(enemy.spriteSheetDie, LG.newImage('Insumos/Enemy/Goblin Halberd/die/goblin_halberd_die_03.png'))
        table.insert(enemy.spriteSheetDie, LG.newImage('Insumos/Enemy/Goblin Halberd/die/goblin_halberd_die_04.png'))
        table.insert(enemy.spriteSheetDie, LG.newImage('Insumos/Enemy/Goblin Halberd/die/goblin_halberd_die_05.png'))
        table.insert(enemy.spriteSheetDie, LG.newImage('Insumos/Enemy/Goblin Halberd/die/goblin_halberd_die_06.png'))
        table.insert(enemy.spriteSheetDie, LG.newImage('Insumos/Enemy/Goblin Halberd/die/goblin_halberd_die_07.png'))
    end

    self.RunThroughImagesEnemys = function(dt)
        -- Animação inimigo   
        -- Animação Parado
        enemy.currentSpriteIdle = enemy.currentSpriteIdle + 10 * dt
        if enemy.currentSpriteIdle >= 8 then
            enemy.currentSpriteIdle = 1
        end   
        
        -- Animação da lança
        enemy.currentSpriteAttackHalberd = enemy.currentSpriteAttackHalberd + 10 * dt
        if enemy.currentSpriteAttackHalberd >= 10 then
            enemy.currentSpriteAttackHalberd = 1
        end 

        -- Animação de morte
        enemy.currentSpriteDie = enemy.currentSpriteDie + 10 * dt
        if enemy.currentSpriteDie >= 8 then
            enemy.currentSpriteDie = 8
        end 
    end
    
    return self
end
