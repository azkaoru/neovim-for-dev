	local startify = require("alpha.themes.startify")

	-- available: devicons, mini, default is mini
	-- if provider not loaded and enabled is true, it will try to use another provider
	startify.file_icons.provider = "devicons"

        -- startify.nvim_web_devicons.enabled = false

	local logo = {
        [[                                  __]],
        [[     ___     ___    ___   __  __ /\_\    ___ ___]],
        [[    / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\]],
        [[   /\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \]],
        [[   \ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
        [[    \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
		[[                                                           ]],
		[[                 ;i...                                     ]],
		[[                  MSL                    .;i.]],
		[[                  MSY;                .;iii;;.]],
		[[                 ;SYYSi._           .iiii;;;;;]],
		[[                .iiiYYYYYYiiiii;;;;i;iii;; ;;;]],
		[[              .;iYYYYYYiiiiiiYYYiiiiiii;;  ;;;]],
		[[           .YYYYSSSSYYYYYYYYYYYYYYYYiii;; ;;;;]],
		[[         .YYYSSSSSSYYYYYYSSSSiiiYSSSSSSSii;;;;]],
		[[        .YYYF`h  TYYYYYSSSSSYYYYYYYiSSSSSiiiiii]],
		[[        YSMM  .  .YYYYSSSS;;;SSTSYYMMMMMMMMiiYY.]],
		[[     `.;SSMSSb..dYYSSYi; .(     .YYMMMSSSMMMMYY]],
		[[   .._SMMMMMS!YYYYYYYYYi;.SSS  .;iiMMMSMMMMMMMYY]],
		[[    ._SMMMP. .ZZ.4SSSSSiiiiiiiiSMMMMMMMMMMMMMY;]],
		[[     MMMMS:       :SSSSSSSMMMMMMMMMMMSSMMMMMMMYYL]],
		[[    :MMMMSS.    .;PPbSSSSMMMMMMMMMMSSSSMMMMMMiYYU:]],
		[[     iMMSS;;: ;;;;iSSSSSSSMMMMMSSSSMMMMMMMMMMYYYYY]],
		[[     `SSSSi .. ``:iiii!SS``.SSSSSSSSSMMMMMMMSYiYYY]],
		[[      :YSSiii;;;.. ` ..;;iSSSSSSSSSMMMMMMSSYYYYiYY:]],
		[[       :SSSSSiiiiiiiSSSSSSSSSSSMMMMMMMMMMYYYYiiYYYY.]],
		[[        `SSSSSSSSSSSSSSSSSSSSMMMMMMMMSYYYYYiiiYYYYYY]],
		[[         YYSSSSSSSSSSSSSSSSMMMMMMMSSYYYiiiiiiYYYYYYY]],
		[[        :YYYYYYSSSSSSSSSSSSSSSSSSYYYYYYYiiiiYYYYDEAR 半蔵]],

	}


	startify.section.header.val = logo

        -- startify.section.header.opts.position = "center"

      -- center the buttons
      -- startify.section.top_buttons.val =
      --   { startify.button('e', '  New file', '<CMD>ene <BAR> startinsert <CR>'), startify.button('q', '󰅚  Quit NVIM', '<CMD>qa<CR>') }
      --




	require("alpha").setup(
	startify.config
	)
