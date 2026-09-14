import tailwindcss from '@tailwindcss/vite'
import react from '@vitejs/plugin-react'
import { defineConfig } from 'vite'

export default defineConfig({
  plugins: [react(), tailwindcss()],
  server: {
    port: 3001,
    proxy: {
      '/v1': {
        target: 'http://localhost:1234',
        changeOrigin: true,
        timeout: 600000,
        proxyTimeout: 600000,
        configure: (proxy) => {
          proxy.on('error', (err, _req, res) => {
            console.error('[proxy /v1]', err?.message ?? err)
            if ('writeHead' in res && typeof res.writeHead === 'function') {
              res.writeHead(502, { 'Content-Type': 'application/json' })
              res.end(JSON.stringify({ error: 'Proxy error', message: err?.message }))
            }
          })
        },
      },
    },
  },
})
