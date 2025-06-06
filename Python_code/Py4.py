import time
import random
import urllib.parse

# Sample data from user
input_text = """Top world players
  ID           Name                      Experience   Country Rank        
  4006385      cwsese                    1091375      127     9035        
  5457262      Unknown                   744530       160     1926        
  2184189      ║▌Ｏｘｙｇｅｎｅ▌║               949830       6       1892        
  6110802      Enuma-Elish               1157090      31      1892        
  3630012      WhoIam                    807225       136     1857        
  8877144      ☬CallMeSixFouR☬           873635       77      1846        
  53444367     Jasondange                1084045      172     1839        
  53795979     『MHU』KALKI                742075       76      1833        
  6566783      快使用雙截棍哼哼哈嘻                734445       172     1830        
  1325396      Unknown                   733755       126     1827        
  54486680     ༺Deadly♛Queen77༻          747765       6       1824        
  2627429      Unknown                   691555       153     1821        
  4970294      Unknown                   745860       160     1817        
  10025435     ⚫⚫                  852090       84      1817        
  3254622      Tymonias                  835795       10      1813        
  4545152      ☣☣(($QUORM$))☣☣           804175       22      1804        
  8386522      [hfp]Tsar                 941855       132     1796        
  11966986     ZaZen                     820210       132     1788        
  8869198      ffilian                   940530       59      1785        
  10000617     Chronos                   1153325      82      1780        
  3392140      Melkor                    948105       157     1776        
  5983635      Twilight.                 723125       36      1771        
  3165540      NICK                      771830       172     1769        
  3401754      MikeLangelo               691815       160     1766        
  4763851      M.R.Tanco                 854220       77      1759        
  10628366     ᗪ⟁ᖇKꪜ᳀☤ᗪ                  654790       6       1754        
  2558440      ＳＩＹＡＨ                     774765       157     1753        
  5089768      ฅ^•ﻌ•^ฅ                   843025       84      1751        
  1589257      Turkesh                   811565       163     1747        
  1520021      ฬย๒๒ค                     1030695      106     1747        
  3277134      mírαculíﾒ                 894560       55      1746        
  2100783      RiderHood                 926110       160     1742        
  515603       Wild                      730940       137     1741        
  5755340      Ergali                    700595       86      1741        
  3821845      Drasco                    834565       81      1739        
  7253794      [39FF14]ッ™ᴇʟᴇᴄᴛʀᴏ℠.*      1154675      123     1738        
  8024573      ๖ۣۜOȑ¡øñ~深淵               890220       6       1737        
  7448850      ΛzL                       991805       77      1736        
  13701312     GEMBEL*ELITE              992275       77      1736        
  4129816      ジェイソン                     688655       127     1728        
  3834105      ☣GARUDA☣                  945410       77      1727        
  3394063      JO$€PH                    1022005      125     1727        
  6796127      The5Dkiller               851290       75      1727        
  10887789     CLAY                      682510       4       1723        
  4326345      Moderator                 650510       104     1721        
  2179667      Vanga                     771990       132     1721        
  3888290      华人玩家Q群229620678           631440       36      1721        
  3133001      Kuttanthamb               986455       6       1720        
  4999815      bk1                       991200       74      1719        
  3264016      VEDIC3RDEYE               774215       119     1718        
  4306175      sTAiNLeSs                 809890       143     1718        
  3574476      Kashar                    834310       64      1718        
  4532426      ☣⛧666⛧☣                   808415       77      1717        
  5622244      [GoH]Morti                626875       160     1717        
  3803402      Userhie                   731145       77      1715        
  2936794      Michelangelo              889815       143     1714        
  16004        KILLNET                   1224965      132     1714        
  6623126      「Γהלותב-לזמ的萌莔酒           628370       172     1709        
  5917489      AEBMason                  1106360      120     1708        
  7235782      [hfp]Ascar                990065       132     1705        
  7205360      Lorin                     684790       132     1705        
  2390552      000                       1024390      6       1704        
  8008398      ÷£÷¥#&÷&&÷€÷£¥            881020       76      1704        
  7809262      jyptx                     797035       77      1703        
  4478177      ⽗ㄎᚺⴷⵎㄖ⽗                   839530       143     1701        
  52266913     ChoiCube=병신               856820       143     1701        
  53545271     ☭CCCP☭RUSSIA☭             624895       132     1700        
  3456852      Die                       709595       22      1699        
  53165576     ☣MR_ɄΝ$ΗΑΚΕΝ☣             704350       157     1696        
  4577313      EnesHardw                 1231655      157     1696        
  1570004      enigzma                   771915       127     1694        
  3858805      ☠꧁MΛƬƬΛЯΛ꧂☠               990860       106     1691        
  9390904      Sphinx                    757745       6       1691        
  5334389      Wolowitzart               712085       31      1691        
  4283975      Mr.Robot                  839975       76      1688        
  8071150      (╯°□°）╯彡┻━┻               857955       127     1687        
  9962272      Pucca                     1104035      106     1687        
  2687523      PCase                     801085       64      1686        
  4143170      martinus28                883775       114     1686        
  4500817      urangsakatige             869490       77      1686        
  4569826      |200T-K!T                 987120       162     1686        
  4318201      exiler                    921140       128     1684        
  3262440      ♘βᎯƦℳθℕ†ყ♞                820535       106     1684        
  1505309      Noobster<PL/UK>           859855       162     1682        
  2541909      Charquican                843765       35      1682        
  6838295      SpaceMen                  991470       132     1682        
  3537858      §Call•Me•Minh§            749700       167     1681        
  2221851      Shpilm№®                 991885       160     1681        
  8896430      ☣️ISUN☣️                  839015       77      1680        
  4101331      Double.G                  960595       118     1680        
  4481181      Klyr                      880415       31      1680        
  5624892      Fresh®                    745700       77      1680        
  3267928      GR☣F                      887400       48      1679        
  3617099      freedom                   715960       77      1677        
  4850622      $RECYCLE.BIN              641700       77      1677        
  3259186      kotans                    868065       132     1675        
  4936953      Kuruhaku                  643720       77      1675        
  3064126      ᏦᎥᎡᎯ™⇄☠                   943235       59      1675        
  52908448     JOKER玄                    852690       172     1675        
  3550217      \_(ಠ_ಠ)`__                828480       128     1674        
  2417367      Blockbreaker              959165       74      1674        
  3409869      GodKiller                 637780       77      1674        
  4238779      jabioX10                  709575       125     1673        
  1252122      Furious                   744465       23      1672        
  3188869      testerhuck                779235       56      1672        
  4575764      •|łυSıσηıSтαS             1063790      50      1672        
  2050271      GabeHCloud                769470       164     1671        
  7800128      >>>χΧ萌工智慧Χχ<<<            1048330      172     1670        
  12111        Jonah                     689950       163     1670        
  4753244      ⚡Crisis639⚡               1103090      106     1670        
  401020       TSan98                    1028340      163     1669        
  10643972     5DMatrix                  1082765      132     1669        
  2374423      ♤•♤£×pl0!t♤•♤             995625       6       1668        
  52822999     r0b0t0                    995920       166     1667        
  9415206      ෴☣️BL4cK۝H4wK☣️෴          771415       77      1667        
  2466498      Scummy                    811885       149     1667        
  3586292      terryBrugeHiplo           957520       164     1667        
  2190456      toescape                  893385       36      1666        
  5924811      nemisis                   931905       163     1664        
  6930259      mitro                     609720       160     1664        
  2772554      8.8.8.8/1                 727085       104     1664        
  12617415     CC5                       835355       64      1664        
  3807360      csnvX                     885985       132     1663        
  11787910     King99                    836075       77      1663        
  3403576      mase                      767190       64      1663        
  4634855      Colabano                  869530       129     1662        
  573419       doodles                   691315       22      1662        
  2799444      sepyx                     775150       59      1662        
  3111388      aL3x                      625715       23      1661        
  52749071     ᝃᵈᵉᶠ܈ʰᵉᵖᵗᵃᵖᵒᵈᝣ͠⁗          687650       137     1660        
  1881198      alexkip                   950240       22      1660        
  7375633      cicciojc                  910885       82      1658        
  8494943      Ketar_ketir               631385       77      1657        
  2129526      Quasar                    667915       22      1656        
  3486149      hakır                     717320       157     1655        
  5561590      ㅤn0̷t_Funㅤ                887055       77      1654        
  6287032      mitnick                   708750       128     1653        
  3794678      KILL                      1009440      36      1653        
  9682683      Zero                      846060       18      1652        
  51218939     {C}++                     1003775      77      1652        
  927671       plezcher                  643970       153     1650        
  2352554      Memo-Deno                 698430       157     1650        
  3343845      •|łυCıσηıSтαS7            1050990      155     1647        
  3913977      TheChuckNorris            1039805      89      1647        
  8387674      MrSuperuser               590205       76      1647        
  8888147      DkS:OSIRIS                599405       19      1646        
  2625491      nafig                     756995       45      1646        
  3844678      DarKScr33N                774215       42      1645        
  54643655     『MHU』typegift             581630       123     1645        
  4269346      hansoware                 814320       22      1645        
  4827487      ♕Blake♛                   904480       31      1643        
  555616       ReaperGamingZM            805725       169     1643        
  4788126      ᴊɪᴍᴍʏ                     1103665      77      1643        
  510799       Clostridium               939145       64      1643        
  3530971      t0r0piga                  872405       132     1643        
  53009908     HTA_BADAK                 759925       77      1642        
  2071619      hackerr                   669305       84      1641        
  3267040      escfoe2                   737455       163     1640        
  3669720      •makinG•                  640295       129     1640        
  53536168     Vidra                     1090365      59      1640        
  2601888      ррр                       771750       160     1638        
  2789989      Seema                     611755       136     1638        
  1575747      Bobs&Vegana               891005       130     1637        
  2549637      L€Π€ROCK€R                744730       166     1637        
  53537100     xiaoliyu                  1003120      36      1636        
  8535293      SALMAN                    1061670      134     1635        
  5664237      LEBRÓN                    667035       106     1634        
  155771       Sergey                    1054300      132     1634        
  403552       BLACKJESUS                1095180      163     1633        
  715781       14kubo12                  743195       46      1632        
  3609245      colombia.py               930790       37      1631        
  54277710     AsDOos                    649265       36      1631        
  1616739      Jahve                     799315       132     1630        
  7789163      ChoiCube84                940750       143     1629        
  7248866      ШАМАН                     1018635      132     1628        
  1241789      vestricio                 1057010      82      1628        
  3680928      DejaVu                    899380       136     1628        
  2014899      BONEK_SUROBOYO            677820       77      1627        
  3340710      Lola                      930785       64      1627        
  3572963      Purlilium                 856595       82      1626        
  4400516      Ranjiel                   690795       82      1625        
  5422362      RENA                      1225850      157     1625        
  384537       Kurticus                  922020       9       1625        
  4025365      iblitxkreig               851780       163     1625        
  83321        Restart                   1000160      162     1625        
  6879229      ෴☣️BL4cK۝H4wK☣️෴          731295       77      1623        
  1494786      acidwar                   990630       64      1622        
  6624720      Assassin                  600075       160     1622        
  2217780      mathkaczy                 956165       128     1622        
  4380534      GaMb3rRo                  716805       106     1621        
  3909483      alias                     672775       3       1620        
  3496655      madhive                   625325       9       1620        
  10320645     1d33p                    924115       36      1620        
  2561098      PIV#17                    730570       82      1620        
  1054337      TheNebulator              798295       31      1619        
  1841898      slim_shady                928795       129     1619        
  4540927      фыва                      1095790      132     1619        
  462407       Budge1x                   928155       163     1617        
  9843533      ෴☣️BL4cK۝H4wK☣️෴          827285       77      1617        
  4724850      Root_Chan                 989595       76      1617        
  5760750      ∆zL                       978550       77      1617        
  4734787      Sniper                    961115       157     1617        
  6254794      cyber.hack                1004385      59      1616        
  9027521      Pharaoh                   849005       51      1616        
  3836444      zartth                    857975       126     1615        
  3455521      xXMeJiHXx                 797240       157     1614        
  5038531      ꧁ঔৣ☬Gnersys☬ঔৣ꧂           734405       22      1614        
  3497684      めれゔぇはらだワ                  945480       157     1613        
  6205665      ─═☆ＲＡＶＥＮ☆═─               894390       77      1612        
  4388420      Ego                       736215       38      1610        
  4902865      Jimboozx                  685570       77      1609        
  13189744     LåÐ¥☮️ßµg                 572295       76      1608        
  2584248      Blade                     811315       129     1608        
  4904241      Shadow3312                625590       64      1607        
  3193418      Maltael                   1022320      64      1607        
  6543442      šťâľîn2005                770060       50      1607        
  54040686     Zoom                      748520       97      1607        
  3494821      hamit                     982545       157     1606        
  10867753     Dark_entries              735580       82      1606        
  8756647      The_Last_Hope             863695       77      1606        
  4647914      Mr.L                      747475       77      1605        
  7529640      Caner                     941695       157     1605        
  2432457      S3R10U5                   826525       22      1605        
  10113543     simple_form               1086250      46      1604        
  5534366      JOTA                      972560       126     1604        
  3612583      porkpiepeter              626965       115     1604        
  8089898      dorpheos                  944290       6       1604        
  3191836      ↙️☣️↗️                    1077695      77      1603        
  6792822      cpabro                    611405       160     1603        
  5373288      %\AMLet/%                 596070       132     1603        
  1952820      gius46                    625445       82      1602        
  1945271      bort1019                  880540       132     1602        
  7139062      wodejibahaoda             1039280      163     1602        
  7228257      architecture              1051410      143     1601        
  1483045      SecurityForce             1017210      76      1601        
  3720641      DemDema79                 999455       132     1601        
  6102234      osiris_hack               951850       84      1600        
  2853103      саид                      792275       132     1600        
  54042515     ㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤ          1072135      160     1600        
  8018371      Neo                       839710       126     1600        
  2197571      Sylvero                   654765       128     1598        
  3633771      !!iiiii!iii!!ii!          609455       172     1597        
  4528299      Hamurai                   693915       84      1597        
  721405       EcKhoX                    822520       37      1597        
  4050689      大风起                       754115       36      1597        
  2077380      ACX®                      830805       106     1597        
  680731       n00b                      990745       139     1597        
  6702562      hx0r                     765125       128     1596        
  2688071      strygwyr                  742580       59      1596        
  14191037     Polska                    842200       128     1595"""

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
