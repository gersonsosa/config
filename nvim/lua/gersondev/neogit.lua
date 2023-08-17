local status_ok, neogit  = pcall(require, "neogit")
if not status_ok then
  return
end

neogit.setup {
  status = {
    recent_commit_count = 10,
  },
  integrations = {
    diffview = true
  }
}
