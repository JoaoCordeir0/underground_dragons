local LG = love.graphics
local LK = love.keyboard
local LM = love.mouse

ClasseEnemy = {}

ClasseEnemy.new = function(enemy)
    local self = self or {}

    self.enemy = enemy

    -- Renderiza o boss da fase 3
    self.RenderEnemyBoss = function(fase, faseEnemys)
        if faseEnemys[3] > 0 then
            if faseEnemys[4] then        
                LG.draw(
                    enemy.spriteSheetAttack4[math.floor(enemy.currentSpriteAttack4)],
                    faseEnemys[1],
                    faseEnemys[2],
                    0,
                    1,
                    1,
                    enemy.spriteSheetAttack4[1]:getWidth() / 2,
                    enemy.spriteSheetAttack4[1]:getHeight() / 2
                ) 
            else 
                LG.draw(
                    enemy.spriteSheetIdle4[math.floor(enemy.currentSpriteIdle4)],
                    faseEnemys[1],
                    faseEnemys[2],
                    0,
                    1,
                    1,
                    enemy.spriteSheetIdle4[1]:getWidth() / 2,
                    enemy.spriteSheetIdle4[1]:getHeight() / 2
                ) 
            end
        else 
            LG.draw(
                enemy.spriteSheetDie4[math.floor(enemy.currentSpriteDie4)],
                faseEnemys[1],
                faseEnemys[2],
                0,
                1,
                1,
                enemy.spriteSheetDie4[1]:getWidth() / 2,
                enemy.spriteSheetDie4[1]:getHeight() / 2
            )
        end
    end

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
        elseif fase == 3 then
            for i = 1, 12, 4 do          
                if faseEnemys[i + 2] > 0 then
                    if faseEnemys[i + 3] then        
                        LG.draw(
                            enemy.spriteSheetAttack3[math.floor(enemy.currentSpriteAttack3)],
                            faseEnemys[i],
                            faseEnemys[i + 1],
                            0,
                            1.3,
                            1.3,
                            enemy.spriteSheetAttack3[1]:getWidth() / 2,
                            enemy.spriteSheetAttack3[1]:getHeight() / 2
                        ) 
                    else 
                        LG.draw(
                            enemy.spriteSheetIdle3[math.floor(enemy.currentSpriteIdle3)],
                            faseEnemys[i],
                            faseEnemys[i + 1],
                            0,
                            1.3,
                            1.3,
                            enemy.spriteSheetIdle3[1]:getWidth() / 2,
                            enemy.spriteSheetIdle3[1]:getHeight() / 2
                        ) 
                    end
                else 
                    LG.draw(
                        enemy.spriteSheetDie3[math.floor(enemy.currentSpriteDie3)],
                        faseEnemys[i],
                        faseEnemys[i + 1],
                        0,
                        1.3,
                        1.3,
                        enemy.spriteSheetDie3[1]:getWidth() / 2,
                        enemy.spriteSheetDie3[1]:getHeight() / 2
                    )
                end
            end
        end
    end

    self.checkEnemyDie = function(faseEnemys)        
        for i = 1, 12, 4 do
            if faseEnemys[i + 2] > 0 then
                return false
            end
        end
        return true        
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
        table.insert(enemy.spriteSheetIdle2, LG.newImage('Insumos/Enemy/Skeleton Shield/idle/skeleton_shield_idle_0.png'))
        table.insert(enemy.spriteSheetIdle2, LG.newImage('Insumos/Enemy/Skeleton Shield/idle/skeleton_shield_idle_1.png'))
        table.insert(enemy.spriteSheetIdle2, LG.newImage('Insumos/Enemy/Skeleton Shield/idle/skeleton_shield_idle_2.png'))
        table.insert(enemy.spriteSheetIdle2, LG.newImage('Insumos/Enemy/Skeleton Shield/idle/skeleton_shield_idle_3.png'))
        table.insert(enemy.spriteSheetIdle2, LG.newImage('Insumos/Enemy/Skeleton Shield/idle/skeleton_shield_idle_4.png'))
        table.insert(enemy.spriteSheetIdle2, LG.newImage('Insumos/Enemy/Skeleton Shield/idle/skeleton_shield_idle_5.png'))
        table.insert(enemy.spriteSheetIdle2, LG.newImage('Insumos/Enemy/Skeleton Shield/idle/skeleton_shield_idle_6.png'))
        table.insert(enemy.spriteSheetIdle2, LG.newImage('Insumos/Enemy/Skeleton Shield/idle/skeleton_shield_idle_7.png'))        

        -- Animação atacando
        table.insert(enemy.spriteSheetAttack2, LG.newImage('Insumos/Enemy/Skeleton Shield/attack/skeleton_shield_attack1_00.png'))
        table.insert(enemy.spriteSheetAttack2, LG.newImage('Insumos/Enemy/Skeleton Shield/attack/skeleton_shield_attack1_01.png'))
        table.insert(enemy.spriteSheetAttack2, LG.newImage('Insumos/Enemy/Skeleton Shield/attack/skeleton_shield_attack1_02.png'))
        table.insert(enemy.spriteSheetAttack2, LG.newImage('Insumos/Enemy/Skeleton Shield/attack/skeleton_shield_attack1_03.png'))
        table.insert(enemy.spriteSheetAttack2, LG.newImage('Insumos/Enemy/Skeleton Shield/attack/skeleton_shield_attack1_04.png'))
        table.insert(enemy.spriteSheetAttack2, LG.newImage('Insumos/Enemy/Skeleton Shield/attack/skeleton_shield_attack1_05.png'))
        table.insert(enemy.spriteSheetAttack2, LG.newImage('Insumos/Enemy/Skeleton Shield/attack/skeleton_shield_attack1_06.png'))
        table.insert(enemy.spriteSheetAttack2, LG.newImage('Insumos/Enemy/Skeleton Shield/attack/skeleton_shield_attack1_07.png'))
        table.insert(enemy.spriteSheetAttack2, LG.newImage('Insumos/Enemy/Skeleton Shield/attack/skeleton_shield_attack1_08.png'))
        table.insert(enemy.spriteSheetAttack2, LG.newImage('Insumos/Enemy/Skeleton Shield/attack/skeleton_shield_attack1_09.png'))
        table.insert(enemy.spriteSheetAttack2, LG.newImage('Insumos/Enemy/Skeleton Shield/attack/skeleton_shield_attack1_10.png'))
        table.insert(enemy.spriteSheetAttack2, LG.newImage('Insumos/Enemy/Skeleton Shield/attack/skeleton_shield_attack1_11.png'))
        table.insert(enemy.spriteSheetAttack2, LG.newImage('Insumos/Enemy/Skeleton Shield/attack/skeleton_shield_attack1_12.png'))

        -- Animação morto
        table.insert(enemy.spriteSheetDie2, LG.newImage('Insumos/Enemy/Skeleton Shield/die/skeleton_shield_die_00.png'))
        table.insert(enemy.spriteSheetDie2, LG.newImage('Insumos/Enemy/Skeleton Shield/die/skeleton_shield_die_01.png'))
        table.insert(enemy.spriteSheetDie2, LG.newImage('Insumos/Enemy/Skeleton Shield/die/skeleton_shield_die_02.png'))
        table.insert(enemy.spriteSheetDie2, LG.newImage('Insumos/Enemy/Skeleton Shield/die/skeleton_shield_die_03.png'))
        table.insert(enemy.spriteSheetDie2, LG.newImage('Insumos/Enemy/Skeleton Shield/die/skeleton_shield_die_04.png'))
        table.insert(enemy.spriteSheetDie2, LG.newImage('Insumos/Enemy/Skeleton Shield/die/skeleton_shield_die_05.png'))
        table.insert(enemy.spriteSheetDie2, LG.newImage('Insumos/Enemy/Skeleton Shield/die/skeleton_shield_die_06.png'))     
        
        -- fase 3 Dragão        
        -- Animação de ficar Parado
        table.insert(enemy.spriteSheetIdle3, LG.newImage('Insumos/Dragon/idle/idle_01.png'))
        table.insert(enemy.spriteSheetIdle3, LG.newImage('Insumos/Dragon/idle/idle_02.png'))
        table.insert(enemy.spriteSheetIdle3, LG.newImage('Insumos/Dragon/idle/idle_03.png'))
        table.insert(enemy.spriteSheetIdle3, LG.newImage('Insumos/Dragon/idle/idle_04.png'))
        table.insert(enemy.spriteSheetIdle3, LG.newImage('Insumos/Dragon/idle/idle_05.png'))
        table.insert(enemy.spriteSheetIdle3, LG.newImage('Insumos/Dragon/idle/idle_06.png'))

        -- Animação do dragão morto
        table.insert(enemy.spriteSheetDie3, LG.newImage('Insumos/Dragon/Dizzy/dizzy_01.png'))
        table.insert(enemy.spriteSheetDie3, LG.newImage('Insumos/Dragon/Dizzy/dizzy_02.png'))
        table.insert(enemy.spriteSheetDie3, LG.newImage('Insumos/Dragon/Dizzy/dizzy_03.png'))
        
        -- Animação do dragão atacando
        table.insert(enemy.spriteSheetAttack3, LG.newImage('Insumos/Dragon/Attack/attack_01.png'))
        table.insert(enemy.spriteSheetAttack3, LG.newImage('Insumos/Dragon/Attack/attack_02.png'))
        table.insert(enemy.spriteSheetAttack3, LG.newImage('Insumos/Dragon/Attack/attack_03.png'))      
        table.insert(enemy.spriteSheetAttack3, LG.newImage('Insumos/Dragon/Attack/attack_04.png'))      

        -- fase 3 - BOSS -
        -- Animação de ficar Parado
        table.insert(enemy.spriteSheetIdle4, LG.newImage('Insumos/Enemy/Skeleton Boss/idle/skeleton_boss_idle_00.png'))
        table.insert(enemy.spriteSheetIdle4, LG.newImage('Insumos/Enemy/Skeleton Boss/idle/skeleton_boss_idle_01.png'))
        table.insert(enemy.spriteSheetIdle4, LG.newImage('Insumos/Enemy/Skeleton Boss/idle/skeleton_boss_idle_02.png'))
        table.insert(enemy.spriteSheetIdle4, LG.newImage('Insumos/Enemy/Skeleton Boss/idle/skeleton_boss_idle_03.png'))
        table.insert(enemy.spriteSheetIdle4, LG.newImage('Insumos/Enemy/Skeleton Boss/idle/skeleton_boss_idle_04.png'))
        table.insert(enemy.spriteSheetIdle4, LG.newImage('Insumos/Enemy/Skeleton Boss/idle/skeleton_boss_idle_05.png'))
        table.insert(enemy.spriteSheetIdle4, LG.newImage('Insumos/Enemy/Skeleton Boss/idle/skeleton_boss_idle_06.png'))
        table.insert(enemy.spriteSheetIdle4, LG.newImage('Insumos/Enemy/Skeleton Boss/idle/skeleton_boss_idle_07.png'))        
        table.insert(enemy.spriteSheetIdle4, LG.newImage('Insumos/Enemy/Skeleton Boss/idle/skeleton_boss_idle_08.png'))        
        table.insert(enemy.spriteSheetIdle4, LG.newImage('Insumos/Enemy/Skeleton Boss/idle/skeleton_boss_idle_09.png'))        

        -- Animação de andando
        table.insert(enemy.spriteSheetRun4, LG.newImage('Insumos/Enemy/Skeleton Boss/run/skeleton_boss_run_00.png'))
        table.insert(enemy.spriteSheetRun4, LG.newImage('Insumos/Enemy/Skeleton Boss/run/skeleton_boss_run_01.png'))
        table.insert(enemy.spriteSheetRun4, LG.newImage('Insumos/Enemy/Skeleton Boss/run/skeleton_boss_run_02.png'))
        table.insert(enemy.spriteSheetRun4, LG.newImage('Insumos/Enemy/Skeleton Boss/run/skeleton_boss_run_03.png'))
        table.insert(enemy.spriteSheetRun4, LG.newImage('Insumos/Enemy/Skeleton Boss/run/skeleton_boss_run_04.png'))
        table.insert(enemy.spriteSheetRun4, LG.newImage('Insumos/Enemy/Skeleton Boss/run/skeleton_boss_run_05.png'))
        table.insert(enemy.spriteSheetRun4, LG.newImage('Insumos/Enemy/Skeleton Boss/run/skeleton_boss_run_06.png'))
        table.insert(enemy.spriteSheetRun4, LG.newImage('Insumos/Enemy/Skeleton Boss/run/skeleton_boss_run_07.png'))       
        table.insert(enemy.spriteSheetRun4, LG.newImage('Insumos/Enemy/Skeleton Boss/run/skeleton_boss_run_08.png'))       
        table.insert(enemy.spriteSheetRun4, LG.newImage('Insumos/Enemy/Skeleton Boss/run/skeleton_boss_run_09.png'))       
        table.insert(enemy.spriteSheetRun4, LG.newImage('Insumos/Enemy/Skeleton Boss/run/skeleton_boss_run_10.png'))       
        table.insert(enemy.spriteSheetRun4, LG.newImage('Insumos/Enemy/Skeleton Boss/run/skeleton_boss_run_11.png'))               
        
        -- Animação atacando
        table.insert(enemy.spriteSheetAttack4, LG.newImage('Insumos/Enemy/Skeleton Boss/attack/skeleton_boss_attack1_00.png'))
        table.insert(enemy.spriteSheetAttack4, LG.newImage('Insumos/Enemy/Skeleton Boss/attack/skeleton_boss_attack1_01.png'))
        table.insert(enemy.spriteSheetAttack4, LG.newImage('Insumos/Enemy/Skeleton Boss/attack/skeleton_boss_attack1_02.png'))
        table.insert(enemy.spriteSheetAttack4, LG.newImage('Insumos/Enemy/Skeleton Boss/attack/skeleton_boss_attack1_03.png'))
        table.insert(enemy.spriteSheetAttack4, LG.newImage('Insumos/Enemy/Skeleton Boss/attack/skeleton_boss_attack1_04.png'))
        table.insert(enemy.spriteSheetAttack4, LG.newImage('Insumos/Enemy/Skeleton Boss/attack/skeleton_boss_attack1_05.png'))
        table.insert(enemy.spriteSheetAttack4, LG.newImage('Insumos/Enemy/Skeleton Boss/attack/skeleton_boss_attack1_06.png'))
        table.insert(enemy.spriteSheetAttack4, LG.newImage('Insumos/Enemy/Skeleton Boss/attack/skeleton_boss_attack1_07.png'))
        table.insert(enemy.spriteSheetAttack4, LG.newImage('Insumos/Enemy/Skeleton Boss/attack/skeleton_boss_attack1_08.png'))
        table.insert(enemy.spriteSheetAttack4, LG.newImage('Insumos/Enemy/Skeleton Boss/attack/skeleton_boss_attack1_09.png'))
        table.insert(enemy.spriteSheetAttack4, LG.newImage('Insumos/Enemy/Skeleton Boss/attack/skeleton_boss_attack1_10.png'))
        table.insert(enemy.spriteSheetAttack4, LG.newImage('Insumos/Enemy/Skeleton Boss/attack/skeleton_boss_attack1_11.png'))
        table.insert(enemy.spriteSheetAttack4, LG.newImage('Insumos/Enemy/Skeleton Boss/attack/skeleton_boss_attack1_12.png'))
        table.insert(enemy.spriteSheetAttack4, LG.newImage('Insumos/Enemy/Skeleton Boss/attack/skeleton_boss_attack1_13.png'))
        table.insert(enemy.spriteSheetAttack4, LG.newImage('Insumos/Enemy/Skeleton Boss/attack/skeleton_boss_attack1_14.png'))
        table.insert(enemy.spriteSheetAttack4, LG.newImage('Insumos/Enemy/Skeleton Boss/attack/skeleton_boss_attack1_15.png'))
        table.insert(enemy.spriteSheetAttack4, LG.newImage('Insumos/Enemy/Skeleton Boss/attack/skeleton_boss_attack1_16.png'))
        table.insert(enemy.spriteSheetAttack4, LG.newImage('Insumos/Enemy/Skeleton Boss/attack/skeleton_boss_attack1_17.png'))
        table.insert(enemy.spriteSheetAttack4, LG.newImage('Insumos/Enemy/Skeleton Boss/attack/skeleton_boss_attack1_18.png'))

        -- Animação morto
        table.insert(enemy.spriteSheetDie4, LG.newImage('Insumos/Enemy/Skeleton Boss/die/skeleton_boss_die_00.png'))
        table.insert(enemy.spriteSheetDie4, LG.newImage('Insumos/Enemy/Skeleton Boss/die/skeleton_boss_die_01.png'))
        table.insert(enemy.spriteSheetDie4, LG.newImage('Insumos/Enemy/Skeleton Boss/die/skeleton_boss_die_02.png'))
        table.insert(enemy.spriteSheetDie4, LG.newImage('Insumos/Enemy/Skeleton Boss/die/skeleton_boss_die_03.png'))
        table.insert(enemy.spriteSheetDie4, LG.newImage('Insumos/Enemy/Skeleton Boss/die/skeleton_boss_die_04.png'))
        table.insert(enemy.spriteSheetDie4, LG.newImage('Insumos/Enemy/Skeleton Boss/die/skeleton_boss_die_05.png'))
        table.insert(enemy.spriteSheetDie4, LG.newImage('Insumos/Enemy/Skeleton Boss/die/skeleton_boss_die_06.png'))  
        table.insert(enemy.spriteSheetDie4, LG.newImage('Insumos/Enemy/Skeleton Boss/die/skeleton_boss_die_07.png'))  
        table.insert(enemy.spriteSheetDie4, LG.newImage('Insumos/Enemy/Skeleton Boss/die/skeleton_boss_die_08.png'))  
        table.insert(enemy.spriteSheetDie4, LG.newImage('Insumos/Enemy/Skeleton Boss/die/skeleton_boss_die_09.png'))  
        table.insert(enemy.spriteSheetDie4, LG.newImage('Insumos/Enemy/Skeleton Boss/die/skeleton_boss_die_10.png'))          
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

        -- Fase 3
        -- Animação Parado
        enemy.currentSpriteIdle3 = enemy.currentSpriteIdle3 + 10 * dt
        if enemy.currentSpriteIdle3 >= 6 then
            enemy.currentSpriteIdle3 = 1
        end   
        
        -- Animação do esqueleto
        enemy.currentSpriteAttack3 = enemy.currentSpriteAttack3 + 10 * dt
        if enemy.currentSpriteAttack3 >= 4 then
            enemy.currentSpriteAttack3 = 1
        end 

        -- Animação de morte
        enemy.currentSpriteDie3 = enemy.currentSpriteDie3 + 10 * dt
        if enemy.currentSpriteDie3 >= 3 then
            enemy.currentSpriteDie3 = 3
        end 

        -- Fase 3 Boss
        -- Animação Parado
        enemy.currentSpriteIdle4 = enemy.currentSpriteIdle4 + 10 * dt
        if enemy.currentSpriteIdle4 >= 10 then
            enemy.currentSpriteIdle4 = 1
        end   
        
        -- Animação do boss andando
        enemy.currentSpriteRun4 = enemy.currentSpriteRun4 + 10 * dt
        if enemy.currentSpriteRun4 >= 12 then
            enemy.currentSpriteRun4 = 1
        end 
        
        -- Animação do esqueleto
        enemy.currentSpriteAttack4 = enemy.currentSpriteAttack4 + 10 * dt
        if enemy.currentSpriteAttack4 >= 19 then
            enemy.currentSpriteAttack4 = 1
        end 

        -- Animação de morte
        enemy.currentSpriteDie4 = enemy.currentSpriteDie4 + 10 * dt
        if enemy.currentSpriteDie4 >= 11 then
            enemy.currentSpriteDie4 = 11
        end 
    end
    
    return self
end
