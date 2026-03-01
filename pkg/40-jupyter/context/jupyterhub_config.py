c.Authenticator.allow_all = True
c.JupyterHub.bind_url = 'http://:8000/jupyter'
c.JupyterHub.base_url = '/jupyter/'

# WebSocket のタイムアウトを延ばす（秒単位）
c.JupyterHub.tornado_settings = {
    # 接続を維持する間隔を調整
    'websocket_ping_interval': 10,
    'websocket_ping_timeout': 30,
}
