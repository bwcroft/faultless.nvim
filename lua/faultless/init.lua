local M = {}

--- @class faultless.settings
--- @field bold? boolean Whether bold text is enabled or not (default: false)
--- @field standout? boolean Whether undercurl is enabled (default: false)
--- @field undercurl? boolean Whether undercurl is enabled (default: true)
M.settings = {
	bold = false,
	standout = false,
	undercurl = true,
}

--- @param settings faultless.settings
local function configure_highlights(settings)
	local highlights = {
		DiagnosticUnderlineError = "#FF0000",
		DiagnosticUnderlineWarning = "#E0C800",
		DiagnosticUnderlineInfo = "#00FFFF",
		DiagnosticUnderlineHint = "#00FF00",
	}

	for group, color in pairs(highlights) do
		vim.api.nvim_set_hl(0, group, {
			sp = color,
			bold = settings.bold,
			standout = settings.standout,
			underline = not settings.undercurl,
			undercurl = settings.undercurl,
		})
	end
end

local function configure_lsp_diagnostics()
	vim.diagnostic.config({
		float = {
			focus = false,
			border = "rounded",
		},
	})
	-- Add Border & Padding to Lsp Hover
	local hoverConfig = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "single",
		focusable = false,
	})
	vim.lsp.handlers["textDocument/hover"] = hoverConfig
end

function M.toggle_diagnostics()
  vim.diagnostic.open_float(nil, { focus = false })
end

--- @param settings faultless.settings
function M.setup(settings)
	M.settings = vim.tbl_extend("force", M.settings, settings or {})
	configure_highlights(M.settings)
	configure_lsp_diagnostics()
end

return M
