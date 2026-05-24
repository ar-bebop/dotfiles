vim.diagnostic.config({
  severity_sort = true,
  underline = true,
  update_in_insert = false,
  virtual_text = { spacing = 2, source = 'if_many' },
  float = { border = 'single', source = 'always' },
})
