# Nodejs Media Server
* Github
https://github.com/illuspas/Node-Media-Server
npm start
http://IP:8000/admin/
帳密: admin/admin

* ffmpeg
ffmpeg -re -i test1.mp4 -c copy -f flv rtmp://localhost/live/streamName

* OBS
https://medium.com/@hzc1033/%E8%87%AA%E8%A1%8C%E5%BB%BA%E7%BD%AE-node-media-server-ec2-cloudfront-%E7%9A%84%E5%AF%A6%E4%BD%9C-f00dfc7e8584
rtmp://ip:1935/live

* html
<!-- <script src="https://cdn.bootcss.com/flv.js/1.4.2/flv.min.js"></script> -->
<script src="./flv.js"></script>
<video controls id="video"></video>

<input type="text" />
<button id="load">Load</button>
<script>
    const video = document.getElementById('video');
    const target = document.querySelector("input").value;
    const flvPlayer = flvjs.createPlayer({
        type: 'flv',
        url: `http://35.194.253.74:8000/live/mark.flv`
    });
    flvPlayer.attachMediaElement(video)
    flvPlayer.load();
    flvPlayer.play();
</script>