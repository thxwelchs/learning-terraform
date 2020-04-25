import * as express from 'express'
import * as bodyParser from 'body-parser'
import router from './routes'
const PORT = 8080

class App {
    app: express.Application

    constructor() {
        this.app = express()
        this.config()
        this.app.use(`/api`, router)
        this.app.listen(PORT, () => {
            console.log(`Node Backend App listening on port ${PORT}!`)
        })
    }

    private config(): void {
        this.app.use(bodyParser.json())
    }
}

export default new App().app

