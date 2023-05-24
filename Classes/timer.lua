ClasseTimer = {}

ClasseTimer.new = function()
    local self = self or {}    
    
    self.gameTimer = function()
        -- Definido para 5 minutos
        local seconds
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
            return math.ceil(time / 60) - 1 .. ":" .. (seconds < 10 and 0 .. seconds or seconds)
        else
            return "Tempo esgotado"
        end
    end

    return self
end