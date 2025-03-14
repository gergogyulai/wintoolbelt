import { Hono } from 'hono'

const app = new Hono<{ Bindings: CloudflareBindings }>()

app.get('*', async (c) => {
  const response = await fetch('https://raw.githubusercontent.com/gergogyulai/winwipe/main/public/wipe.ps1', {
    headers: { 'Content-Type': 'text/plain' }
  })
  return response
})


export default app