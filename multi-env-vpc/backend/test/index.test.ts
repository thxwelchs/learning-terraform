import * as request from 'supertest'
import { expect } from 'chai'

import app from '../src'

describe('GET /api/', () => {
    it('응답 메세지가 Hello~~~ 인지 테스트', (done) => {
        request(app)
            .get(('/api/'))
            .expect(200)
            .end((err, res) => {
                if(err) {
                    done(err)
                    return
                }

                expect(res.body.msg).to.equal('Hello~~~')
                done()
            })
    })
})

describe('GET /api/healthz', () => {
    it('헬스 체크 테스트', (done) => {
        request(app)
            .get(('/api/'))
            .expect(200)
            .end((err, res) => {
                if(err) {
                    done(err)
                    return
                }

                expect(res.status).to.equal(200)
                done()
            })
    })
})