local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- add plugins
require("lazy").setup({
  { 'neoclide/coc.nvim', branch = 'release' },

  { 'akinsho/toggleterm.nvim', 
    version = "*", 
    config = function()
      require("toggleterm").setup({
        size = 15, -- Default height
        open_mapping = [[<c-\>]], -- Optional: toggle with Ctrl-\
        hide_numbers = true, 
        shade_terminals = true, -- Darkens the terminal slightly to separate from code
        shading_factor = 2, 
        start_in_insert = true,
        persist_size = true, -- Remember how much you dragged it!
        direction = 'horizontal',
        -- Styling
        highlights = {
          Normal = {
            link = "Normal", -- Change "Normal" to "NormalFloat" for a different look
          },
          NormalFloat = {
            link = "Normal",
          },
        },
      })
    end 
  },
  { 'nvim-neo-tree/neo-tree.nvim', branch = 'v3.x', 
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
      config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
      })
    end
  },
  { 'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          theme = 'auto',
          icons_enabled = true, 
        }
      })
    end
  },
  { 'ellisonleao/gruvbox.nvim', priority = 1000,
    config = function()
      require("gruvbox").setup({
	options = { 
	  terminal_colors = true,
	  contrast = "hard",
      	  transparent_mode = false,
	}
      })
    end
  },
  { 'stevearc/overseer.nvim',
    config = function()
      local overseer = require("overseer")
      overseer.setup({ strategy = "toggleterm" })

      -- Global function handling all build/run logic
      _G.RunProjectBuild = function()
        local full_path = vim.fn.expand("%:p")
        local file_ext = vim.fn.expand("%:e")
        
        -- 1 Project Root Detection
        local root_match = vim.fs.find({ "bin", ".git", "Makefile", "package.json", ".venv" }, { 
          upward = true, 
          path = vim.fn.expand("%:p:h") 
        })[1]
        local project_root = root_match and vim.fn.fnamemodify(root_match, ":h") or vim.fn.getcwd()
        
        local build_script = project_root .. "/bin/build.sh"
        local makefile = project_root .. "/Makefile"

        -- 2 Determine Command (Priority: build.sh > Makefile > Language Fallback)
        local cmd = nil
        local task_name = "Project Build"

        if vim.loop.fs_stat(build_script) then
            cmd = { "bash", build_script }
            task_name = "Bash: bin/build.sh"
        elseif vim.loop.fs_stat(makefile) then
            cmd = { "make" }
            task_name = "Make: Compile"
        else
            -- Language Fallbacks
            local lang_map = {
                py   = { name = "Python: Run", cmd = { "python3", full_path } },
                java = { name = "Java: Run",   cmd = { "java", full_path } },
                js   = { name = "Node: Run",   cmd = { "node", full_path } },
                c    = { name = "C: Build",    cmd = { "gcc", full_path, "-o", "out", "&&", "./out" } },
                cpp  = { name = "C++: Build",  cmd = { "g++", full_path, "-o", "out", "&&", "./out" } },
            }

            if lang_map[file_ext] then
                cmd = lang_map[file_ext].cmd
                task_name = lang_map[file_ext].name
            end
        end

        -- 3 Execute if a command was found
        if cmd then
            vim.cmd("wa") -- Auto-save
            
            -- Convert the table { "python3", "-u", "file.py" } to a string
            local cmd_str = table.concat(cmd, " ")
            
            -- Call ToggleTerm directly:
            -- exec(cmd, id, size, dir, direction)
            require("toggleterm").exec(cmd_str, 1, 15, project_root, "horizontal")
        else
            print("No build script or language runner found for ." .. file_ext)
        end
      end
    end,
  },
  -- more plugins here
})
