local status_ok, job = pcall(require, "plenary.job")
if not status_ok then
  return
end

job:new({
  command = 'op',
  args = { 'item', 'get', 'OpenAI-API', '--fields', 'label=credential' },
  cwd = '/usr/bin',
  on_stdout = function(_, return_val)
    vim.g.codegpt_openai_api_key = return_val
    require("codegpt.config")
    vim.g.codegtp_commands_defaults = {
      model = "code-davinci-002"
    }
  end,
  on_stderr = function(_, data)
    vim.notify("Failed to load OpenAI credential:" .. data, vim.log.levels.ERROR)
  end,
}):sync(15000, 5000)
