import inspect
from twelvelabs import TwelveLabs
API_KEY = "tlk_1MYJ9F31G1EGRW25EG8SA0KT3742"
client = TwelveLabs(api_key=API_KEY)

print("Signature of client.generate:")
try:
    print(inspect.signature(client.generate))
except Exception as e:
    print(f"Could not get signature: {e}")

print("\nHelp on client.generate:")
help(client.generate)
