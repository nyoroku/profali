import requests

username = "profalithewitchdoctor"
token = "0c19ca39087ba7695d54b502de4167beb55c3b7b"
domain_name = "profalithewitchdoctor.pythonanywhere.com"

headers = {
    "Authorization": f"Token {token}"
}

versions = ["3.8", "3.9", "3.10", "3.11"]
for v in versions:
    url = f"https://www.pythonanywhere.com/api/v0/user/{username}/webapps/"
    data = {"domain_name": domain_name, "python_version": v}
    response = requests.post(url, headers=headers, data=data)
    if response.status_code == 201:
        print(f"Version {v} is supported and webapp created!")
        break
    else:
        print(f"Version {v} failed: {response.text}")
