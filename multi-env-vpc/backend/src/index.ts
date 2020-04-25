import * as express from 'express'
const app = express()
const PORT = 8080

app.get('/api/', (req: express.Request, res: express.Response) => {
    res.status(200).json({ msg: 'Hello~~~' })
})

app.get('/api/healthz', (req: express.Request, res: express.Response) => {
    res.status(200).json({ msg: 'health check'})
})

app.listen(PORT, () => {
    console.log(`Node Backend App listening on port ${PORT}!`)
})