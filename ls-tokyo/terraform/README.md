## After Install

Lightsail 인스턴스에 접속 후 다음을 실행한다.

```bash
# 모든 init script가 실행되었는지 확인
tail -f /var/log/cloud-init-output.log

# Tailscale 계정 연결
sudo tailscale up
```
