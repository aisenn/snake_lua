timer = {t = os.time(), t2 = os.time()}

function timer:sleep(s)
    local ntime = os.clock() + s / 10
    repeat until os.clock() > ntime
end

function timer:diff()
    if ( os.difftime(os.time(), timer.t) > 0 ) then
        timer.t = os.time()
        return true
    else
        return false
    end
end


-- td = {  left = right,
--         right = left,
--         down = up,
--         up = down
--         }

--         dir = down

--     if td[left] ~= dir then

--     end



