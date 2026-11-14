-- Hyprvim bootstrap
local path = os.getenv('HOME')
  .. '/.local/share/hyprland/lua/plugins/hyprvim/init.lua'

-- Not installed on this machine: no-op so the rest of the config still loads
local f = io.open(path, 'r')
if not f then
  return { setup = function() end }
end
f:close()

local chunk, err = loadfile(path)

if not chunk then
  error(err)
end

return chunk()
