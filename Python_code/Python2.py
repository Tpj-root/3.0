import time
import random
import urllib.parse

# Sample data from user
input_text = """Top country players
  ID           Name                      Experience   Country Rank        
  4101331      Double.G                  960595       118     1680        
  4527152      aslan                     952415       118     1590        
  4635062      Teetayorrrhhh             953330       118     1587"""

# Define the encoding and checksum algorithm
class BaseLink:
    HOST = 'link.hackersthegame.com'
    PORT = 443

    def __init__(self, id_):
        self.id = id_

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
        }

    def checksum(self, data):
        if data < 1:
            return 700
        acc = 0
        while data > 9:
            acc += data % 10
            data //= 10
        return -acc * 7 + 700 - 7

    def generate_link(self):
        now = int(time.time() * 1000)
        data = self.encode(self.id, now)
        query = urllib.parse.urlencode({
            'p': data['value'],
            't': data['timestamp'],
            'c': data['common'],
            'q': data['random'],
            's': data['checksum']
        })
        return f"https://{self.HOST}:{self.PORT}/simlink.php?{query}"

# Parse the text
lines = input_text.strip().split('\n')
players = []

for line in lines[2:]:
    parts = line.strip().split()
    if len(parts) >= 5:
        id_ = int(parts[0])
        name = " ".join(parts[1:-3])
        experience = parts[-3]
        country = parts[-2]
        rank = parts[-1]
        sim_link = BaseLink(id_).generate_link()
        players.append({
            "id": id_,
            "name": name,
            "experience": experience,
            "country": country,
            "rank": rank,
            "link": sim_link
        })

# Generate HTML content
html_content = """
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Top Country Players</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; }
        h1 { color: #333; }
        table { border-collapse: collapse; width: 100%; }
        th, td { text-align: left; padding: 8px; border: 1px solid #ddd; }
        th { background-color: #f4f4f4; }
        tr:hover { background-color: #f1f1f1; }
        a { color: #1a0dab; }
    </style>
</head>
<body>
    <h1>Top Country Players</h1>
    <table>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Experience</th>
            <th>Country</th>
            <th>Rank</th>
            <th>SIM Link</th>
        </tr>
"""

for player in players:
    html_content += f"""
        <tr>
            <td>{player['id']}</td>
            <td>{player['name']}</td>
            <td>{player['experience']}</td>
            <td>{player['country']}</td>
            <td>{player['rank']}</td>
            <td><a href="{player['link']}" target="_blank">Open</a></td>
        </tr>
    """

html_content += """
    </table>
</body>
</html>
"""

# Save to file
output_path = "/home/cnc/Desktop/GAME/top_players.html"
with open(output_path, "w") as f:
    f.write(html_content)

output_path
