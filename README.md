# Dockerized simple alpine based server and client scripts usage


1. create a new Docker network:
	red@DESKTOP-BMBA0RL:~/plv/dckr$ docker network create mynetwork
	<!-- b9cb101b4fdebd8cd3ab8ff0a71ec0a515a7ea86a22d037c4f5842fc4a5fa5df -->
2. navigate to server folder and create Image based on Dockerfile:
	red@DESKTOP-BMBA0RL:~/plv/dckr/server$ docker build -t server_img ./
	<!-- [+] Building 1.3s (8/8) FINISHED                                                                                                             docker:default
	=> [internal] load .dockerignore                                                                                                                      0.0s
	=> => transferring context: 2B                                                                                                                        0.0s
	=> [internal] load build definition from Dockerfile                                                                                                   0.1s
	=> => transferring dockerfile: 193B                                                                                                                   0.0s
	=> [internal] load metadata for docker.io/library/alpine:latest                                                                                       0.0s
	=> [internal] load build context                                                                                                                      0.0s
	=> => transferring context: 174B                                                                                                                      0.0s
	=> CACHED [1/3] FROM docker.io/library/alpine:latest                                                                                                  0.0s
	=> [2/3] COPY server.sh /home/root/server.sh                                                                                                          0.0s
	=> [3/3] RUN chmod +x /home/root/server.sh                                                                                                            0.7s
	=> exporting to image                                                                                                                                 0.1s
	=> => exporting layers                                                                                                                                0.1s
	=> => writing image sha256:c82ba80b1b10f68de6482d9ff27f47ef9a693e928dbbc568271679f3306fea1a                                                           0.0s
	=> => naming to docker.io/library/server_img  -->                                                                                                        
3. run a container based on server_img (use --network to indicate network created in step 1):
	red@DESKTOP-BMBA0RL:~/plv/dckr/server$ docker container run -it -d --network mynetwork --name server server_img
	<!-- 18c776b3b51397c2f4b843a4519db0f87ddad92c9d5d6d9114f169560457e606 -->
4. navigate to client folder and create Image based on Dockerfile:
	red@DESKTOP-BMBA0RL:~/plv/dckr/client$ docker build -t client_img ./
	<!-- [+] Building 1.0s (8/8) FINISHED                                                                                                             docker:default
	=> [internal] load build definition from Dockerfile                                                                                                   0.0s
	=> => transferring dockerfile: 193B                                                                                                                   0.0s
	=> [internal] load .dockerignore                                                                                                                      0.0s
	=> => transferring context: 2B                                                                                                                        0.0s
	=> [internal] load metadata for docker.io/library/alpine:latest                                                                                       0.0s
	=> [internal] load build context                                                                                                                      0.0s
	=> => transferring context: 163B                                                                                                                      0.0s
	=> CACHED [1/3] FROM docker.io/library/alpine:latest                                                                                                  0.0s
	=> [2/3] COPY client.sh /home/root/client.sh                                                                                                          0.0s
	=> [3/3] RUN chmod +x /home/root/client.sh                                                                                                            0.5s
	=> exporting to image                                                                                                                                 0.1s
	=> => exporting layers                                                                                                                                0.1s
	=> => writing image sha256:160f9df66ff19c85e116dd958b8294dddcdcfa2f886df0e170a200eb262091c5                                                           0.0s
	=> => naming to docker.io/library/client_img                                                                                                          0.0s -->
5. run a container based on client_img (use --network to indicate network created in step 1):
	red@DESKTOP-BMBA0RL:~/plv/dckr/client$ docker container run -it -d --network mynetwork --name client client_img
	<!-- 366e0e9f0851ef01d19e07b0e2d8cd8ab1a65d127eaa98fb328a1f2bf77cf275 -->
6. Inspect the network created in the step 1 to verify both containers in the same network (note the server container IP address):
	red@DESKTOP-BMBA0RL:~/plv/dckr$ docker network inspect mynetwork
	<!-- ***
        "Containers": {
            "18c776b3b51397c2f4b843a4519db0f87ddad92c9d5d6d9114f169560457e606": {
                "Name": "server",
                "EndpointID": "7f47b61815a2f4919f8baadd5eecaef81f4a4e65ddaae6a412bd906197747430",
                "MacAddress": "02:42:ac:12:00:02",
                "IPv4Address": "172.18.0.2/16",
                "IPv6Address": ""
            },
            "366e0e9f0851ef01d19e07b0e2d8cd8ab1a65d127eaa98fb328a1f2bf77cf275": {
                "Name": "client",
                "EndpointID": "af9ffb4eb4a9727d25bf666d31d2f82885ec8a1a2f886ed85a48d15c7c7f67d5",
                "MacAddress": "02:42:ac:12:00:03",
                "IPv4Address": "172.18.0.3/16",
                "IPv6Address": ""
            }
        },
	*** -->
7. Execute the server.sh script:
	red@DESKTOP-BMBA0RL:~/plv/dckr/server$ docker exec -it server /home/root/server.sh
	<!-- listening on [::]:80 ... -->
8. Execute the client.sh script passing the server IP as an argument (in a separate terminal):
	red@DESKTOP-BMBA0RL:~/plv/dckr/client$ docker exec -it client /home/root/client.sh 172.18.0.2

In case of success:
server sends message to client "server received the message"
client sends mesage to server "message to the server"
to verify: type something into one of terminals with running server/client scripts - message will be delivered to other terminal


