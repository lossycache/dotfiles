local function c(name, fn, opts)
  opts = opts or {}
  vim.api.nvim_create_user_command(name, fn, opts)
end

c(
  'CopyFileName',
  function()
    vim.fn.setreg('*', vim.fn.expand('%'))
  end
)

c(
  'Buffers',
  function()
    vim.api.nvim_command('Telescope buffers')
  end
)

c(
  'Symbols',
  function()
    vim.api.nvim_command('Telescope lsp_dynamic_workspace_symbols')
  end
)

c(
  'DocSymbols',
  function()
    vim.api.nvim_command('Telescope lsp_document_symbols')
  end
)

c(
  'Rename',
  function()
    vim.lsp.buf.rename()
  end
)

c(
  'Find',
  function()
    vim.api.nvim_command('NvimTreeFindFile')
  end
)

local function open_on_github(opts)
  opts = opts or {}

  local function git_firstline(args)
    local out = vim.fn.systemlist(args)
    if vim.v.shell_error ~= 0 or not out or not out[1] then return nil end
    return out[1]
  end

  local function urlencode_path(p)
    return (p:gsub("[^%w%-%._~/]", function(c) return string.format("%%%02X", c:byte()) end))
  end

  local function normalize_remote(u)
    if not u or u == "" then return nil end
    local host, path = u:match("^git@([^:]+):(.+)$")
    if host and path then
      path = path:gsub("%.git$", "")
      return string.format("https://%s/%s", host, path)
    end
    if u:match("^https?://") then
      return u:gsub("%.git$", "")
    end
    return nil
  end

  -- repo root
  local git_root = git_firstline({ "git", "rev-parse", "--show-toplevel" })
  if not git_root then
    vim.notify("Not inside a git repository", vim.log.levels.ERROR)
    return
  end

  -- file relative to root
  local abs = vim.fn.expand("%:p")
  local rel = git_firstline({ "git", "-C", git_root, "ls-files", "--full-name", abs })
  if not rel or rel == "" then
    local norm_abs = abs:gsub("\\", "/")
    local norm_root = git_root:gsub("\\", "/")
    rel = norm_abs:gsub("^" .. vim.pesc(norm_root) .. "/", "")
  end
  if not rel or rel == "" then
    vim.notify("Couldn't determine relative file path", vim.log.levels.ERROR)
    return
  end

  -- line fragment
  local l1 = tonumber(opts.line1) or vim.fn.line(".")
  local l2 = tonumber(opts.line2) or l1
  if l2 < l1 then l1, l2 = l2, l1 end
  local fragment = (l1 == l2)
      and string.format("#L%d", l1)
      or string.format("#L%d-L%d", l1, l2)

  -- get remote
  local remote = git_firstline({ "git", "remote", "get-url", "--push", "origin" }) or
      git_firstline({ "git", "remote", "get-url", "origin" })
  local base = normalize_remote(remote)
  if not base then
    vim.notify("Couldn't resolve remote URL", vim.log.levels.ERROR)
    return
  end

  -- determine default branch (origin/HEAD)
  local ref
  local origin_head = git_firstline({ "git", "symbolic-ref", "refs/remotes/origin/HEAD" })
  if origin_head then
    ref = origin_head:match("refs/remotes/origin/(.+)$")
  end
  if not ref or ref == "" then
    -- fallback to main, then master, then prod
    for _, fallback in ipairs({ "main", "master", "prod" }) do
      local exists = vim.fn.system({ "git", "ls-remote", "--heads", "origin", fallback })
      if exists and exists ~= "" then
        ref = fallback
        break
      end
    end
  end
  if not ref then
    vim.notify("Couldn't determine default branch", vim.log.levels.ERROR)
    return
  end

  -- build URL and open
  local url = string.format("%s/blob/%s/%s%s", base, ref, urlencode_path(rel), fragment)
  vim.fn.jobstart({ "open", url }, { detach = true })
end

c("OpenGithub", function(opts)
  open_on_github({ line1 = opts.line1, line2 = opts.line2 })
end, {
  range = true,
})
