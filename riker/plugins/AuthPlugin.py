from hashlib import sha1
from urllib import request, error
import json

from riker.proto.yggdrasil import Yggdrasil
from riker.PluginBase import PluginBase, pl_announce

class AuthCore:
  def __init__(self, io, event, online_mode, auth_timeout):
    self.event = event
    self.online_mode = online_mode
    self.auth_timeout = auth_timeout
    self.ygg = Yggdrasil()
    self._username = None
    self.login_error = event.register_event('auth_login_error')

  def set_username(self, username):
    self.ygg.username = username

  username = property(lambda: self._username, set_username)

  def set_password(self, password):
    self.ygg.password = password

  password = property(lambda x: bool(x.ygg.password), set_password)

  def login(self):
    if not self.online_mode:
      self._username = self.ygg.username
      return True
    if self.ygg.login():
      self._username = self.ygg.selected_profile['name']
      return True
    self.event.emit(self.login_error)


@pl_announce('Auth')
class AuthPlugin(PluginBase):
  requires = ('Event', 'IO')
  events = {
    'ClientboundEncryptionBegin': 'handle_session_auth'
  }
  defaults = {
      'online_mode': True,
      'auth_timeout': 3,  # No idea how long this should be, 3s seems good
      'auth_quit': True,
      'sess_quit': True,
  }

  def __init__(self, ploader, settings):
    super().__init__(ploader, settings)
    self.auth_timeout = self.settings['auth_timeout']
    self.core = AuthCore(self.io, self.event, self.auth_timeout,
        self.settings['online_mode'])
    ploader.provide('Auth', self.core)

  def handle_session_auth(self, event_id, packet):
    server_id = packet.serverId.encode('ascii') # Should be blank
    secret = self.io.shared_secret.tobytes()
    pubkey = packet.publicKey.tobytes()
    digest = sha1(server_id + secret + pubkey).digest()
    data = json.dumps({
      'accessToken': self.core.ygg.access_token,
      'selectedProfile': self.core.ygg.selected_profile,
      'serverId': format(int.from_bytes(digest, 'big', signed = True), 'x'),
    }).encode('utf-8')
    url = 'https://sessionserver.mojang.com/session/minecraft/join'
    req = request.Request(url, data, {'Content-Type': 'application/json'})
    try:
      rep = request.urlopen(req, timeout = self.auth_timeout
          ).read().decode('utf-8')
    except error.URLError:
      rep = "Couldn't connect to sessionserver.mojang.com"
    if rep:
      print(rep)
