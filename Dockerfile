
FROM ubuntu:focal
LABEL org.opencontainers.image.source https://github.com/rennochj/deven
LABEL org.opencontainers.image.description "A base development environment"

ARG USER=deven-user

RUN apt update && apt upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt -y install python3.8 python3-pip openssh-server docker.io docker wget curl zsh unzip vim snap sudo

# Create vscode user --------------------------------------------------------------------------------------------------

RUN ssh-keygen -A && mkdir -p /run/sshd
EXPOSE 22

RUN echo "PasswordAuthentication no" > /etc/ssh/sshd_config.d/deven.conf \
    && echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config.d/deven.conf \
    && echo "ChallengeResponseAuthentication yes" >> /etc/ssh/sshd_config.d/deven.conf \
    && echo "PermitRootLogin no" >> /etc/ssh/sshd_config.d/deven.conf \
    && echo "UsePAM no" >> /etc/ssh/sshd_config.d/deven.conf

RUN groupadd --gid 1000 $USER \
    && useradd --uid 1000 --gid 1000 --shell /bin/zsh -m $USER -d /home/$USER \
    && echo $USER ALL=\(root\) NOPASSWD:ALL >> /etc/sudoers \
    && chmod 0440 /etc/sudoers \
    && echo "$USER:$(echo $RANDOM | md5sum | head -c 20; echo;)" | chpasswd
    
RUN usermod -a -G docker $USER

RUN mkdir /home/$USER/.ssh && chmod 700 /home/$USER/.ssh \
    && touch /home/$USER/.ssh/authorized_keys && chmod 600 /home/$USER/.ssh/authorized_keys \
    && chown $USER /home/$USER/.ssh && chown $USER /home/$USER/.ssh/authorized_keys

CMD ["/usr/sbin/sshd","-D"]
