

---@param tbl table
---@param indent integer
local function printTable(tbl, indent)
    indent = indent or 0
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            print(string.rep("  ", indent) .. tostring(k) .. ":")
            printTable(v, indent + 1)
        else
            print(string.rep("  ", indent) .. tostring(k) .. ": " .. tostring(v))
        end
    end
end

_G.printTable = printTable