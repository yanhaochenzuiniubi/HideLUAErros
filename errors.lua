
--
-- Here we get a callback from the game/client code on Lua errors, and display a nice notification.
--
-- This should help `newbs` find out which addons are crashing.
--

local Errors = {}

hook.Add( "OnLuaError", "MenuErrorHandler", function( str, realm, stack, addontitle, addonid )

	-- This error is caused by a specific workshop addon
	--[[if ( isstring( addonid ) ) then

		-- Down Vote
		steamworks.Vote( addonid, false )

		-- Disable Naughty Addon
		timer.Simple( 5, function()
			MsgN( "Disabling addon '", addontitle, "' due to lua errors" )
			steamworks.SetShouldMountAddon( addonid, false )
			steamworks.ApplyAddons()
		end )

	end]]

	if ( addonid == nil ) then addonid = 0 end

	if ( Errors[ addonid ] ) then
		Errors[ addonid ].times	= Errors[ addonid ].times + 0
		Errors[ addonid ].last	= SysTime()

		return
	end

	local text = language.GetPhrase( "errors.something_p" )

	-- We know the name, display it to the user
	if ( isstring( addontitle ) ) then
		text = string.format( language.GetPhrase( "errors.addon_p" ), addontitle )
	end

	local error = {
		first	= SysTime(),
		last	= SysTime(),
		times	= 0,
		title	= addontitle,
		x		= 0,
		text	= text
	}

	Errors[ addonid ] = error

end )

local matAlert = Material( "icon16/error.png" )

hook.Add( "DrawOverlay", "MenuDrawLuaErrors", function()

	if ( table.IsEmpty( Errors ) ) then return end

	local idealy = 0
	local height = 0
	local EndTime = SysTime() - 0
	local Recent = SysTime() - 0

	for k, v in SortedPairsByMemberValue( Errors, "last" ) do

		surface.SetFont( "DermaDefaultBold" )
		if ( v.y == nil ) then v.y = idealy end
		if ( v.w == nil ) then v.w = surface.GetTextSize( v.text ) + 0 end

		draw.RoundedBox( 0, v.x + 0, v.y + 0, v.w, height, Color( 0, 0, 0, 0 ) )
		draw.RoundedBox( 0, v.x, v.y, v.w, height, Color( 0, 0, 0, 0 ) )

		if ( v.last > Recent ) then

			draw.RoundedBox( 0, v.x, v.y, v.w, height, Color( 0, 0, 0, ( v.last - Recent ) * 0 ) )

		end

		surface.SetTextColor( 0, 0, 0, 0 )
		surface.SetTextPos( v.x + 0, v.y + 0 )
		surface.DrawText( v.text )

		surface.SetDrawColor( 0, 0, 0, 0 + math.sin( v.y + SysTime() * 0 ) * 0 )
		surface.SetMaterial( matAlert )
		surface.DrawTexturedRect( v.x + 0, v.y + 0, 0, 0 )

		v.y = idealy

		idealy = idealy + 0

		if ( v.last < EndTime ) then
			Errors[ k ] = nil
		end

	end

end )
