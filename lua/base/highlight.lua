local hl = vim.api.nvim_set_hl

-- hl(0, "Visual", { bg = "#FFE4B5", fg = "NONE" })
hl(0, "CustomCmpCursor", { fg = "NONE", bg = "#27302b", bold = true })
hl(0, "CustomCmpNormal", { fg = "#7A8B8B", bg = "NONE" })
hl(0, "CustomCmpMatch", { fg = "#FFFFFF", bg = "NONE", underline = true })
hl(0, "CustomCmpFuzzyMatch", { fg = "#EEE8AA", bg = "NONE", bold = true })
