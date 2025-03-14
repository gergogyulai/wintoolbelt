import { Hono } from 'hono'

const app = new Hono<{ Bindings: CloudflareBindings }>()

app.get('/', async (c) => {
  const userAgent = c.req.header('User-Agent')

  if (userAgent?.includes("PowerShell")) {
    const response = await fetch('https://raw.githubusercontent.com/gergogyulai/winwipe/main/public/wipe.ps1', {
      headers: { 'Content-Type': 'text/plain' }
    })

    return response
  } else {
    return c.text(
      `To run this script, use the following command in PowerShell:

      irm https://winwipe.gergo.cc | iex

      Check the docs at: https://winwipe.gergo.cc/docs`, 
      200
    )
  }
})

app.get("/docs", async (c) => {
  return c.redirect('https://github.com/gergogyulai/winwipe/blob/main/README.md', 301)
})

export default app
