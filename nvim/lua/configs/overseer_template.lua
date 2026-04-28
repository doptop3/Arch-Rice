local M = {}

function M.setup()
    local overseer = require("overseer")

    overseer.register_template({
        name = "ProjectBuild", -- Using a unique name to avoid "Run" collisions
        generator = function(opts, cb)
            local tasks = {}
            
            -- 1. Project Detection
            local root_match = vim.fs.find({ "bin", ".venv", ".git", "Makefile", "package.json" }, { upward = true, path = vim.fn.expand("%:p:h") })[1]
            local project_root = root_match and vim.fn.fnamemodify(root_match, ":h") or vim.fn.getcwd()
            
            local file_ext = vim.fn.expand("%:e")
            local full_path = vim.fn.expand("%:p")
            local build_script = project_root .. "/bin/build.sh"

            -- 2. Build Scripts & Makefiles
            if vim.loop.fs_stat(build_script) then
                table.insert(tasks, { 
                    name = "Bash: bin/build.sh", 
                    cmd = { "bash", build_script }, 
                    cwd = project_root 
                })
            end

            if vim.loop.fs_stat(project_root .. "/Makefile") then
                table.insert(tasks, { name = "Make: Compile", cmd = { "make" }, cwd = project_root })
            end

            -- 3. Language Specific Fallbacks
            local lang_map = {
                py = { name = "Python: Run File", cmd = { "python3", full_path } },
                java = { name = "Java: Run File", cmd = { "java", full_path } },
                js = { name = "Node: Run File", cmd = { "node", full_path } },
                c = { name = "C: Compile & Run", cmd = { "gcc", full_path, "-o", "out", "&&", "./out" } },
                cpp = { name = "C++: Compile & Run", cmd = { "g++", full_path, "-o", "out", "&&", "./out" } },
            }

            if lang_map[file_ext] then
                table.insert(tasks, lang_map[file_ext])
            end

            -- 4. Global Settings (Auto-save and Quickfix)
            for _, task in ipairs(tasks) do
                task.pre_cmds = { "wa" } 
                task.components = { { "on_output_quickfix", open = true }, "default" }
            end

            cb(tasks)
        end,
    })
end

return M
