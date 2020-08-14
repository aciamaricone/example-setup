useradd bastion-user -p ''
mkdir -p /home/bastion-user/.ssh
chown -R bastion-user:bastion-user /home/bastion-user/.ssh
bash -c 'echo "GatewayPorts yes" >> /etc/ssh/sshd_config'
bash -c 'echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDL9oOy/boOQZ/R8u8u74KP2Z0PCHCTLOAf1fTTp6WbGmG0fuD4EVW65Hp7LNekeyez8PAcGkGH6P7O9LxUlf+zR6/NyxrEjYhTdi+AsnXhisrMpLYbeFPzCMWK3VQt3ps+lzkhds7J+datELl8njsJcITTQnCJbUNDni6iNkf5GYYKvp7fLHTsXhSEW/CsmPzkUt/B8k/rm1q6QKio6nQg3cvZ3Z/fc1SqLVRtdGU9WaS7hQl1XTqBhXCkQxDwxFEIj7nxGta3+LqkZHr3kkKYKZl5mwYX8axRt7otcZ1qWRrWp827fvdLI6G9sr4DXgPiN4emxCboV6BRb21s0QAl Qubole-tunnelSsh-key-US" >> /home/bastion-user/.ssh/authorized_keys'
sudo service sshd restart