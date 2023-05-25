ClasseTable = {}

ClasseTable.new = function()
    local self = self or {}    
    
    self.contains = function(table, value)
        for i = 1, #table do
            if table[i] == value then 
                return true
            end
        end
        return false
    end

    return self
end