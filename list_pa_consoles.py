import requests

username = "profalithewitchdoctor"
token = "0c19ca39087ba7695d54b502de4167beb55c3b7b"

headers = {
    "Authorization": f"Token {token}"
}

url = f"https://www.pythonanywhere.com/api/v0/user/{username}/consoles/"
response = requests.get(url, headers=headers)
print("Consoles:")
print(response.json())
