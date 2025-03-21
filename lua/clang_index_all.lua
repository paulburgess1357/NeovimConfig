local function process_files(files, idx)
  idx = idx or 1
  if idx > #files then
    print(string.format("Preloaded %d C++ files for clangd indexing.", #files))
    return
  end
  local file = files[idx]
  print(string.format("Indexing file %d/%d: %s", idx, #files, file))
  vim.cmd("silent edit " .. vim.fn.fnameescape(file))
  -- Wait 1000ms (adjust as needed) to give clangd time to process the file.
  vim.defer_fn(function()
    vim.cmd("silent bdelete")
    process_files(files, idx + 1)
  end, 1000)
end

local function preload_cpp_files()
  local cwd = vim.fn.getcwd()
  local handle = io.popen("find " .. cwd .. " -type f -name '*.cpp'")
  if not handle then
    print("Failed to execute find command.")
    return
  end
  local result = handle:read("*a")
  handle:close()

  local files = {}
  for file in string.gmatch(result, "[^\r\n]+") do
    table.insert(files, file)
  end

  if #files == 0 then
    print("No .cpp files found.")
    return
  end

  process_files(files)
end

vim.api.nvim_create_user_command('ClangIndexAll', preload_cpp_files, {
  desc = 'Preload all C++ files to index clangd symbols'
})

