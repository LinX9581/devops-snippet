import http from 'k6/http';
import { check, group, sleep } from 'k6';

export let options = {
    stages: [
        { duration: '5m', target: 5000 },
        { duration: '5m', target: 5000 },
        { duration: '2m', target: 0 },
    ],
};

let isLogin = false

export default function() {
    group('login', () => {
        if (!isLogin) {
            let loginRes = http.post(`https://api.example.com/v1/login/`, {
                username: `user_${__VU}`,
                password: 'pwd',
            });
            isLogin = true

            check(loginRes, { 'logged in successfully': (resp) => resp.json('token') !== '' });
        }
    })

    group('get something', () => {
        let res = http.get(`https://api.example.com/v1/something`, {
            headers: {
                Authorization: `Bearer ${loginRes.json('token')}`,
            },
        }).json();
        check(res, { 'status was 204': (r) => r.status === 204 });
    })

    sleep(10);
}