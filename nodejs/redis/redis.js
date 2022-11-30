client.hget('users', new_user.username, function(err, id) {
    if (id !== null) {
        res.redirect('/sign-up?msg=Username Unavailable');
    } else {
        client.incr('new_user_id', function(err, user_id) {
            client.hmset('user:' + user_id, new_user); //存入多個 key value
            client.hset('users', new_user.username, user_id);
        })
    }
})