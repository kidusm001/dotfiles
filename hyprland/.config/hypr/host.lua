-- Machine-specific overrides.
-- Picks hosts/<name>.lua based on the hardware model so each PC keeps its own
-- monitors, GPU env, startup apps, etc. Unknown machines get {} (shared config only).

local hosts_by_product = {
	["Alienware m17 R5 AMD"] = "hosts/alienware",
}

local function product_name()
	local f = io.open("/sys/class/dmi/id/product_name", "r")
	if not f then
		return nil
	end
	local name = f:read("*l")
	f:close()
	return name
end

local module = hosts_by_product[product_name() or ""]
if not module then
	return {}
end
return require(module)
