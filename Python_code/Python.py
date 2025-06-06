import random
import time
import urllib.parse


class LinkChecksumError(Exception):
    pass


class LinkParserError(Exception):
    pass


class BaseLink:
    HOST = 'link.hackersthegame.com'
    PORT = 443

    def __init__(self, id_):
        self.id = id_
        self.uri = ""

    def encode(self, value, timestamp):
        rand = random.randint(100, 999)
        data = (value + rand) ^ timestamp
        data_str = str(data)
        time_str = str(timestamp)

        i = 0
        while i < len(data_str) and i < len(time_str) and data_str[i] == time_str[i]:
            i += 1

        return {
            'value': data_str[i:],
            'timestamp': time_str[i:][::-1],
            'common': data_str[:i],
            'random': str(rand),
            'checksum': str(self.checksum(int(data_str))),
            'data': data_str
        }

    def decode(self, data):
        time = int(data['common'] + data['timestamp'][::-1])
        value = int(data['common'] + data['value'])
        if int(data['checksum']) != self.checksum(value):
            raise LinkChecksumError("Checksum error")

        decoded = (value ^ time) - int(data['random'])

        return {
            'value': decoded,
            'timestamp': time
        }

    def checksum(self, data):
        if data < 1:
            return 700
        acc = 0
        while data > 9:
            acc += data % 10
            data //= 10
        return -acc * 7 + 700 - 7


class SimLink(BaseLink):
    URI_SIMLINK = "/simlink.php"
    PARAMS = ['p', 't', 'c', 'q', 's']

    def generate(self):
        now = int(time.time() * 1000)
        data = self.encode(self.id, now)
        query = urllib.parse.urlencode({
            'p': data['value'],
            't': data['timestamp'],
            'c': data['common'],
            'q': data['random'],
            's': data['checksum']
        })

        self.uri = f"https://{self.HOST}:{self.PORT}{self.URI_SIMLINK}?{query}"
        return self.uri


# Example usage:
id_input = 9658358
link = SimLink(id_input)
print(link.generate())
