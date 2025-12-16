import inspect
from twelvelabs import TwelveLabs
API_KEY = "tlk_1MYJ9F31G1EGRW25EG8SA0KT3742"
client = TwelveLabs(api_key=API_KEY)

print("Type of client.search:", type(client.search))
print("Dir of client.search:", dir(client.search))

try:
    print("\nSignature of client.search.query:")
    print(inspect.signature(client.search.query))
except:
    print("Could not get query signature")
