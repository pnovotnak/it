# it

A docker container with stuff for humans

The idea with this container image is that it has some common tools that I use for interactive debugging sessions and hacking around. With this image I can jump into a session quickly, even if I have to install a few extra tools for debugging specific issues.

# Running

## Kubernetes

The default entrypoint is `tmux`. This means that we can run the image under kubernetes if we set the `tty` option. To jump into the container, run `kubectl exec -it <pod> tmux attach`. Detatch by simply closing your terminal window. This leaves processes running in the cgroup and doesn't kill the container. Do note that if you `kubectl attach` instead, you _will_ cause the session to end and the cgroup to be restarted. You'll probably want to add `priviliged` to the container options if you are debugging.

## Docker

When debugging processes in another container on a Docker host, use the following command line:

    docker run --pid container:<container_id> --ipc container:<container_id> --privileged -it pnovotnak/it

This will allow you to strace procs in the target container. If you want to debug other processes on the host, use the following instead:

    docker run --pid host --ipc host --net host --privileged -it pnovotnak/it
