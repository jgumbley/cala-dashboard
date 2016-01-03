from flask import Flask
from flask import render_template
import requests
import re
from bs4 import BeautifulSoup

app = Flask(__name__)

BUS_STOP_URL="http://netwm.mobi/departureboard;jsessionid=36A4EE1F341F2A433453F135844317FE.busmobile?stopCode=43000341602"

@app.route("/")
def hello():
    r=requests.get(BUS_STOP_URL)
    soup = BeautifulSoup(r.text, 'html.parser')
    times_of_buses = []
    for bustd in soup.find_all('td'):
        if "(RT)" in bustd.text:
            try:
                times_of_buses.append( 
                    re.search("[0-9]{1,2} mins", bustd.text).group(0)
                )
            except AttributeError:
                pass
    return render_template('hello.html', times_of_buses=times_of_buses)

if __name__ == "__main__":
    app.run(debug=True)
