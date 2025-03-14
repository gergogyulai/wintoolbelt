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
    return c.text('To run this script, use the following command in PowerShell:\n\nirm https://winwipe.gergo.cc | iex \n\n\ Check the docs at: "https://winwipe/gergo.cc/docs', 200)
  }
})

app.get("/docs", async (c)=>{
  c.redirect('https://github.com/gergogyulai/winwipe', 301)
})


export default app