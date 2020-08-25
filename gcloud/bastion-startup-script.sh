useradd bastion-user -p ''
mkdir -p /home/bastion-user/.ssh
chown -R bastion-user:bastion-user /home/bastion-user/.ssh
bash -c 'echo "GatewayPorts yes" >> /etc/ssh/sshd_config'
bash -c 'echo "ssh-rsa ... Qubole-tunnelSsh-key-US" >> /home/bastion-user/.ssh/authorized_keys'
sudo service sshd restart