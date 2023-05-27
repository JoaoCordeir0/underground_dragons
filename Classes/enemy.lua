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
            for i = 1, 12, 4 do     
                if faseEnemys[i + 2] > 0 then
                    if faseEnemys[i + 3] then        
                        LG.draw(
                            enemy.spriteSheetAttack1[math.floor(enemy.currentSpriteAttack1)],
                            faseEnemys[i],
                            faseEnemys[i + 1],
                            0,
                            1,
                            1,
                            enemy.spriteSheetAttack1[1]:getWidth() / 2,
                            enemy.spriteSheetAttack1[1]:getHeight() / 2
                        ) 
                    else 
                        LG.draw(
                            enemy.spriteSheetIdle1[math.floor(enemy.currentSpriteIdle1)],
                            faseEnemys[i],
                            faseEnemys[i + 1],
                            0,
                            1,
                            1,
                            enemy.spriteSheetIdle1[1]:getWidth() / 2,
                            enemy.spriteSheetIdle1[1]:getHeight() / 2
                        ) 
                    end
                else 
                    LG.draw(
                        enemy.spriteSheetDie1[math.floor(enemy.currentSpriteDie1)],
                        faseEnemys[i],
                        faseEnemys[i + 1],
                        0,
                        1,
                        1,
                        enemy.spriteSheetDie1[1]:getWidth() / 2,
                        enemy.spriteSheetDie1[1]:getHeight() / 2
                    )
                end
            end
        elseif fase == 2 then
            for i = 1, 12, 4 do          
                if faseEnemys[i + 2] > 0 then
                    if faseEnemys[i + 3] then        
                        LG.draw(
                            enemy.spriteSheetAttack2[math.floor(enemy.currentSpriteAttack2)],
                            faseEnemys[i],
                            faseEnemys[i + 1],
                            0,
                            1,
                            1,
                            enemy.spriteSheetAttack2[1]:getWidth() / 2,
                            enemy.spriteSheetAttack2[1]:getHeight() / 2
                        ) 
                    else 
                        LG.draw(
                            enemy.spriteSheetIdle2[math.floor(enemy.currentSpriteIdle2)],
                            faseEnemys[i],
                            faseEnemys[i + 1],
                            0,
                            1,
                            1,
                            enemy.spriteSheetIdle2[1]:getWidth() / 2,
                            enemy.spriteSheetIdle2[1]:getHeight() / 2
                        ) 
                    end
                else 
                    LG.draw(
                        enemy.spriteSheetDie2[math.floor(enemy.currentSpriteDie2)],
                        faseEnemys[i],
                        faseEnemys[i + 1],
                        0,
                        1,
                        1,
                        enemy.spriteSheetDie2[1]:getWidth() / 2,
                        enemy.spriteSheetDie2[1]:getHeight() / 2
                    )
                end
            end
        end
    end

    self.LoadEnemyImages = function()
        -- Aqui vou criar as tabelas das animações diferentes
        -- fase 1
        -- Animação de ficar Parado
        table.insert(enemy.spriteSheetIdle1, LG.newImage('Insumos/Enemy/Goblin Halberd/idle/goblin_halberd_idle_0.png'))
        table.insert(enemy.spriteSheetIdle1, LG.newImage('Insumos/Enemy/Goblin Halberd/idle/goblin_halberd_idle_1.png'))
        table.insert(enemy.spriteSheetIdle1, LG.newImage('Insumos/Enemy/Goblin Halberd/idle/goblin_halberd_idle_2.png'))
        table.insert(enemy.spriteSheetIdle1, LG.newImage('Insumos/Enemy/Goblin Halberd/idle/goblin_halberd_idle_3.png'))
        table.insert(enemy.spriteSheetIdle1, LG.newImage('Insumos/Enemy/Goblin Halberd/idle/goblin_halberd_idle_4.png'))
        table.insert(enemy.spriteSheetIdle1, LG.newImage('Insumos/Enemy/Goblin Halberd/idle/goblin_halberd_idle_5.png'))
        table.insert(enemy.spriteSheetIdle1, LG.newImage('Insumos/Enemy/Goblin Halberd/idle/goblin_halberd_idle_6.png'))
        table.insert(enemy.spriteSheetIdle1, LG.newImage('Insumos/Enemy/Goblin Halberd/idle/goblin_halberd_idle_7.png'))        

        -- Animação atacando
        table.insert(enemy.spriteSheetAttack1, LG.newImage('Insumos/Enemy/Goblin Halberd/attack/goblin_halberd_attack_01.png'))
        table.insert(enemy.spriteSheetAttack1, LG.newImage('Insumos/Enemy/Goblin Halberd/attack/goblin_halberd_attack_02.png'))
        table.insert(enemy.spriteSheetAttack1, LG.newImage('Insumos/Enemy/Goblin Halberd/attack/goblin_halberd_attack_03.png'))
        table.insert(enemy.spriteSheetAttack1, LG.newImage('Insumos/Enemy/Goblin Halberd/attack/goblin_halberd_attack_04.png'))
        table.insert(enemy.spriteSheetAttack1, LG.newImage('Insumos/Enemy/Goblin Halberd/attack/goblin_halberd_attack_05.png'))
        table.insert(enemy.spriteSheetAttack1, LG.newImage('Insumos/Enemy/Goblin Halberd/attack/goblin_halberd_attack_06.png'))
        table.insert(enemy.spriteSheetAttack1, LG.newImage('Insumos/Enemy/Goblin Halberd/attack/goblin_halberd_attack_07.png'))
        table.insert(enemy.spriteSheetAttack1, LG.newImage('Insumos/Enemy/Goblin Halberd/attack/goblin_halberd_attack_08.png'))
        table.insert(enemy.spriteSheetAttack1, LG.newImage('Insumos/Enemy/Goblin Halberd/attack/goblin_halberd_attack_09.png'))
        table.insert(enemy.spriteSheetAttack1, LG.newImage('Insumos/Enemy/Goblin Halberd/attack/goblin_halberd_attack_10.png'))

        -- Animação morto
        table.insert(enemy.spriteSheetDie1, LG.newImage('Insumos/Enemy/Goblin Halberd/die/goblin_halberd_die_00.png'))
        table.insert(enemy.spriteSheetDie1, LG.newImage('Insumos/Enemy/Goblin Halberd/die/goblin_halberd_die_01.png'))
        table.insert(enemy.spriteSheetDie1, LG.newImage('Insumos/Enemy/Goblin Halberd/die/goblin_halberd_die_02.png'))
        table.insert(enemy.spriteSheetDie1, LG.newImage('Insumos/Enemy/Goblin Halberd/die/goblin_halberd_die_03.png'))
        table.insert(enemy.spriteSheetDie1, LG.newImage('Insumos/Enemy/Goblin Halberd/die/goblin_halberd_die_04.png'))
        table.insert(enemy.spriteSheetDie1, LG.newImage('Insumos/Enemy/Goblin Halberd/die/goblin_halberd_die_05.png'))
        table.insert(enemy.spriteSheetDie1, LG.newImage('Insumos/Enemy/Goblin Halberd/die/goblin_halberd_die_06.png'))
        table.insert(enemy.spriteSheetDie1, LG.newImage('Insumos/Enemy/Goblin Halberd/die/goblin_halberd_die_07.png'))

        -- fase 2
        -- Animação de ficar Parado
        table.insert(enemy.spriteSheetIdle2, LG.newImage('Insumos/Enemy/Skleton/idle/skeleton_shield_idle_0.png'))
        table.insert(enemy.spriteSheetIdle2, LG.newImage('Insumos/Enemy/Skleton/idle/skeleton_shield_idle_1.png'))
        table.insert(enemy.spriteSheetIdle2, LG.newImage('Insumos/Enemy/Skleton/idle/skeleton_shield_idle_2.png'))
        table.insert(enemy.spriteSheetIdle2, LG.newImage('Insumos/Enemy/Skleton/idle/skeleton_shield_idle_3.png'))
        table.insert(enemy.spriteSheetIdle2, LG.newImage('Insumos/Enemy/Skleton/idle/skeleton_shield_idle_4.png'))
        table.insert(enemy.spriteSheetIdle2, LG.newImage('Insumos/Enemy/Skleton/idle/skeleton_shield_idle_5.png'))
        table.insert(enemy.spriteSheetIdle2, LG.newImage('Insumos/Enemy/Skleton/idle/skeleton_shield_idle_6.png'))
        table.insert(enemy.spriteSheetIdle2, LG.newImage('Insumos/Enemy/Skleton/idle/skeleton_shield_idle_7.png'))        

        -- Animação atacando
        table.insert(enemy.spriteSheetAttack2, LG.newImage('Insumos/Enemy/Skleton/attack/skeleton_shield_attack1_00.png'))
        table.insert(enemy.spriteSheetAttack2, LG.newImage('Insumos/Enemy/Skleton/attack/skeleton_shield_attack1_01.png'))
        table.insert(enemy.spriteSheetAttack2, LG.newImage('Insumos/Enemy/Skleton/attack/skeleton_shield_attack1_02.png'))
        table.insert(enemy.spriteSheetAttack2, LG.newImage('Insumos/Enemy/Skleton/attack/skeleton_shield_attack1_03.png'))
        table.insert(enemy.spriteSheetAttack2, LG.newImage('Insumos/Enemy/Skleton/attack/skeleton_shield_attack1_04.png'))
        table.insert(enemy.spriteSheetAttack2, LG.newImage('Insumos/Enemy/Skleton/attack/skeleton_shield_attack1_05.png'))
        table.insert(enemy.spriteSheetAttack2, LG.newImage('Insumos/Enemy/Skleton/attack/skeleton_shield_attack1_06.png'))
        table.insert(enemy.spriteSheetAttack2, LG.newImage('Insumos/Enemy/Skleton/attack/skeleton_shield_attack1_07.png'))
        table.insert(enemy.spriteSheetAttack2, LG.newImage('Insumos/Enemy/Skleton/attack/skeleton_shield_attack1_08.png'))
        table.insert(enemy.spriteSheetAttack2, LG.newImage('Insumos/Enemy/Skleton/attack/skeleton_shield_attack1_09.png'))
        table.insert(enemy.spriteSheetAttack2, LG.newImage('Insumos/Enemy/Skleton/attack/skeleton_shield_attack1_10.png'))
        table.insert(enemy.spriteSheetAttack2, LG.newImage('Insumos/Enemy/Skleton/attack/skeleton_shield_attack1_11.png'))
        table.insert(enemy.spriteSheetAttack2, LG.newImage('Insumos/Enemy/Skleton/attack/skeleton_shield_attack1_12.png'))

        -- Animação morto
        table.insert(enemy.spriteSheetDie2, LG.newImage('Insumos/Enemy/Skleton/die/skeleton_shield_die_00.png'))
        table.insert(enemy.spriteSheetDie2, LG.newImage('Insumos/Enemy/Skleton/die/skeleton_shield_die_01.png'))
        table.insert(enemy.spriteSheetDie2, LG.newImage('Insumos/Enemy/Skleton/die/skeleton_shield_die_02.png'))
        table.insert(enemy.spriteSheetDie2, LG.newImage('Insumos/Enemy/Skleton/die/skeleton_shield_die_03.png'))
        table.insert(enemy.spriteSheetDie2, LG.newImage('Insumos/Enemy/Skleton/die/skeleton_shield_die_04.png'))
        table.insert(enemy.spriteSheetDie2, LG.newImage('Insumos/Enemy/Skleton/die/skeleton_shield_die_05.png'))
        table.insert(enemy.spriteSheetDie2, LG.newImage('Insumos/Enemy/Skleton/die/skeleton_shield_die_06.png'))        
    end

    self.RunThroughImagesEnemys = function(dt)
        -- Animação inimigo   
        -- Fase 1
        -- Animação Parado
        enemy.currentSpriteIdle1 = enemy.currentSpriteIdle1 + 10 * dt
        if enemy.currentSpriteIdle1 >= 8 then
            enemy.currentSpriteIdle1 = 1
        end   
        
        -- Animação da lança
        enemy.currentSpriteAttack1 = enemy.currentSpriteAttack1 + 10 * dt
        if enemy.currentSpriteAttack1 >= 10 then
            enemy.currentSpriteAttack1 = 1
        end 

        -- Animação de morte
        enemy.currentSpriteDie1 = enemy.currentSpriteDie1 + 10 * dt
        if enemy.currentSpriteDie1 >= 8 then
            enemy.currentSpriteDie1 = 8
        end 

        -- Fase 2
        -- Animação Parado
        enemy.currentSpriteIdle2 = enemy.currentSpriteIdle2 + 10 * dt
        if enemy.currentSpriteIdle2 >= 8 then
            enemy.currentSpriteIdle2 = 1
        end   
        
        -- Animação do esqueleto
        enemy.currentSpriteAttack2 = enemy.currentSpriteAttack2 + 10 * dt
        if enemy.currentSpriteAttack2 >= 13 then
            enemy.currentSpriteAttack2 = 1
        end 

        -- Animação de morte
        enemy.currentSpriteDie2 = enemy.currentSpriteDie2 + 10 * dt
        if enemy.currentSpriteDie2 >= 7 then
            enemy.currentSpriteDie2 = 7
        end 
    end
    
    return self
end
