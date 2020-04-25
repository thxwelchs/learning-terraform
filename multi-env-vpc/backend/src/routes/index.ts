import { Router, Request, Response }  from 'express'

const router = Router()

router.get('/', (req: Request, res: Response) => {
    res.status(200).json({ msg: 'Hello~~~' })
})

router.get('/healthz', (req: Request, res: Response) => {
    res.status(200).json({ msg: 'health check'})
})

export default router
