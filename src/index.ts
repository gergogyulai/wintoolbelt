import { Hono } from 'hono'
import { withUserAgentValidation } from './utils'
import { strings } from "./strings";

const app = new Hono<{ Bindings: CloudflareBindings }>()

const repo = 'https://raw.githubusercontent.com/gergogyulai/winwipe/main/public'

app.get('/', withUserAgentValidation(async () => {
  const response = await fetch(`${repo}/wipe.ps1`, {
    headers: { 'Content-Type': 'text/plain' }
  });
  return response;
}, { fallbackText: strings.wipeUseragentError }));

app.get('/select', withUserAgentValidation(async () => {
  const response = await fetch(`${repo}/menu.ps1`, {
    headers: { 'Content-Type': 'text/plain' }
  });
  return response;
}, { fallbackText: strings.selectUseragentError }));

app.get('/wipe', withUserAgentValidation(async () => {
  const response = await fetch(`${repo}/wipe.ps1`, {
    headers: { 'Content-Type': 'text/plain' }
  });
  return response;
}, { fallbackText: strings.wipeUseragentError }));

app.get('/veyon', withUserAgentValidation(async () => {
  const response = await fetch(`${repo}/veyon.ps1`, {
    headers: { 'Content-Type': 'text/plain' }
  });
  return response;
}, { fallbackText: strings.veyonUseragentError }));

app.get("/docs", async (c) => {
  return c.redirect('https://github.com/gergogyulai/winwipe/blob/main/README.md', 301)
})

export default app
