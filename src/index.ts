import { Hono } from 'hono'
import { withUserAgentValidation } from './utils'

const app = new Hono<{ Bindings: CloudflareBindings }>()

app.get('/', withUserAgentValidation(async () => {
  const response = await fetch('https://raw.githubusercontent.com/gergogyulai/winwipe/main/public/wipe.ps1', {
    headers: { 'Content-Type': 'text/plain' }
  });
  return response;
}));

app.get("/docs", async (c) => {
  return c.redirect('https://github.com/gergogyulai/winwipe/blob/main/README.md', 301)
})

export default app
