local LG = love.graphics
local LK = love.keyboard
local LM = love.mouse

ClassePlayer = {}

ClassePlayer.new = function(player)
    local self = self or {}

    self.player = player

    -- Renderiza e executa animações do personagem
    self.RenderPlayer = function()
        if player.life == 1 then
            LG.draw(
                player.spriteSheetDie[math.floor(player.currentSpriteDie)],
                player.x,
                player.y,
                0,
                1,
                1,
                player.spriteSheetDie[1]:getWidth() / 2,
                player.spriteSheetDie[1]:getHeight() / 2
            )
        else
            if player.arma == 'hand' then
                if not LK.isDown('right') and
                    not LK.isDown('d') and
                    not LK.isDown('left') and
                    not LK.isDown('a') and
                    not LK.isDown('up') and
                    not LK.isDown('w') then
                    LG.draw(
                        player.spriteSheetIdle[math.floor(player.currentSpriteIdle)],
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
                            player.spriteSheetRun[math.floor(player.currentSpriteRun)],
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
                        player.spriteSheetJump[math.floor(player.currentSpriteJump)],
                        player.x,
                        player.y,
                        0,
                        1,
                        1,
                        player.spriteSheetJump[1]:getWidth() / 2,
                        player.spriteSheetJump[1]:getHeight() / 2
                    )
                end
            elseif player.arma == 'arco' then
                if not LK.isDown('right') and
                    not LK.isDown('d') and
                    not LK.isDown('left') and
                    not LK.isDown('a') and
                    not LK.isDown('up') and
                    not LK.isDown('w') and
                    not LM.isDown(1) then
                    LG.draw(
                        player.spriteSheetIdleBow[math.floor(player.currentSpriteIdleBow)],
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
                            player.spriteSheetRunBow[math.floor(player.currentSpriteRunBow)],
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
                        player.spriteSheetJumpBow[math.floor(player.currentSpriteJumpBow)],
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
                        player.spriteSheetAttackBow[math.floor(player.currentSpriteAttackBow)],
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

    self.RunThroughImages = function(dt)
        -- Animação personagem
        -- Animações sem armas
        -- Animação Corrida
        player.currentSpriteRun = player.currentSpriteRun + 10 * dt
        if player.currentSpriteRun >= 10 then
            player.currentSpriteRun = 1
        end

        -- Animação Parado
        player.currentSpriteIdle = player.currentSpriteIdle + 10 * dt
        if player.currentSpriteIdle >= 8 then
            player.currentSpriteIdle = 1
        end

        -- Animação Pulo
        player.currentSpriteJump = player.currentSpriteJump + 10 * dt
        if player.currentSpriteJump >= 2 then
            player.currentSpriteJump = 1
        end

        -- Animação de Morte
        player.currentSpriteDie = player.currentSpriteDie + 10 * dt
        if player.currentSpriteDie >= 9 then
            player.currentSpriteDie = 9
        end

        -- Animações com arco
        -- Animação Corrida com arco
        player.currentSpriteRunBow = player.currentSpriteRunBow + 10 * dt
        if player.currentSpriteRunBow >= 10 then
            player.currentSpriteRunBow = 1
        end

        -- Animação Parado com arco
        player.currentSpriteIdleBow = player.currentSpriteIdleBow + 10 * dt
        if player.currentSpriteIdleBow >= 8 then
            player.currentSpriteIdleBow = 1
        end

        -- Animação Pulo com arco
        player.currentSpriteJumpBow = player.currentSpriteJumpBow + 10 * dt
        if player.currentSpriteJumpBow >= 2 then
            player.currentSpriteJumpBow = 1
        end

        -- Animação Ataque com arco
        player.currentSpriteAttackBow = player.currentSpriteAttackBow + 10 * dt
        if player.currentSpriteAttackBow >= 15 then
            player.currentSpriteAttackBow = 1
        end
    end

    self.weaponInUse = function()
        if player.arma == 'arco' then
            return LG.draw(LG.newImage('Insumos/Objeto/icon_bow.png'), 290, 7)
        elseif player.arma == 'espada' then
            return LG.draw(LG.newImage('Insumos/Objeto/icon_sword.png'), 290, 7)
        end
    end
    
    self.LoadPlayerImages = function()
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
    
    return self
end
