-- function timer:diff()
--     timer.t2 = os.clock() - timer.t2
--     -- if ( os.difftime(os.time(), timer.t) > 0 ) then
--     if (timer.began < timer.t2) then
--         timer.began = os.clock()
--         return true
--     else
--         return false
--     end
-- end


timer = {t = os.time(), t2 = os.time()}

function timer:diff()
    if ( os.difftime(os.time(), timer.t) > 0 ) then
        timer.t = os.time()
        return true
    else
        return false
    end
end