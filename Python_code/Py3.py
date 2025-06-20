import time
import random
import urllib.parse

# Sample data from user
input_text = """Top country players
  ID           Name                      Experience   Country Rank        
  4101331      Double.G                  960595       118     1680        
  4527152      aslan                     952415       118     1590        
  4635062      Teetayorrrhhh             953330       118     1587        
  9847525      richardebrain             810620       118     1538        
  52724277     lonely                    610515       118     1523        
  9892604      LordHOD123                1037460      118     1417        
  52660659     EmmyG                     415300       118     1378        
  9658358      help                      524340       118     1353        
  52694432     FreeNetworkTest           488030       118     1347        
  4550747      abkurfy                   763240       118     1303        
  9380543      Movic                     423725       118     1267        
  52790465     33s                       754375       118     1227        
  4832044      admin                     427550       118     1132        
  4389876      Sky√G™                    574160       118     1112        
  12916334     The_Infiltrator           271040       118     1079        
  9412785      yubby                     894470       118     1047        
  53641337     anon456                   596225       118     1041        
  9367188      SireDebajo                155535       118     1033        
  3749706      Chukwu                    838645       118     1030        
  53506480     ѧɢєṅṭċһıẓẓʏ               824230       118     1002        
  54211273     ck7                       313370       118     993         
  9438047      Megatone442              687210       118     974         
  52149566     Utilized_Trap             381830       118     969         
  51832828     SoulReaper                480115       118     962         
  52082633     smartfire                 496270       118     961         
  6261091      The_Strategist            234400       118     953         
  55023871     prion                     303365       118     937         
  51792818     aliyu                     312535       118     935         
  4244461      blackflamez               522525       118     914         
  9024254      WaitUntilFilled!          1076675      118     883         
  3322316      nerf*nachi                286080       118     882         
  3021621      Flash                     701955       118     879         
  52440148     RAVERS                    583505       118     875         
  13438618     T-☣☣☣☣                    127640       118     868         
  10318523     K.I.A.                    324720       118     867         
  52177361     Briggs                    545620       118     865         
  9673494      Mustang-BP                614705       118     862         
  55042653     debajo                    54185        118     861         
  4517451      Domnyk                    141400       118     860         
  9752414      ELIMINATOR                667955       118     854         
  6837427      </Swift>                  544055       118     850         
  14415846     100%FLAME                 64315        118     838         
  12285503     ibrahim                   553965       118     830         
  54361527     ✪Utilized_Trap✪           169755       118     803         
  51581343     ☠️☠️DIMITRI☠️☠️           233165       118     802         
  4089354      sҡʏ                       246865       118     796         
  11211388     M¥TH                      846110       118     795         
  4813072      Official                  120795       118     778         
  54470291     KayBee                    550585       118     773         
  4642796      alexandrsyniak            323520       118     771"""

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
